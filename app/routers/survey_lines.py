from typing import Annotated

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session
from geoalchemy2.functions import ST_AsGeoJSON

from app.auth import AuthContext, require_any
from app.database import get_db
from app.models import CaveSurveyLine
from app.schemas import CaveSurveyLineRead

router = APIRouter(prefix="/survey-lines", tags=["survey-lines"])


@router.get("", response_model=list[CaveSurveyLineRead])
def list_survey_lines(
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("surveys:read_caver"))] = None,
):
    stmt = select(
        CaveSurveyLine.id, CaveSurveyLine.cave_id,
        ST_AsGeoJSON(CaveSurveyLine.geom).label("geom"),
        CaveSurveyLine.payload,
    )
    rows = db.execute(stmt).mappings().all()
    return [CaveSurveyLineRead(**row) for row in rows]


@router.get("/by-cave/{cave_id}", response_model=list[CaveSurveyLineRead])
def survey_lines_by_cave(
    cave_id: str,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("surveys:read_caver"))] = None,
):
    stmt = select(
        CaveSurveyLine.id, CaveSurveyLine.cave_id,
        ST_AsGeoJSON(CaveSurveyLine.geom).label("geom"),
        CaveSurveyLine.payload,
    ).where(CaveSurveyLine.cave_id == cave_id)
    rows = db.execute(stmt).mappings().all()
    return [CaveSurveyLineRead(**row) for row in rows]
