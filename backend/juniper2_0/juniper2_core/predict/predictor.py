# track_that_money
# backend/juniper2_0/juniper2_core/predict/predictor.py
import os
from pathlib import Path
import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression

def _nz(value, fallback=0.0):
    """Return numeric value or fallback when None/NaN/blank."""
    if value is None:
        return fallback
    try:
        if np.isnan(value):
            return fallback
    except TypeError:
        pass
    return value

class SpendingPredictor:
    def __init__(self):
        self.model = LinearRegression()

        # Load real training data
        base_dir = Path(__file__).resolve().parents[2]
        csv_path = base_dir / 'data' / 'processed' / 'training_data.csv'

        df = pd.read_csv(csv_path)

        X = df[['amount', 'is_essential', 'mood_score', 'goal_contribution']].values
        y = df['target'].values
        self.model.fit(X, y)

    def predict(self, data: dict) -> float:
        features = np.array([[
            _nz(data.get("amount")),
            _nz(data.get("is_essential")),
            _nz(data.get("mood_score")),
            _nz(data.get("goal_contribution")),
        ]], dtype=float)

        return float(self.model.predict(features)[0])

# Create example dataset
np.random.seed(42)
n_samples = 100

data = {
    'amount': np.random.uniform(5, 100, n_samples),
    'is_essential': np.random.randint(0, 2, n_samples),
    'mood_score': np.random.uniform(1, 5, n_samples),
    'goal_contribution': np.random.uniform(0, 20, n_samples),
}

# Simulate probability of overspending based on amount and mood_score
data['target'] = 0.5 * (data['amount'] / 100) + 0.3 * (1 - data['mood_score'] / 5) + np.random.normal(0, 0.05, n_samples)

# Create DataFrame and save
if __name__ == '__main__':
    training_df = pd.DataFrame(data)
    csv_path.parent.mkdir(parents=True, exist_ok=True)
    training_df.to_csv(csv_path, index=False)
