from typing import Any
from uuid import UUID

from pydantic import BaseModel, ConfigDict


class CaveRead(BaseModel):
    id: UUID
    name: str
    lon: float
    lat: float
    cave_type: str
    region: str
    municipality: str | None = None
    length_m: float | None = None
    depth_m: float | None = None
    is_public: bool
    sensitivity_level: str

    model_config = ConfigDict(from_attributes=True)


class CaveSurveyCreate(BaseModel):
    cave_id: UUID
    name: str
    public_payload: dict[str, Any]
    caver_payload: dict[str, Any] = {}
    scientific_payload: dict[str, Any] = {}


class CaveSurveyRead(BaseModel):
    id: UUID
    cave_id: UUID
    name: str
    public_payload: dict[str, Any]
    caver_payload: dict[str, Any] | None = None
    scientific_payload: dict[str, Any] | None = None

    model_config = ConfigDict(from_attributes=True)


class CaveSurveyFilter(BaseModel):
    kind: str | None = None
    region: str | None = None
    min_length: int | None = None
    max_length: int | None = None
    protected: bool | None = None


class CaveEntranceRead(BaseModel):
    id: UUID
    cave_id: UUID
    name: str | None = None
    lon: float
    lat: float
    entrance_type: str | None = None
    is_public: bool

    model_config = ConfigDict(from_attributes=True)


class CaveSurveyLineRead(BaseModel):
    id: UUID
    cave_id: UUID
    geom: str  # GeoJSON
    payload: dict[str, Any]

    model_config = ConfigDict(from_attributes=True)


class ProtectedAreaRead(BaseModel):
    id: UUID
    name: str
    geom: str  # GeoJSON
    payload: dict[str, Any]

    model_config = ConfigDict(from_attributes=True)
