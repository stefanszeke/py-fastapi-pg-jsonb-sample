from typing import Annotated

from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from geoalchemy2.functions import ST_X, ST_Y

from app.auth import AuthContext, require_any
from app.database import get_db
from app.models import Cave
from app.schemas import CaveRead

from sqlalchemy import select

router = APIRouter(prefix="/caves", tags=["caves"])


@router.get("", response_model=list[CaveRead])
def list_caves(
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("caves:read"))] = None,
):
    exact = auth.has_any("caves:read_restricted")

    stmt = select(
        Cave.id, Cave.name,
        ST_X(Cave.geom).label("lon"),
        ST_Y(Cave.geom).label("lat"),
        Cave.cave_type, Cave.region, Cave.municipality,
        Cave.length_m, Cave.depth_m, Cave.is_public, Cave.sensitivity_level,
    )

    if not exact:
        stmt = stmt.where(Cave.is_public == True)

    rows = db.execute(stmt.order_by(Cave.name)).mappings().all()
    return [CaveRead(**row) for row in rows]
