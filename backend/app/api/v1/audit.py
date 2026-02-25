from fastapi import APIRouter, Depends
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select

from app.schemas.signal import AuditLogOut
from app.models.signal import AuditLog
from app.core.deps import get_db_session
from app.core.auth import get_current_device

router = APIRouter()


@router.get("/logs", response_model=list[AuditLogOut])
async def list_logs(
    session: AsyncSession = Depends(get_db_session),
    subject: str = Depends(get_current_device),
):
    result = await session.execute(select(AuditLog).order_by(AuditLog.created_at.desc()).limit(200))
    return result.scalars().all()
