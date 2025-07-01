# track_that_money
# backend/juniper2_0/tests/test_predictor.py
import pytest
from backend.juniper2_0.juniper2_core.predict.predictor import SpendingPredictor

def test_predict_basic():
    predictor = SpendingPredictor()
    sample_entry = {
        "category": "Groceries",
        "amount": 42.70,
        "is_essential": 1,
        "mood_score": 3.2,
        "goal_contribution": 5.00
    }
    pred = predictor.predict(sample_entry)
    assert 0.0 <= pred <= 1.0
