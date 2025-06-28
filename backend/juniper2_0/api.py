from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import uvicorn
from juniper2_core.predict.predictor import SpendingPredictor
from juniper2_core.encourage.encourager import EncouragementEngine

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
async def predict(entry: ExpenseEntry):
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
def encourage(expense: ExpenseIn):
    """
    Return encouragement + tips for a single expense row.
    """
    result = engine.suggest(expense.dict())
    return result

if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=8000, reload=True)
