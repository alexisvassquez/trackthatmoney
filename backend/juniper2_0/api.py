from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
from juniper2_core.predict.predictor import SpendingPredictor

app = FastAPI()
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

if __name__ == "__main__":
    uvicorn.run("api:app", host="0.0.0.0", port=8000, reload=True)
