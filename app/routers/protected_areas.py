from typing import Annotated

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session
from geoalchemy2.functions import ST_AsGeoJSON

from app.auth import AuthContext, require_any
from app.database import get_db
from app.models import ProtectedArea
from app.schemas import ProtectedAreaRead

router = APIRouter(prefix="/protected-areas", tags=["protected-areas"])


@router.get("", response_model=list[ProtectedAreaRead])
def list_protected_areas(
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("caves:read"))] = None,
):
    stmt = select(
        ProtectedArea.id, ProtectedArea.name,
        ST_AsGeoJSON(ProtectedArea.geom).label("geom"),
        ProtectedArea.payload,
    )
    rows = db.execute(stmt).mappings().all()
    return [ProtectedAreaRead(**row) for row in rows]
