from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select, text
from sqlalchemy.orm import Session

from app.auth import AuthContext, require_any
from app.database import get_db
from app.models import Sensor
from app.schemas import SensorHourlyReading, SensorRawReading, SensorRead

router = APIRouter(tags=["sensors"])


@router.get("/sensors/by-cave/{cave_id}", response_model=list[SensorRead])
def sensors_by_cave(
    cave_id: UUID,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("surveys:read_scientific"))] = None,
):
    rows = db.execute(
        select(Sensor).where(Sensor.cave_id == cave_id).order_by(Sensor.sensor_code)
    ).scalars().all()
    return rows


@router.get("/sensor-readings/{sensor_id}/raw", response_model=list[SensorRawReading])
def sensor_readings_raw(
    sensor_id: UUID,
    hours: int = Query(default=24, ge=1, le=168),
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("surveys:read_scientific"))] = None,
):
    rows = db.execute(
        text("""
            SELECT measured_at, temperature, humidity, co2
            FROM cave_sensor_readings
            WHERE sensor_id = :sensor_id
              AND measured_at > now() - make_interval(hours => :hours)
            ORDER BY measured_at
        """),
        {"sensor_id": str(sensor_id), "hours": hours},
    ).mappings().all()
    return [SensorRawReading(**r) for r in rows]


@router.get("/sensor-readings/{sensor_id}/hourly", response_model=list[SensorHourlyReading])
def sensor_readings_hourly(
    sensor_id: UUID,
    days: int = Query(default=7, ge=1, le=90),
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("surveys:read_scientific"))] = None,
):
    rows = db.execute(
        text("""
            SELECT hour, avg_temp, min_temp, max_temp, avg_humidity, avg_co2, reading_count
            FROM sensor_readings_hourly
            WHERE sensor_id = :sensor_id
              AND hour > now() - make_interval(days => :days)
            ORDER BY hour
        """),
        {"sensor_id": str(sensor_id), "days": days},
    ).mappings().all()
    return [SensorHourlyReading(**r) for r in rows]
