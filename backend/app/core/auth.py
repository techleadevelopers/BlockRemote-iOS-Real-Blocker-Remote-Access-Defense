from fastapi import Header, HTTPException, status, Depends
from app.core.config import get_settings, Settings
from app.core.security import verify_token


def get_current_device(
    authorization: str | None = Header(default=None, convert_underscores=False),
    settings: Settings = Depends(lambda: get_settings()),
) -> str:
    if not authorization or not authorization.lower().startswith("bearer "):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Missing bearer token")
    token = authorization.split(" ", 1)[1]
    return verify_token(token, settings.jwt_secret_key, [settings.jwt_algorithm])
