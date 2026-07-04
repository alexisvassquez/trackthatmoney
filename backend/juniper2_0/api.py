# Track That Money
# backend/juniper2_0/api.py

from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordRequestForm
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime, timezone
import uuid
import uvicorn

from juniper2_core.predict.predictor import SpendingPredictor
from juniper2_core.encourage.encourager import EncouragementEngine
from auth.auth import verify_token


app = FastAPI(title="Track That Money API")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # restrict in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

# Engines
predictor = SpendingPredictor()    # Spending Predictor
engine = EncouragementEngine()     # Encouragement

# In-memory store
# TODO: swap for SQLite in later phase
_expenses: list[dict] = []

# Models
class ExpenseCreate(BaseModel):
    """
    What Flutter sends when the user logs an expense.
    """
    merchant: str
    category: str
    amount: float
    is_essential: int = 0
    mood_score: Optional[float] = None
    mood_tag: Optional[str] = None
    goal_contribution: Optional[float] = 0.0
    note: Optional[str] = None
    entry_day_of_week: Optional[str] = None
    entry_time: Optional[str] = None

class Expense(ExpenseCreate):
    """
    Stored expense, includes server-generated fields
    """
    id: str
    posted_at: str
    juniper_message: Optional[str] = None

class ExpenseEntry(BaseModel):
    """
    Prediction engine input
    Kept for backwards compat
    """
    amount: float
    is_essential: int
    goal_contribution: float
    category: str = ""
    entry_day_of_week: str = ""
    entry_time: str = ""

class ExpenseIn(BaseModel):
    """
    Encouragement engine input
    Kept for backwards compat
    """
    category: str
    amount: float
    is_essential: int
    entry_day_of_week: Optional[str] = None
    entry_time: Optional[str] = None
    mood_score: Optional[float] = None
    goal_contribution: Optional[float] = None

# Expense CRUD
@app.post("/expenses", response_model=Expense)
def create_expense(
    expense: ExpenseCreate,
    user_id: str = Depends(verify_token),
):
    """
    Log a new expense.
    Runs the encouragement engine and returns Juniper's response
    alongside the saved record.
    """
    # Get Juniper's take on this expense
    juniper_result = engine.suggest(expense.model_dump())
    juniper_message = (
        juniper_result.get("message", "") + " " +
        juniper_result.get("suggestion", "")
    ).strip()

    record = Expense(
        id=str(uuid.uuid4()),
        posted_at=datetime.now(timezone.utc).isoformat(),
        juniper_message=juniper_message,
        **expense.model_dump(),
    )

    _expenses.append(record.model_dump())
    return record

@app.get("/expenses", response_model=list[Expense])
def list_expenses(user_id: str = Depends(verify_token)):
    """
    Return all logged expenses with newest first.
    """
    return list(reversed(_expenses))

# Existing Endpoints
@app.post("/predict")
async def predict(
    entry: ExpenseEntry, 
    user_id: str = Depends(verify_token),
):
    prediction = predictor.predict(entry.model_dump())
    return {"prediction": prediction}

@app.post("/encourage")
def encourage(
    expense: ExpenseIn, 
    user_id: str = Depends(verify_token),
):
    """
    Return encouragement + tips for a single expense row.
    """
    result = engine.suggest(expense.model_dump())
    return result

@app.post("/token")
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    """
    Dev-only token exchange. 
    Will be replaced with Firebase/Auth0 before public release.
    """
    if form_data.username == "test" and form_data.password == "password":
        return {"access_token": "REDACTED", "token_type": "bearer"}
    raise HTTPException(status_code=400, detail="Invalid credentials")

if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=8000, reload=True)
