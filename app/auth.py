import os
import httpx
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

VALID_ROLES = {"admin", "user", "caver", "researcher"}

_bearer = HTTPBearer()


@lru_cache(maxsize=1)
def _get_jwks() -> dict:
    url = f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}/protocol/openid-connect/certs"
    response = httpx.get(url, timeout=10)
    response.raise_for_status()
    return response.json()


EXPECTED_ISSUER = f"{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}"


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
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"Invalid token: {e}")

    if claims.get("azp") != KEYCLOAK_CLIENT_ID:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail=f"Token not issued for this client (azp={claims.get('azp')!r})",
        )

    return claims


def get_current_role(
    credentials: Annotated[HTTPAuthorizationCredentials, Depends(_bearer)],
) -> str:
    claims = _decode_token(credentials.credentials)
    realm_roles: list[str] = claims.get("realm_access", {}).get("roles", [])

    for role in ("admin", "researcher", "caver", "user"):
        if role in realm_roles:
            return role

    raise HTTPException(
        status_code=status.HTTP_403_FORBIDDEN,
        detail=f"Token has no recognised role. Expected one of: {sorted(VALID_ROLES)}",
    )


def serialize_event(event: Event, role: str) -> EventRead:
    caver_data = dict(event.caver_payload) if role in {"caver", "researcher", "admin"} else None
    scientific_data = dict(event.scientific_payload) if role in {"researcher", "admin"} else None

    return EventRead(
        id=event.id,
        name=event.name,
        public_payload=dict(event.public_payload),
        caver_payload=caver_data,
        scientific_payload=scientific_data,
    )
