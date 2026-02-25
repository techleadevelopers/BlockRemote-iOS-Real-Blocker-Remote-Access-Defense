import datetime as dt
from typing import Optional
from jose import jwt, JWTError
from fastapi import HTTPException, status


def create_access_token(subject: str, secret_key: str, algorithm: str, expires_minutes: int) -> str:
    expire = dt.datetime.utcnow() + dt.timedelta(minutes=expires_minutes)
    to_encode = {"sub": subject, "exp": expire}
    return jwt.encode(to_encode, secret_key, algorithm=algorithm)


def verify_token(token: str, secret_key: str, algorithms: list[str]) -> str:
    try:
        payload = jwt.decode(token, secret_key, algorithms=algorithms)
        subject: Optional[str] = payload.get("sub")
        if subject is None:
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")
        return subject
    except JWTError as exc:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Token verification failed") from exc


def verify_mtls(cert: Optional[str]) -> None:
    # Placeholder for mTLS verification: in production, FastAPI would be behind a reverse proxy terminating TLS
    if cert is None:
        return
    # Implement CA validation here or rely on ingress controller configuration
    return
