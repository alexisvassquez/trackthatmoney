# track_that_money
# tests/test_predictor.py
import pytest
from backend.juniper2_0.juniper2_core.predict.predictor import SpendingPredictor

predictor = SpendingPredictor()
sample_entry = {
    "category": "Groceries",
    "amount": 42.70,
    "is_essential": 1,
    "entry_day_of_week": "Saturday",
    "entry_time": "Afternoon",
    "mood_score": 3.2,
    "goal_contribution": 5.00
}

prediction = predictor.predict(sample_entry)
print ("Prediction:", prediction)
