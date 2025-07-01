# track_that_money
# backend/juniper2_0/juniper2_core/mood/mood_utils.py

def map_mood_from_input(text: str) -> str:
    text = text.lower()
    if any(w in text for w in ["tired", "burnt out", "exhausted", "drained", "wiped"]):
        return "tired"
    elif any(w in text for w in ["motivated", "energized", "productive", "focused"]):
        return "motivated"
    elif any(w in text for w in ["anxious", "worried", "uncertain", "nervous"]):
        return "discouraged"
    elif any(w in text for w in ["calm", "peaceful", "relaxed", "okay", "fine"]):
        return "calm"
    else:
        return "motivated"    # default fallback
