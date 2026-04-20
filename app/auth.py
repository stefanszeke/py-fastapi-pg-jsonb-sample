import os
import time
import httpx
from dataclasses import dataclass, field
from typing import Annotated

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError

from app.models import Event
from app.schemas import EventRead

# -- Keycloak config ----------------------------------------------------------
KEYCLOAK_URL = os.getenv("KEYCLOAK_URL", "http://localhost:8081")
KEYCLOAK_REALM = os.getenv("KEYCLOAK_REALM", "caves")
KEYCLOAK_CLIENT_ID = os.getenv("KEYCLOAK_CLIENT_ID", "caves-api")
EXPECTED_ISSUER = f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}"  # matched against token "iss" claim

# Only these roles are meaningful to the app; all other Keycloak built-ins are ignored.
VALID_ROLES = {"admin", "user", "caver", "researcher"}

_bearer = HTTPBearer()


# -- Auth context -------------------------------------------------------------
# Passed to every route after the token is verified.
# Holds the full role set so routes can do compound checks via has_role().
@dataclass
class AuthContext:
    username: str
    roles: set[str] = field(default_factory=set)

    def has_role(self, *roles: str) -> bool:
        """Return True if the user holds at least one of the given roles."""
        return bool(self.roles & set(roles))


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
    # Read kid from header (no signature check) to decide whether to refresh JWKS.
    try:
        kid = jwt.get_unverified_header(token).get("kid")
    except JWTError as e:
        print(f"JWT header parse failed: {e}")  # TODO: replace with proper logger
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")

    # Unknown kid means Keycloak rotated its keys — fetch fresh JWKS before decoding.
    jwks = _get_jwks(force=kid not in _cached_kids())

    try:
        claims = jwt.decode(
            token,
            jwks,
            algorithms=["RS256"],
            issuer=EXPECTED_ISSUER,
            options={"verify_aud": False},  # public clients set aud="account"; we check azp instead
        )
    except JWTError as e:
        print(f"JWT decode failed: {e}")  # TODO: replace with proper logger
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")

    # azp (authorized party) identifies the client the token was issued for.
    if claims.get("azp") != KEYCLOAK_CLIENT_ID:
        print(f"JWT azp mismatch: expected={KEYCLOAK_CLIENT_ID!r} got={claims.get('azp')!r}")  # TODO: replace with proper logger
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")

    return claims


# -- FastAPI dependency -------------------------------------------------------
def get_auth(
    credentials: Annotated[HTTPAuthorizationCredentials, Depends(_bearer)],
) -> AuthContext:
    claims = _decode_token(credentials.credentials)

    # Strip Keycloak built-ins, keep only app roles.
    all_roles: set[str] = set(claims.get("realm_access", {}).get("roles", []))
    app_roles = all_roles & VALID_ROLES

    if not app_roles:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=f"Token has no recognized role. Expected one of: {sorted(VALID_ROLES)}",
        )

    return AuthContext(
        username=claims.get("preferred_username", "unknown"),
        roles=app_roles,
    )


# -- Serialization ------------------------------------------------------------
def serialize_event(event: Event, auth: AuthContext) -> EventRead:
    caver_data = dict(event.caver_payload) if auth.has_role("caver", "researcher", "admin") else None
    scientific_data = dict(event.scientific_payload) if auth.has_role("researcher", "admin") else None

    return EventRead(
        id=event.id,
        name=event.name,
        public_payload=dict(event.public_payload),
        caver_payload=caver_data,
        scientific_payload=scientific_data,
    )
