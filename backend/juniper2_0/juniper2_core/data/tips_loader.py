# track_that_money
# backend/juniper2_0/juniper2_core/data/tips_loader.py
import json
from pathlib import Path

def load_tips(filename="tips_with_mood_and_weights.json") -> dict:
    """
    Loads tips JSON from the processed data folder and returns it as a dict.
    """
    base_dir = Path(__file__).resolve().parents[2]
    tips_path = base_dir / "data" / "processed" / filename
    with tips_path.open(encoding="utf-8") as fh:
        return json.load(fh)

def load_affirmations() -> list:
    affirmations_path = Path(__file__).parent / "affirmations.json"
    with open(affirmations_path, "r", encoding="utf-8") as f:
        return json.load(f)
