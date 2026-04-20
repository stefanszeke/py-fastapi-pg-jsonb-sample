from sqlalchemy import Integer, String
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column

from app.database import Base


class Event(Base):
    __tablename__ = "events"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)
    public_payload: Mapped[dict] = mapped_column(JSONB, nullable=False)
    caver_payload: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)
    scientific_payload: Mapped[dict] = mapped_column(JSONB, nullable=False, default=dict)
