from typing import Any
from pydantic import BaseModel, ConfigDict


class EventCreate(BaseModel):
    name: str
    public_payload: dict[str, Any]
    caver_payload: dict[str, Any] = {}
    scientific_payload: dict[str, Any] = {}


class EventRead(BaseModel):
    id: int
    name: str
    public_payload: dict[str, Any]
    caver_payload: dict[str, Any] | None = None
    scientific_payload: dict[str, Any] | None = None

    model_config = ConfigDict(from_attributes=True)


class EventFilter(BaseModel):
    kind: str | None = None
    region: str | None = None
    min_length: int | None = None
    max_length: int | None = None
    protected: bool | None = None
