import asyncio
from fastapi import APIRouter, Depends, WebSocket, WebSocketDisconnect
from app.schemas.signal import TrustScore
from app.core.deps import get_redis, get_settings_dep
from app.core.config import Settings
from app.services.kill_switch import KillSwitchHub, relay_kill_switch
from app.core.auth import get_current_device

router = APIRouter()
kill_switch_hub = KillSwitchHub()
stop_event = asyncio.Event()
listener_task: asyncio.Task | None = None


@router.get("/trust-score", response_model=TrustScore)
async def trust_score(
    device_id: str,
    redis=Depends(get_redis),
    settings: Settings = Depends(get_settings_dep),
    subject: str = Depends(get_current_device),
):
    score = await redis.get(f"device:{device_id}:trust")
    if score is None:
        score = 80
    return TrustScore(device_id=device_id, score=int(score), verdict="safe" if int(score) >= 50 else "block")


@router.websocket("/kill-switch")
async def websocket_kill_switch(websocket: WebSocket, settings: Settings = Depends(get_settings_dep)):
    global listener_task
    await kill_switch_hub.register(websocket)
    if listener_task is None or listener_task.done():
        listener_task = asyncio.create_task(relay_kill_switch(kill_switch_hub, settings.redis_url, stop_event))

    try:
        while True:
            await websocket.receive_text()
    except WebSocketDisconnect:
        await kill_switch_hub.unregister(websocket)
    finally:
        if not kill_switch_hub.connections and listener_task:
            stop_event.set()
            await listener_task
            stop_event.clear()
            listener_task = None
