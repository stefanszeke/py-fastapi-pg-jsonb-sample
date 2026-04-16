from typing import Any
from pydantic import BaseModel, ConfigDict


class EventCreate(BaseModel):
    name: str
    payload: dict[str, Any]


class EventRead(BaseModel):
    id: int
    name: str
    payload: dict[str, Any]

    model_config = ConfigDict(from_attributes=True)