from typing import Annotated

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session
from geoalchemy2.functions import ST_X, ST_Y, ST_SnapToGrid

from app.auth import AuthContext, require_any
from app.database import get_db
from app.models import CaveEntrance
from app.schemas import CaveEntranceRead

router = APIRouter(prefix="/entrances", tags=["entrances"])


def _entrance_stmt(auth: AuthContext):
    exact = auth.has_any("caves:read_restricted")

    if exact:
        lon_col = ST_X(CaveEntrance.geom).label("lon")
        lat_col = ST_Y(CaveEntrance.geom).label("lat")
    else:
        lon_col = ST_X(ST_SnapToGrid(CaveEntrance.geom, 0.05)).label("lon")
        lat_col = ST_Y(ST_SnapToGrid(CaveEntrance.geom, 0.05)).label("lat")

    stmt = select(
        CaveEntrance.id, CaveEntrance.cave_id, CaveEntrance.name,
        lon_col, lat_col, CaveEntrance.entrance_type, CaveEntrance.is_public,
    )

    if not exact:
        stmt = stmt.where(CaveEntrance.is_public == True)

    return stmt


@router.get("", response_model=list[CaveEntranceRead])
def list_entrances(
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("caves:read"))] = None,
):
    rows = db.execute(_entrance_stmt(auth)).mappings().all()
    return [CaveEntranceRead(**row) for row in rows]


@router.get("/by-cave/{cave_id}", response_model=list[CaveEntranceRead])
def entrances_by_cave(
    cave_id: str,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("caves:read"))] = None,
):
    stmt = _entrance_stmt(auth).where(CaveEntrance.cave_id == cave_id)
    rows = db.execute(stmt).mappings().all()
    return [CaveEntranceRead(**row) for row in rows]
