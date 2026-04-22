from sqlalchemy import Integer, String, Numeric, ForeignKey
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class Cave(Base):
    __tablename__ = "caves"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(150), nullable=False)
    lon: Mapped[float] = mapped_column(Numeric(9, 6), nullable=False)
    lat: Mapped[float] = mapped_column(Numeric(9, 6), nullable=False)
    type: Mapped[str] = mapped_column(String(80), nullable=False)
    depth_m: Mapped[int | None] = mapped_column(Integer, nullable=True)
    region: Mapped[str] = mapped_column(String(100), nullable=False)


class Event(Base):
    __tablename__ = "events"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    cave_id: Mapped[int] = mapped_column(Integer, ForeignKey("caves.id"), nullable=False)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    public_payload: Mapped[dict] = mapped_column(JSONB, nullable=False)
    caver_payload: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)
    scientific_payload: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)
