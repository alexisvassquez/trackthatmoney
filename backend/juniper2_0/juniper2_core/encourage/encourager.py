# track_that_money
# backend/juniper2_0/juniper2_core/encourage/encourager.py
from pathlib import Path
import json
import random
from datetime import datetime
from ..predict.predictor import SpendingPredictor

class EncouragementEngine:
    """
    Turns predictor scores + raw fields into messages, pulling tips from
    `data/processed/tips.json` to never duplicate tip text.
    """
    def __init__(self, threshold: float = 0.6):
        self.predictor = SpendingPredictor()
        self.threshold = threshold     # probability of 'overspend'

        # loads tips.json once
        base_dir = Path(__file__).resolve().parents[2]
        tips_path = base_dir / "data" / "processed" / "tips_with_mood_and_weights.json"
        with tips_path.open(encoding="utf-8") as fh:
            self._tips = json.load(fh)

    def _select_tone(self, score: float) -> str:
        """Choose overall tone based on score."""
        if score >= 0.8:
            return "alert"
        if score >= self.threshold:
            return "caution"
        return "celebrate"

    def suggest(self, entry: dict) -> dict:
        """
        Returns encouragement + suggestion dict for one expense row.
        """
        score = self.predictor.predict(entry)     # 0-1 overspend probability
        tone = self._select_tone(score)
        mood = entry.get("mood", None)

        cat = entry.get("category", "General")
        cat_tips = self._tips.get(cat, {}).get(tone, [])
        general_tips = self._tips.get("General", {}).get(tone, [])
        combined = cat_tips + general_tips

        # Filter tips by mood if mood is supplied
        if mood:
            filtered = [tip for tip in combined if tip.get("mood") == mood]
            tips = filtered if filtered else combined    # fallback if no match
        else:
            tips = combined

        # Weighted random selection
        tip = random.choice(
            tips,
            weights=[tip.get("weight", 1) for tip in tips],
            k=1
        )[0] if tips else {"text": ""}

        message = {
            "alert": "⚠️ Heads up! This looks like it could hinder your budget.",
            "caution": "😅 Careful! This expense could stretch things a bit.",
            "celebrate": "👏 Good work! You're right on track."
        }[tone]

        return {
            "timestamp": datetime.utcnow().isoformat(),
            "tone": tone,
            "probability_overspend": round(score, 2),
            "message": message,
            "suggestion": tip["text"]
        }
