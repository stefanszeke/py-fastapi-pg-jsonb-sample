from typing import Any
from pydantic import BaseModel, ConfigDict


class CaveRead(BaseModel):
    id: int
    name: str
    lon: float
    lat: float
    type: str
    depth_m: int | None = None
    region: str

    model_config = ConfigDict(from_attributes=True)


class EventCreate(BaseModel):
    cave_id: int
    name: str
    public_payload: dict[str, Any]
    caver_payload: dict[str, Any] = {}
    scientific_payload: dict[str, Any] = {}


class EventRead(BaseModel):
    id: int
    cave_id: int
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
