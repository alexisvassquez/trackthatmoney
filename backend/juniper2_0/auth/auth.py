# Track That Money
# backend/juniper2_0/auth/auth.py

import os
from dotenv import load_dotenv
from fastapi import Depends, HTTPException
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from google.auth.transport import requests as google_requests
from google.oauth2 import id_token

load_dotenv()

FIREBASE_PROJECT_ID = os.environ["FIREBASE_PROJECT_ID"]
_request = google_requests.Request()
bearer = HTTPBearer()

def verify_token(creds: HTTPAuthorizationCredentials = Depends(bearer)) -> str:
    try:
        claims = id_token.verify_firebase_token(
            creds.credentials, _request, audience=FIREBASE_PROJECT_ID
        )
    except ValueError:
        claims = None

    if not claims or claims.get("iss") != f"https://securetoken.google.com/{FIREBASE_PROJECT_ID}":
        raise HTTPException(status_code=401, detail="Please sign in again.")

    return claims["sub"]
