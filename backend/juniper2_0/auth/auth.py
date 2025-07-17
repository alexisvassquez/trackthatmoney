# track_that_money
# backend/juniper2_0/auth/auth.py
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from typing import Optional

# Endpoint where clients exchange username/password for token
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/token")

def verify_token(token: str = Depends(oauth2_scheme)) -> Optional[str]:
    """
    Simple token check for now during beta stage. Replace with real token validation later.
    """
    if token != "secret-token":
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or missing authentication token.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return "test_user_id"
