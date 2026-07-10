# Track That Money
# backend/juniper2_0/api.py

import os
from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordRequestForm
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime, timezone
import uuid
import uvicorn
from dotenv import load_dotenv
from sqlalchemy.orm import Session

from juniper2_core.predict.predictor import SpendingPredictor
from juniper2_core.encourage.encourager import EncouragementEngine
from auth.auth import verify_token
from database.database import engine, get_db, Base
from database.models import ExpenseRecord

load_dotenv()

DEV_USERNAME = os.getenv("TTM_DEV_USERNAME")
DEV_PASSWORD = os.getenv("TTM_DEV_PASSWORD")
DEV_TOKEN = os.getenv("TTM_DEV_TOKEN")

# Create all tables on startup if they don't exist yet
Base.metadata.create_all(bind=engine)

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
engine_juniper = EncouragementEngine()     # Encouragement

# Pydantic Models
class ExpenseCreate(BaseModel):
    """
    What Flutter sends when the user logs an expense.
    """
    merchant: str
    category: str
    amount: float
    is_essential: int = 0
    is_subscription: int = 0
    mood_score: Optional[float] = None
    mood_tag: Optional[str] = None
    goal_contribution: Optional[float] = 0.0
    note: Optional[str] = None
    entry_day_of_week: Optional[str] = None
    entry_time: Optional[str] = None

class Expense(ExpenseCreate):
    """
    Stored full expense
    Includes server-generated fields returned to Flutter
    """
    id: str
    posted_at: str
    juniper_message: Optional[str] = None

    # allows building from SQLAlchemy model
    class Config:
        from_attributes = True

class ExpenseEntry(BaseModel):
    """
    Prediction engine input
    Kept for backwards compat.
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

# Expense CRUD endpoints
# Add Expenses
@app.post("/expenses", response_model=Expense)
def create_expense(
    expense: ExpenseCreate,
    user_id: str = Depends(verify_token),
    db: Session = Depends(get_db),
):
    """
    Log a new expense.
    Runs the encouragement engine and stores the result in SQLite.
    Returns Juniper's response alongside the saved record.
    """
    # Get Juniper's take on this expense
    juniper_result = engine_juniper.suggest(expense.model_dump())
    juniper_message = (
        juniper_result.get("message", "") + " " +
        juniper_result.get("suggestion", "")
    ).strip()

    # Build the database record
    record = ExpenseRecord(
        id=str(uuid.uuid4()),
        user_id=user_id or "dev_user",    # fallback for safety
        posted_at=datetime.now(timezone.utc).isoformat(),
        juniper_message=juniper_message,
        **expense.model_dump(),
    )

    db.add(record)
    db.commit()
    db.refresh(record)
    return record

# List Expenses
@app.get("/expenses", response_model=list[Expense])
def list_expenses(
    user_id: str = Depends(verify_token),
    db: Session = Depends(get_db),
):
    """
    Return all logged expenses for the current user, newest first.
    """
    return (
        db.query(ExpenseRecord)
        .filter(ExpenseRecord.user_id == user_id)
        .order_by(ExpenseRecord.posted_at.desc())
        .all()
    )

# Delete Expenses
@app.delete("/expenses/{expense_id}")
def delete_expense(
    expense_id: str,
    user_id: str = Depends(verify_token),
    db: Session = Depends(get_db),
):
    """
    Delete an expense by ID.
    Only the owning user can delete record.
    """
    record = (
        db.query(ExpenseRecord)
        .filter(
            ExpenseRecord.id == expense_id,
            ExpenseRecord.user_id == user_id,
        )
        .first()
    )

    if not record:
        raise HTTPException(status_code=404, detail="Expense not found.")
    
    db.delete(record)
    db.commit()
    return {"deleted": expense_id}

# Expenses Summary
@app.get("/expenses/summary")
def expenses_summary(
    user_id: str = Depends(verify_token),
    db: Session = Depends(get_db),
):
    """
    Returns total spent this month for the current user.
    """
    from sqlalchemy import func

    # Get first day of current month as a string for comparison
    now = datetime.now(timezone.utc)
    month_start = now.replace(day=1, hour=0, minute=0, second=0).isoformat()

    total = db.query(func.sum(ExpenseRecord.amount))\
        .filter(
            ExpenseRecord.user_id == user_id,
            ExpenseRecord.posted_at >= month_start,
        )\
        .scalar() or 0.0
    
    return {
        "total_spent": round(total, 2),
        "month": now.strftime("%B %Y"),
    }

# Affirmations
@app.get("/affirmation")
def get_affirmation(user_id: str = Depends(verify_token)):
    """
    Return a random affirmation from the encouragement engine
    """
    affirmation = engine_juniper._affirmation_fallback()
    return {"affirmation": affirmation}

# Existing AI Endpoints
@app.post("/predict")
async def predict(
    entry: ExpenseEntry, 
    user_id: str = Depends(verify_token),
):
    """
    Run the spending prediction model on an expense entry.
    """
    prediction = predictor.predict(entry.model_dump())
    return {"prediction": prediction}

@app.post("/encourage")
def encourage(
    expense: ExpenseIn, 
    user_id: str = Depends(verify_token),
):
    """
    Return encouragement and tips for a single expense row.
    """
    result = engine_juniper.suggest(expense.model_dump())
    return result

# Auth
@app.post("/token")
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    """
    Dev-only token exchange. 
    Will be replaced with Firebase/Auth0 before public release.
    """
    if form_data.username == DEV_USERNAME and form_data.password == DEV_PASSWORD:
        return {"access_token": DEV_TOKEN, "token_type": "bearer"}
    raise HTTPException(status_code=400, detail="Invalid credentials")

if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=8000, reload=True)
