# track_that_money
# backend/juniper2_0/api.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn
from .juniper2_core.predict.predictor import SpendingPredictor
from .juniper2_core.encourage.encourager import EncouragementEngine
from backend.juniper2_0.auth.auth import verify_token
from fastapi.security import OAuth2PasswordRequestForm

app = FastAPI(title="Track That Money API")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # restrict in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

# Spending Predictor
predictor = SpendingPredictor()

class ExpenseEntry(BaseModel):
    amount: float
    is_essential: int
    goal_contribution: float
    category: str = ""
    entry_day_of_week: str = ""
    entry_time: str = ""

@app.post("/predict")
async def predict(entry: ExpenseEntry, user_id: str = Depends(verify_token)):
    prediction = predictor.predict(entry.dict())
    return {"prediction": prediction}

# Encouragement Engine
engine = EncouragementEngine()

class ExpenseIn(BaseModel):
    category: str
    amount: float
    is_essential: int
    entry_day_of_week: str | None = None
    entry_time: str | None = None
    mood_score: float | None = None
    goal_contribution: float | None = None

@app.post("/encourage")
def encourage(expense: ExpenseIn, user_id: str = Depends(verify_token)):
    """
    Return encouragement + tips for a single expense row.
    """
    result = engine.suggest(expense.dict())
    return result

@app.post("/token")
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    """
    Dev-only token exchange. Will be replaced with Firebase/Auth0/Plaid.
    """
    if form_data.username == "test" and form_data.password == "password":
        return {"access_token": "secret-token", "token_type": "bearer"}
    raise HTTPException(status_code=400, detail="Invalid credentials")

if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=8000, reload=True)
