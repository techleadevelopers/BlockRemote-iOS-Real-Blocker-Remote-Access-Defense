from collections.abc import AsyncGenerator
import contextlib
from redis import asyncio as aioredis
from fastapi import Depends
from sqlalchemy.ext.asyncio import AsyncSession

from app.core.config import get_settings, Settings
from app.db.session import async_session


async def get_settings_dep() -> Settings:
    return get_settings()


async def get_db_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session() as session:
        yield session


@contextlib.asynccontextmanager
async def redis_conn(url: str):
    client = aioredis.from_url(url, encoding="utf-8", decode_responses=True)
    try:
        yield client
    finally:
        await client.close()


async def get_redis(settings: Settings = Depends(get_settings_dep)):
    async with redis_conn(settings.redis_url) as conn:
        yield conn
