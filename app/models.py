import uuid
from datetime import date, datetime
from typing import Any

from sqlalchemy import Boolean, Date, DateTime, ForeignKey, Numeric, String, func, text
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column
from geoalchemy2 import Geometry

from app.database import Base


class Cave(Base):
    __tablename__ = "caves"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, server_default=text("gen_random_uuid()"))
    name: Mapped[str] = mapped_column(String(150), nullable=False)
    cave_type: Mapped[str] = mapped_column(String(80), nullable=False)
    region: Mapped[str] = mapped_column(String(100), nullable=False)
    municipality: Mapped[str | None] = mapped_column(String(100))
    geom: Mapped[Any] = mapped_column(Geometry("POINT", srid=4326), nullable=False)
    length_m: Mapped[float | None] = mapped_column(Numeric)
    depth_m: Mapped[float | None] = mapped_column(Numeric)
    is_public: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)
    sensitivity_level: Mapped[str] = mapped_column(String(50), nullable=False, default="restricted")
    payload: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class CaveSurvey(Base):
    __tablename__ = "cave_surveys"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, server_default=text("gen_random_uuid()"))
    cave_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("caves.id"), nullable=False)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    public_payload: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)
    caver_payload: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)
    scientific_payload: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)
    created_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), server_default=func.now())


class CaveEntrance(Base):
    __tablename__ = "cave_entrances"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, server_default=text("gen_random_uuid()"))
    cave_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("caves.id"), nullable=False)
    name: Mapped[str | None] = mapped_column(String(150))
    geom: Mapped[Any] = mapped_column(Geometry("POINT", srid=4326), nullable=False)
    entrance_type: Mapped[str | None] = mapped_column(String(80))
    is_public: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False)


class CaveSurveyLine(Base):
    __tablename__ = "cave_survey_lines"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, server_default=text("gen_random_uuid()"))
    cave_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("caves.id"), nullable=False)
    geom: Mapped[Any] = mapped_column(Geometry("LINESTRING", srid=4326), nullable=False)
    payload: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)


class Sensor(Base):
    __tablename__ = "sensors"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, server_default=text("gen_random_uuid()"))
    cave_id: Mapped[uuid.UUID] = mapped_column(ForeignKey("caves.id"), nullable=False)
    sensor_code: Mapped[str] = mapped_column(String(50), nullable=False, unique=True)
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    description: Mapped[str | None] = mapped_column(String(500))
    installed_at: Mapped[date | None] = mapped_column(Date)


class ProtectedArea(Base):
    __tablename__ = "protected_areas"

    id: Mapped[uuid.UUID] = mapped_column(primary_key=True, server_default=text("gen_random_uuid()"))
    name: Mapped[str] = mapped_column(String(200), nullable=False)
    geom: Mapped[Any] = mapped_column(Geometry("MULTIPOLYGON", srid=4326), nullable=False)
    payload: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)
