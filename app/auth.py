import os
import time
import httpx
from dataclasses import dataclass, field
from typing import Annotated

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError
from sqlalchemy import select

from app.models import Event

# -- Keycloak config ----------------------------------------------------------
KEYCLOAK_URL = os.getenv("KEYCLOAK_URL", "http://localhost:8081")
KEYCLOAK_REALM = os.getenv("KEYCLOAK_REALM", "caves")
KEYCLOAK_CLIENT_ID = os.getenv("KEYCLOAK_CLIENT_ID", "caves-api")
EXPECTED_ISSUER = f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}"

_bearer = HTTPBearer()


# -- Auth context -------------------------------------------------------------
@dataclass
class AuthContext:
    username: str
    permissions: set[str] = field(default_factory=set)

    def has_any(self, *perms: str) -> bool:
        return bool(self.permissions & set(perms))

    def has_all(self, *perms: str) -> bool:
        return set(perms).issubset(self.permissions)


# -- JWKS cache ---------------------------------------------------------------
# Keycloak's public signing keys are fetched once and cached.
# Two things can trigger a refresh:
#   - TTL expired (JWKS_TTL_SECONDS, default 1 hour)
#   - Token arrives with a kid not in the cache → key rotation detected
_JWKS_TTL = int(os.getenv("JWKS_TTL_SECONDS", "3600"))
_jwks_cache: dict = {}
_jwks_fetched_at: float = 0.0


def _get_jwks(force: bool = False) -> dict:
    global _jwks_cache, _jwks_fetched_at
    if force or not _jwks_cache or time.time() - _jwks_fetched_at > _JWKS_TTL:
        url = f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}/protocol/openid-connect/certs"
        r = httpx.get(url, timeout=10)
        r.raise_for_status()
        _jwks_cache = r.json()
        _jwks_fetched_at = time.time()
    return _jwks_cache


def _cached_kids() -> set[str]:
    return {k.get("kid") for k in _jwks_cache.get("keys", []) if k.get("kid")}


# -- Token decoding -----------------------------------------------------------
def _decode_token(token: str) -> dict:
    try:
        kid = jwt.get_unverified_header(token).get("kid")
    except JWTError as e:
        print(f"JWT header parse failed: {e}")  # TODO: replace with proper logger
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")

    jwks = _get_jwks(force=kid not in _cached_kids())

    try:
        claims = jwt.decode(
            token,
            jwks,
            algorithms=["RS256"],
            issuer=EXPECTED_ISSUER,
            options={"verify_aud": False},
        )
    except JWTError as e:
        print(f"JWT decode failed: {e}")  # TODO: replace with proper logger
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")

    if claims.get("azp") != KEYCLOAK_CLIENT_ID:
        print(f"JWT azp mismatch: expected={KEYCLOAK_CLIENT_ID!r} got={claims.get('azp')!r}")  # TODO: replace with proper logger
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")

    return claims


# -- FastAPI dependency -------------------------------------------------------
def get_auth(
    credentials: Annotated[HTTPAuthorizationCredentials, Depends(_bearer)],
) -> AuthContext:
    claims = _decode_token(credentials.credentials)

    # Client roles on caves-api are the source of truth for API permissions.
    # Keycloak puts client roles under resource_access, not realm_access.
    client_roles: set[str] = set(
        claims.get("resource_access", {}).get(KEYCLOAK_CLIENT_ID, {}).get("roles", [])
    )

    if not client_roles:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Token has no permissions for this API",
        )

    return AuthContext(
        username=claims.get("preferred_username", "unknown"),
        permissions=client_roles,
    )


# -- Authorization guard ------------------------------------------------------
def require_any(*permissions: str):
    """Dependency factory: passes if the token holds at least one of the given permissions."""
    def checker(auth: Annotated[AuthContext, Depends(get_auth)]) -> AuthContext:
        if not auth.has_any(*permissions):
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Forbidden")
        return auth
    return checker


# -- Role-aware SQL projection ------------------------------------------------
def event_select_for(auth: AuthContext):
    """Return a SELECT that only fetches columns the caller is allowed to read."""
    columns = [Event.id, Event.name, Event.public_payload]

    if auth.has_any("events:read_caver", "events:read_scientific"):
        columns.append(Event.caver_payload)

    if auth.has_any("events:read_scientific"):
        columns.append(Event.scientific_payload)

    return select(*columns)
