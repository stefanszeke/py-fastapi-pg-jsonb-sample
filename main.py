from typing import Annotated
from fastapi import Depends, FastAPI, Query
from pydantic import BaseModel
from sqlalchemy import select, cast, Integer
from sqlalchemy.orm import Session

from auth import get_current_role, serialize_event
from database import Base, engine, get_db
from models import Event
from schemas import EventCreate, EventRead

Base.metadata.create_all(bind=engine)

app = FastAPI()


@app.get("/")
def root():
    return {"status": "ok"}

@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/events", response_model=EventRead)
def create_event(data: EventCreate, db: Session = Depends(get_db)):
    event = Event(name=data.name, payload=data.payload)
    db.add(event)
    db.commit()
    db.refresh(event)
    return event


@app.get("/events", response_model=list[EventRead])
def list_events(
    db: Session = Depends(get_db),
    role: Annotated[str, Depends(get_current_role)] = "user",
):
    events = db.scalars(select(Event).order_by(Event.id)).all()
    return [serialize_event(e, role) for e in events]


@app.get("/events/by-kind/{kind}", response_model=list[EventRead])
def events_by_kind(
    kind: str,
    db: Session = Depends(get_db),
    role: Annotated[str, Depends(get_current_role)] = "user",
):
    stmt = select(Event).where(Event.payload["kind"].astext == kind)
    events = db.scalars(stmt).all()
    return [serialize_event(e, role) for e in events]

@app.get("/events/longer-than/{min_length}", response_model=list[EventRead])
def events_longer_than(
    min_length: int,
    db: Session = Depends(get_db),
    role: Annotated[str, Depends(get_current_role)] = "user",
):
    stmt = select(Event).where(
        cast(Event.payload["length_m"].astext, Integer) > min_length
    )
    events = db.scalars(stmt).all()
    return [serialize_event(e, role) for e in events]

class EventFilter(BaseModel):
    kind: str | None = None
    region: str | None = None
    min_length: int | None = None
    max_length: int | None = None
    protected: bool | None = None

@app.get("/events/filter", response_model=list[EventRead])
def filter_events(
    filters: Annotated[EventFilter, Query()],
    db: Session = Depends(get_db),
    role: Annotated[str, Depends(get_current_role)] = "user",
):
    stmt = select(Event)

    if filters.kind is not None:
        stmt = stmt.where(Event.payload["kind"].astext == filters.kind)

    if filters.region is not None:
        stmt = stmt.where(Event.payload["region"].astext == filters.region)

    if filters.min_length is not None:
        stmt = stmt.where(
            cast(Event.payload["length_m"].astext, Integer) >= filters.min_length
        )

    if filters.max_length is not None:
        stmt = stmt.where(
            cast(Event.payload["length_m"].astext, Integer) <= filters.max_length
        )

    if filters.protected is not None:
        stmt = stmt.where(
            Event.payload["meta"]["protected"].astext == str(filters.protected).lower()
        )

    events = db.scalars(stmt).all()
    return [serialize_event(e, role) for e in events]