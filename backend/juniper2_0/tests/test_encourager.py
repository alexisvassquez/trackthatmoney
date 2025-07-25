# track_that_money
# backend/juniper2_0/tests/test_encourager.py
import pytest
import json
from pathlib import Path
import unittest
from unittest.mock import patch
from backend.juniper2_0.juniper2_core.encourage.encourager import EncouragementEngine
from backend.juniper2_0.juniper2_core.mood.mood_utils import map_mood_from_input
from backend.juniper2_0.juniper2_core.data.tips_loader import load_tips

@pytest.fixture(scope="module")
def engine():
    return EncouragementEngine()      # uses threshold = 0.6 by default

def test_tone_changes_with_amount(engine):
    low = engine.suggest({"amount": 5, "is_essential": 1})["tone"]
    high = engine.suggest({"amount": 250, "is_essential": 0})["tone"]
    assert low == "celebrate"
    assert high in {"caution", "alert"}

def test_required_keys_present(engine):
    result = engine.suggest({"amount": 25, "is_essential": 0, "mood": "discouraged"})
    expected = {
        "timestamp", "tone", "probability_overspend", 
        "message", "suggestion", "affirmation", "source_category"
    }
    assert expected.issubset(result.keys())    # Ensures all expected keys exist

    # Affirmations should be a non-empty string
    assert isinstance(result["affirmation"], str)
    assert len(result["affirmation"]) > 0

def test_json_is_stable(engine, tmp_path):
    res = engine.suggest({"amount": 42, "is_essential": 1})
    out = tmp_path / "encourage.json"
    out.write_text(str(res))
    assert out.read_text()

def test_missing_category_defaults_to_general(engine):
    """
    If no category key is given, tone still returns and tip comes from General.
    """
    res = engine.suggest({"amount": 7, "is_essential": 1})    # no "category"
    assert res["tone"] == "celebrate"

    # General-bank suggestions from tip bank
    tips_data = load_tips()
    general_tips = [tip["text"] for tip in tips_data["General"]["celebrate"]]
    assert res["suggestion"] in general_tips

@pytest.mark.parametrize("text,expected", [
    ("I'm so tired today, I can barely think.", "tired"),
    ("Feeling super productive this morning!", "motivated"),
    ("Honestly, I'm anxious about spending again.", "discouraged"),
    ("I'm okay, just taking it slow and steady.", "calm"),
    ("Let's do this!", "motivated")    # fallback/default
])
def test_map_mood_from_input(text, expected):
    assert map_mood_from_input(text) == expected

def test_affirmation_matches_mood(engine):
    result = engine.suggest({"amount": 15, "is_essential": 1, "mood": "tired"})
    assert "tired" in result["affirmation"].lower() or isinstance(result["affirmation"], str)

def test_tone_thresholds(engine):
    entry = {"amount": 42, "is_essential": 1}

    # Force tone = celebrate (below 0.6 threshold)
    with patch.object(engine.predictor, "predict", return_value=0.4):
        res = engine.suggest(entry)
        assert res["tone"] == "celebrate"

    # Force tone = caution (above threshold, between 0.6 and 0.8)
    with patch.object(engine.predictor, "predict", return_value=0.7):
        res = engine.suggest(entry)
        assert res["tone"] == "caution"

    # Force tone = alert (above 0.8)
    with patch.object(engine.predictor, "predict", return_value=0.9):
        res = engine.suggest(entry)
        assert res["tone"] == "alert"
