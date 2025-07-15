# track_that_money
# backend/juniper2_0/juniper2_core/subscription/subscription_insight.py
import json
from datetime import datetime
from collections import defaultdict

def analyze_subscriptions(expenses):
    """
    Analyze subscription expenses from a list of expense entries.

    Args:
        expenses (list): List of dictionaries with keys:
            - amount (float)
            - isSubscription (bool)
            - category (str)
            - date (ISO8601 string)

    Returns:
        dict: Insights block including fatigue rating, totals, and vendor list.
    """
    monthly_totals = defaultdict(float)
    total_spend = 0.0
    subscription_spend = 0.0
    vendors = set()

    for entry in expenses:
        try:
            date_str = entry.get("date")
            if not date_str:
                continue
            date = datetime.fromisoformat(date_str)
            month_key = date.strftime("%Y-%m")
        except Exception:
            continue

        amount = float(entry.get("amount", 0.0))
        total_spend += amount

        if entry.get("isSubscription", False):
            subscription_spend += amount
            monthly_totals[month_key] += amount
            vendors.add(entry.get("category", "Unknown"))

    subscription_percentage = (subscription_spend / total_spend * 100) if total_spend else 0.0

    # Determines fatigue rating
    fatigue_rating = "celebrate"
    if subscription_percentage > 25.0 or len(vendors) >= 7:
        fatigue_rating = "alert"
    elif len(vendors) >= 4:
        fatigue_rating = "caution"

    return {
        "subscription_spend": round(subscription_spend, 2),
        "total_spend": round(total_spend, 2),
        "subscription_percentage": round(subscription_percentage, 1),
        "active_subscription_vendors": sorted(vendors),
        "monthly_breakdown": dict(monthly_totals),
        "fatigue_rating": fatigue_rating
    }

if __name__ == "__main__":
    with open("user_expenses.json", "r") as f:
        expenses = json.load(f)
    report = analyze_subscriptions(expenses)
    print (json.dumps(report, indent=2))
