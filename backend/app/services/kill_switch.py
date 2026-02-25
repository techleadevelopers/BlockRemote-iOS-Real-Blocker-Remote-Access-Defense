import asyncio
from typing import Set
from fastapi import WebSocket
from redis import asyncio as aioredis


class KillSwitchHub:
    def __init__(self):
        self.connections: Set[WebSocket] = set()

    async def register(self, websocket: WebSocket):
        await websocket.accept()
        self.connections.add(websocket)

    async def unregister(self, websocket: WebSocket):
        self.connections.discard(websocket)

    async def broadcast(self, message: str):
        for ws in list(self.connections):
            try:
                await ws.send_text(message)
            except Exception:
                await self.unregister(ws)


async def relay_kill_switch(hub: KillSwitchHub, redis_url: str, stop_event: asyncio.Event):
    redis = aioredis.from_url(redis_url, decode_responses=True)
    pubsub = redis.pubsub()
    await pubsub.subscribe("kill-switch")
    try:
        while not stop_event.is_set():
            message = await pubsub.get_message(ignore_subscribe_messages=True, timeout=1.0)
            if message and message.get("data"):
                await hub.broadcast(str(message["data"]))
    finally:
        await pubsub.unsubscribe("kill-switch")
        await pubsub.close()
        await redis.close()
