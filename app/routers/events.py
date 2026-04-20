from typing import Annotated
from fastapi import APIRouter, Depends, Query
from sqlalchemy import select, cast, Integer
from sqlalchemy.orm import Session

from app.auth import AuthContext, get_auth, serialize_event
from app.database import get_db
from app.models import Event
from app.schemas import EventCreate, EventRead, EventFilter

router = APIRouter(prefix="/events", tags=["events"])


@router.post("", response_model=EventRead)
def create_event(data: EventCreate, db: Session = Depends(get_db)):
    event = Event(
        name=data.name,
        public_payload=data.public_payload,
        caver_payload=data.caver_payload,
        scientific_payload=data.scientific_payload,
    )
    db.add(event)
    db.commit()
    db.refresh(event)
    return event


@router.get("", response_model=list[EventRead])
def list_events(
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(get_auth)] = None,
):
    events = db.scalars(select(Event).order_by(Event.id)).all()
    return [serialize_event(e, auth) for e in events]


@router.get("/by-kind/{kind}", response_model=list[EventRead])
def events_by_kind(
    kind: str,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(get_auth)] = None,
):
    stmt = select(Event).where(Event.public_payload["kind"].astext == kind)
    events = db.scalars(stmt).all()
    return [serialize_event(e, auth) for e in events]


@router.get("/longer-than/{min_length}", response_model=list[EventRead])
def events_longer_than(
    min_length: int,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(get_auth)] = None,
):
    stmt = select(Event).where(
        cast(Event.caver_payload["length_m"].astext, Integer) > min_length
    )
    events = db.scalars(stmt).all()
    return [serialize_event(e, auth) for e in events]


@router.get("/filter", response_model=list[EventRead])
def filter_events(
    filters: Annotated[EventFilter, Query()],
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(get_auth)] = None,
):
    stmt = select(Event)

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

    events = db.scalars(stmt).all()
    return [serialize_event(e, auth) for e in events]
