from typing import Annotated

from fastapi import APIRouter, Depends
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.auth import AuthContext, require_any
from app.database import get_db
from app.models import Cave
from app.schemas import CaveRead

router = APIRouter(prefix="/caves", tags=["caves"])


@router.get("", response_model=list[CaveRead])
def list_caves(
    db: Session = Depends(get_db),
    auth: Annotated[AuthContext, Depends(require_any("caves:read"))] = None,
):
    rows = db.execute(select(Cave).order_by(Cave.id)).scalars().all()
    return rows
