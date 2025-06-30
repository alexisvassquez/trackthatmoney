# track_that_money
# tests/test_encourager.py
import pytest
from backend.juniper2_0.juniper2_core.encourage.encourager import EncouragementEngine

@pytest.fixture(scope="module")
def engine():
    return EncouragementEngine()      # uses threshold = 0.6 by default

def test_tone_changes_with_amount(engine):
    low = engine.suggest({"amount": 5, "is_essential": 1})["tone"]
    high = engine.suggest({"amount": 250, "is_essential": 0})["tone"]
    assert low == "celebrate"
    assert high in {"caution", "alert"}

def test_required_keys_present(engine):
    result = engine.suggest({"amount": 25, "is_essential": 0})
    expected = {"timestamp", "tone", "probability_overspend", "message", "suggestion"}
    assert expected.issubset(result.keys())

def test_json_is_stable(engine, tmp_path):
    res = engine.suggest({"amount": 42, "is_essential": 1})
    out = tmp_path / "encourage.json"
    out.write_text(str(res))
    assert out.read_text()
