from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import cast, Integer
from sqlalchemy.orm import Session

from app.auth import AuthContext, event_select_for, require_any
from app.database import get_db
from app.models import Event
from app.schemas import EventCreate, EventRead, EventFilter

router = APIRouter(prefix="/events", tags=["events"])


@router.post("", response_model=EventRead)
def create_event(
    data: EventCreate,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("events:create"))] = None,
):
    event = Event(
        name=data.name,
        public_payload=data.public_payload,
        caver_payload=data.caver_payload,
        scientific_payload=data.scientific_payload,
    )
    db.add(event)
    db.commit()
    db.refresh(event)
    row = db.execute(event_select_for(auth).where(Event.id == event.id)).mappings().one()
    return EventRead(**row)


@router.get("", response_model=list[EventRead])
def list_events(
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("events:read"))] = None,
):
    rows = db.execute(event_select_for(auth).order_by(Event.id)).mappings().all()
    return [EventRead(**row) for row in rows]


@router.get("/by-kind/{kind}", response_model=list[EventRead])
def events_by_kind(
    kind: str,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("events:read"))] = None,
):
    stmt = event_select_for(auth).where(Event.public_payload["kind"].astext == kind)
    rows = db.execute(stmt).mappings().all()
    return [EventRead(**row) for row in rows]


@router.get("/longer-than/{min_length}", response_model=list[EventRead])
def events_longer_than(
    min_length: int,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("events:read_caver"))] = None,
):
    stmt = event_select_for(auth).where(
        cast(Event.caver_payload["length_m"].astext, Integer) > min_length
    )
    rows = db.execute(stmt).mappings().all()
    return [EventRead(**row) for row in rows]


@router.get("/filter", response_model=list[EventRead])
def filter_events(
    filters: Annotated[EventFilter, Query()],
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("events:read"))] = None,
):
    uses_caver_filter = filters.min_length is not None or filters.max_length is not None
    if uses_caver_filter and not auth.has_any("events:read_caver"):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Forbidden")

    stmt = event_select_for(auth)

    if filters.kind is not None:
        stmt = stmt.where(Event.public_payload["kind"].astext == filters.kind)

    if filters.region is not None:
        stmt = stmt.where(Event.public_payload["region"].astext == filters.region)

    if filters.min_length is not None:
        stmt = stmt.where(
            cast(Event.caver_payload["length_m"].astext, Integer) >= filters.min_length
        )

    if filters.max_length is not None:
        stmt = stmt.where(
            cast(Event.caver_payload["length_m"].astext, Integer) <= filters.max_length
        )

    if filters.protected is not None:
        stmt = stmt.where(
            Event.public_payload["protected"].astext == str(filters.protected).lower()
        )

    rows = db.execute(stmt).mappings().all()
    return [EventRead(**row) for row in rows]
