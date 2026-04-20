import os
import httpx
from dataclasses import dataclass, field
from functools import lru_cache
from typing import Annotated

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError

from app.models import Event
from app.schemas import EventRead

KEYCLOAK_URL = os.getenv("KEYCLOAK_URL", "http://localhost:8081")
KEYCLOAK_REALM = os.getenv("KEYCLOAK_REALM", "caves")
KEYCLOAK_CLIENT_ID = os.getenv("KEYCLOAK_CLIENT_ID", "caves-api")
EXPECTED_ISSUER = f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}"

VALID_ROLES = {"admin", "user", "caver", "researcher"}

_bearer = HTTPBearer()


@dataclass
class AuthContext:
    username: str
    roles: set[str] = field(default_factory=set)

    def has_role(self, *roles: str) -> bool:
        return bool(self.roles & set(roles))


@lru_cache(maxsize=1)
def _get_jwks() -> dict:
    url = f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}/protocol/openid-connect/certs"
    response = httpx.get(url, timeout=10)
    response.raise_for_status()
    return response.json()


def _decode_token(token: str) -> dict:
    try:
        claims = jwt.decode(
            token,
            _get_jwks(),
            algorithms=["RS256"],
            issuer=EXPECTED_ISSUER,
            options={"verify_aud": False},  # aud="account" for public clients; we check azp below
        )
    except JWTError as e:
        # TODO: replace with proper logger (e.g. logger.warning("JWT decode failed: %s", e))
        print(f"JWT decode failed: {e}")
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")

    if claims.get("azp") != KEYCLOAK_CLIENT_ID:
        # TODO: replace with proper logger
        print(f"JWT azp mismatch: expected={KEYCLOAK_CLIENT_ID!r} got={claims.get('azp')!r}")
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid or expired token")

    return claims


def get_auth(
    credentials: Annotated[HTTPAuthorizationCredentials, Depends(_bearer)],
) -> AuthContext:
    claims = _decode_token(credentials.credentials)

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
