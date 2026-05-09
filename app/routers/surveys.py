from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy import cast, Integer
from sqlalchemy.orm import Session

from app.auth import AuthContext, survey_select_for, require_any
from app.database import get_db
from app.models import CaveSurvey
from app.schemas import CaveSurveyCreate, CaveSurveyRead, CaveSurveyFilter

router = APIRouter(prefix="/surveys", tags=["surveys"])


@router.post("", response_model=CaveSurveyRead)
def create_survey(
    data: CaveSurveyCreate,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("surveys:create"))] = None,
):
    survey = CaveSurvey(
        cave_id=data.cave_id,
        name=data.name,
        public_payload=data.public_payload,
        caver_payload=data.caver_payload,
        scientific_payload=data.scientific_payload,
    )
    db.add(survey)
    db.commit()
    db.refresh(survey)
    row = db.execute(survey_select_for(auth).where(CaveSurvey.id == survey.id)).mappings().one()
    return CaveSurveyRead(**row)


@router.get("", response_model=list[CaveSurveyRead])
def list_surveys(
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("surveys:read"))] = None,
):
    rows = db.execute(survey_select_for(auth).order_by(CaveSurvey.name)).mappings().all()
    return [CaveSurveyRead(**row) for row in rows]


@router.get("/by-cave/{cave_id}", response_model=list[CaveSurveyRead])
def surveys_by_cave(
    cave_id: str,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("surveys:read"))] = None,
):
    stmt = survey_select_for(auth).where(CaveSurvey.cave_id == cave_id)
    rows = db.execute(stmt).mappings().all()
    return [CaveSurveyRead(**row) for row in rows]


@router.get("/by-kind/{kind}", response_model=list[CaveSurveyRead])
def surveys_by_kind(
    kind: str,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("surveys:read"))] = None,
):
    stmt = survey_select_for(auth).where(CaveSurvey.public_payload["kind"].astext == kind)
    rows = db.execute(stmt).mappings().all()
    return [CaveSurveyRead(**row) for row in rows]


@router.get("/longer-than/{min_length}", response_model=list[CaveSurveyRead])
def surveys_longer_than(
    min_length: int,
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("surveys:read_caver"))] = None,
):
    stmt = survey_select_for(auth).where(
        cast(CaveSurvey.caver_payload["length_m"].astext, Integer) > min_length
    )
    rows = db.execute(stmt).mappings().all()
    return [CaveSurveyRead(**row) for row in rows]


@router.get("/filter", response_model=list[CaveSurveyRead])
def filter_surveys(
    filters: Annotated[CaveSurveyFilter, Query()],
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("surveys:read"))] = None,
):
    uses_caver_filter = filters.min_length is not None or filters.max_length is not None
    if uses_caver_filter and not auth.has_any("surveys:read_caver"):
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="Forbidden")

    stmt = survey_select_for(auth)

    if filters.kind is not None:
        stmt = stmt.where(CaveSurvey.public_payload["kind"].astext == filters.kind)
    if filters.region is not None:
        stmt = stmt.where(CaveSurvey.public_payload["region"].astext == filters.region)
    if filters.min_length is not None:
        stmt = stmt.where(cast(CaveSurvey.caver_payload["length_m"].astext, Integer) >= filters.min_length)
    if filters.max_length is not None:
        stmt = stmt.where(cast(CaveSurvey.caver_payload["length_m"].astext, Integer) <= filters.max_length)
    if filters.protected is not None:
        stmt = stmt.where(CaveSurvey.public_payload["protected"].astext == str(filters.protected).lower())

    rows = db.execute(stmt).mappings().all()
    return [CaveSurveyRead(**row) for row in rows]
