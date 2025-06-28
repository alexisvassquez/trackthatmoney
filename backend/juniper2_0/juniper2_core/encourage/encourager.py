import random
from datetime import datetime
from juniper2_core.predict.predictor import SpendingPredictor

class EncouragementEngine:
    """
    Turns predictor scores + raw fields into messages.
    """
    def __init__(self, threshold: float = 0.6):
        self.predictor = SpendingPredictor()
        self.threshold = threshold     # probability of 'overspend'

    def _select_tone(self, score: float) -> str:
        """Choose overall tone based on score."""
        if score >= 0.8:
            return "alert"
        if score >= self.threshold:
            return "caution"
        return "celebrate"

    def _tips_bank(self):
        """Small pool of generic tips (expand later / load from DB)."""
        return {
            "Groceries": [
                "Let's do a meal prep or batch-cook day this week.",
                "Let's check for any coupons or cheaper items at the local farmers market this week."
            ],
            "Dining": [
                "How about we set a fun cook-at-home challenge tonight? It will pair beautifully with a lo-fi Spotify playlist!",
                "Let's swap one delivery for a picnic this week - same treat, half the cost!"
            ],
            "Entertainment": [
                "Browse your library's free streaming catalogue - hidden gems await.",
                "We can make progress on an unfinished game instead of buying new games this month."
            ],
            "General": [
                "Every dollar saved is 🦾 toward your top goal!",
                "Small swaps compound - great job noticing your habits."
            ],
        }

    def suggest(self, entry: dict) -> dict:
        """
        Takes a raw expense dict -> returns encouragement + suggestion.
        """
        score = self.predictor.predict(entry)     # 0-1 overspend probability
        tone = self._select_tone(score)

        cat = entry.get("category", "General")
        tips = self._tips_bank().get(cat, []) + self._tips_bank()["General"]
        tip = random.choice(tips)

        if tone == "alert":
            message = f"⚠️ Heads up! This looks like it could hinder your budget."
        elif tone == "caution":
            message = f"😅 Careful! This expense could stretch things a bit."
        else:
            message = f"👏 Good work! You're right on track."

        return {
            "timestamp": datetime.utcnow().isoformat(),
            "tone": tone,
            "probability_overspend": round(score, 2),
            "message": message,
            "suggestion": tip
        } 
