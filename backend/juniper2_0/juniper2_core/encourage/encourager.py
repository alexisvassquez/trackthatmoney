# Track That Money
# backend/juniper2_0/juniper2_core/encourage/encourager.py

from pathlib import Path
import json
import random
from datetime import datetime, timezone
from ..predict.predictor import SpendingPredictor
from ..data.tips_loader import load_tips, load_affirmations

# Category normalization
# Maps Flutter expense categories to JSON tip categories.
# Prevents fallback to General when the category just has a different
# name.
CATEGORY_MAP = {
    'food': 'Dining',
    'dining': 'Dining',
    'groceries': 'Groceries',
    'transport': 'Transportation',
    'transportation': 'Transportation',
    'entertainment': 'Entertainment',
    'subscriptions': 'Subscriptions',
    'clothing': 'Shopping',
    'shopping': 'Shopping',
    'health': 'Medical',
    'medical': 'Medical',
    'housing': 'Housing',
    'utilities': 'Utilities',
    'self-care': 'Self-Care',
    'selfcare': 'Self-Care',
    'debt': 'Debt',
    'other': 'General',
} 

# Tone messages
# Varied so Juniper doesn't repeat herself.
# Warm, non-punitive, "encouraged not guilt" philosophy
# throughout.
TONE_MESSAGES = {
    "celebrate": [
        "You're doing well.",
        "Every thoughtful purchase counts.",
        "Small wins add up - this is one of them.",
        "You're making it work.",
        "That's awareness in action.",
        "Progress looks like this.",
        "Showing up for your finances, one entry at a time.",
    ],
    "caution": [
        "Something to keep an eye on - no judgement.",
        "Worth a moment of reflection.",
        "No lecture here, just awareness.",
        "This is a gentle heads up from your budget.",
        "This one's worth noticing.",
    ],
    "alert": [
        "This one is worth a closer look.",
        "Let's think about this next step together.",
        "A nudge, not a scolding.",
        "Worth pausing on this one.",
        "Your budget is flagging this - just so you are aware.",
    ],
}

class EncouragementEngine:
    def __init__(self, threshold: float = 0.6):
        self.predictor = SpendingPredictor()
        self.threshold = threshold     # probability of 'overspend'
        self._tips = load_tips()       # loads tips JSON schema once
        self._affirmations = load_affirmations()    # loads affirmations JSON schema

    def _select_tone(self, score: float) -> str:
        """
        Choose overall tone based on score.
        """
        if score >= 0.8:
            return "alert"
        if score >= self.threshold:
            return "caution"
        return "celebrate"

    def _normalize_category(self, cat: str) -> str:
        """
        Map incoming category strings to JSON tip category names.
        Falls back to 'General' if no match found.
        """
        return CATEGORY_MAP.get(cat.lower().strip(), cat)

    def _affirmation_fallback(self, mood: str | None = None) -> str:
        """
        Return a random affirmation.
        Filtered by mood if one is provided.
        """
        affirmations = self._affirmations
        if mood:
            mood_matches = [a for a in affirmations if a.get("mood") == mood]
            if mood_matches:
                affirmations = mood_matches
        return random.choice(affirmations)["text"]

    def suggest(self, entry: dict) -> dict:
        """
        Returns encouragement + suggestion dict for one expense or journal
        entry.
        Includes tone, varied message, tip text, affirmation, 
        and source category.
        Accepts both 'mood' and 'mood_tag' keys for compatibility with
        expense entries (mood_tag) and journal entries (mood).
        """
        # 0.0-1.0 overspend probability
        score = self.predictor.predict(entry)
        tone = self._select_tone(score)

        # Support booth 'mood_tag' (expenses) and 'mood' (journal
        # entries)
        mood = entry.get("mood_tag") or entry.get("mood")

        # Normalize category and get tips
        raw_cat = entry.get("category", "General")
        cat = self._normalize_category(raw_cat)
        cat_tips = self._tips.get(cat, {}).get(tone, [])

        # Always include General tips as supplementary options
        general_tips = self._tips.get("General", {}).get(tone, [])
        combined = cat_tips + general_tips

        # Filter tips by mood tag if one is supplied
        if mood and combined:
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

        # Varied tone message
        # No more repeating the same line every time
        message = random.choice(TONE_MESSAGES[tone])
        affirmation = self._affirmation_fallback(mood if isinstance(mood, str) else None)

        return {
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "tone": tone,
            "probability_overspend": round(score, 2),
            "message": message,
            "suggestion": tip["text"],
            "affirmation": affirmation,
            "source_category": cat
        }
