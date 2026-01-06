# track_that_money
# backend/juniper2_0/juniper2_core/encourage/encourager.py
from pathlib import Path
import json
import random
from datetime import datetime
from ..predict.predictor import SpendingPredictor
from ..data.tips_loader import load_tips, load_affirmations

class EncouragementEngine:
    def __init__(self, threshold: float = 0.6):
        self.predictor = SpendingPredictor()
        self.threshold = threshold     # probability of 'overspend'
        self._tips = load_tips()       # loads tips JSON schema once
        self._affirmations = load_affirmations()    # loads affirmations JSON schema

    def _select_tone(self, score: float) -> str:
        """Choose overall tone based on score."""
        if score >= 0.8:
            return "alert"
        if score >= self.threshold:
            return "caution"
        return "celebrate"

    def _affirmation_fallback(self, mood: str = None) -> str:
        affirmations = self._affirmations
        if mood:
            mood_matches = [a for a in affirmations if a.get("mood") == mood]
            if mood_matches:
                affirmations = mood_matches
        return random.choice(affirmations)["text"]

    def suggest(self, entry: dict) -> dict:
        """
        Returns encouragement + suggestion dict for one expense row.
        Includes tone, tip text, and source category.
        """
        score = self.predictor.predict(entry)     # 0.0-1.0 overspend probability
        tone = self._select_tone(score)
        mood = entry.get("mood")

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
        tip = random.choices(
            tips,
            weights=[tip.get("weight", 1) for tip in tips],
            k=1
        )[0] if tips else {"text": ""}

        message = {
            "alert": "⚠️ Heads up! This looks like it could hinder your budget.",
            "caution": "😅 Careful! This expense could stretch things a bit.",
            "celebrate": "👏 Good work! You're right on track."
        }[tone]
        affirmation = self._affirmation_fallback(mood)

        return {
            "timestamp": datetime.utcnow().isoformat(),
            "tone": tone,
            "probability_overspend": round(score, 2),
            "message": message,
            "suggestion": tip["text"],
            "affirmation": affirmation,
            "source_category": cat
        }
