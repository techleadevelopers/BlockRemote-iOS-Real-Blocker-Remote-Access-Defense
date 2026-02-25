import os
import asyncio
from celery import Celery
from redis import asyncio as aioredis
from sqlalchemy.ext.asyncio import async_sessionmaker, create_async_engine
from app.core.config import get_settings
from app.services.trust import compute_trust_score
from app.schemas.signal import SensorPayload
from app.models.signal import Signal, AuditLog
from sqlalchemy import insert

settings = get_settings()
celery = Celery(
    "blockremote",
    broker=settings.redis_url,
    backend=settings.redis_url,
)

# Eager config for dev
celery.conf.update(task_serializer="json", accept_content=["json"], result_serializer="json")

engine = create_async_engine(settings.database_url, future=True)
SessionLocal = async_sessionmaker(engine, expire_on_commit=False)


@celery.task(name="analyze_signal")
def analyze_signal(signal_id: int, payload: dict, device_id: str):
    async def _run():
        async with SessionLocal() as session:
            score = compute_trust_score(SensorPayload(**payload))
            if score < 40:
                await session.execute(
                    insert(AuditLog).values(
                        device_id=device_id,
                        threat_level="high" if score < 20 else "medium",
                        reason="Static device with active overlay",
                        signal_id=signal_id,
                    )
                )
                await session.commit()
                redis = aioredis.from_url(settings.redis_url, decode_responses=True)
                await redis.publish("kill-switch", f"block:{device_id}:score:{score}")
                await redis.close()
    asyncio.run(_run())
