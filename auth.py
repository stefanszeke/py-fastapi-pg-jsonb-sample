from typing import Annotated
from fastapi import Header, HTTPException
from models import Event
from schemas import EventRead


def get_current_role(x_role: Annotated[str | None, Header()] = None) -> str:
    # For local testing:
    # - if header missing, treat as normal user
    # - allowed values: "admin" or "user"
    if x_role is None:
        return "user"

    if x_role not in {"admin", "user"}:
        raise HTTPException(status_code=400, detail="Invalid X-Role header")

    return x_role


def serialize_event(event: Event, role: str) -> EventRead:
    # shallow copy
    payload = dict(event.payload)
    meta = dict(payload.get("meta", {}))

    if role != "admin":
        meta.pop("secret", None)

    if meta:
        payload["meta"] = meta
    else:
        payload.pop("meta", None)

    return EventRead(
        id=event.id,
        name=event.name,
        payload=payload,
    )
