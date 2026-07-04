# Track That Money
# backend/juniper2_0/auth/auth.py

import os
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from typing import Optional
from dotenv import load_dotenv

# Endpoint where clients exchange username/password for token
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/token")

load_dotenv()

DEV_TOKEN = os.getenv("TTM_DEV_TOKEN")

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/token")

def verify_token(token: str = Depends(oauth2_scheme)) -> Optional[str]:
    """
    Simple token check for now during beta stage. 
    Replace with real token validation later.
    """
    if token != DEV_TOKEN:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or missing authentication token.",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return "test_user_id"
