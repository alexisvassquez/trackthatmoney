# track_that_money
# backend/juniper2_0/juniper2_core/predict/train_model.py
import numpy as np
import pandas as pd
from pathlib import Path

base_dir = Path(__file__).resolve().parents[2]
csv_path = base_dir / 'data' / 'processed' / 'training_data.csv'

np.random.seed(42)
n_samples = 100

data = {
    'amount': np.random.uniform(5, 100, n_samples),
    'is_essential': np.random.randint(0, 2, n_samples),
    'mood_score': np.random.uniform(1, 5, n_samples),
    'goal_contribution': np.random.uniform(0, 20, n_samples),
    'is_subscription': np.random.randint(0, 2, n_samples),
}

data['target'] = (
    0.5 * (data['amount'] / 100) +
    0.3 * (1 - data['mood_score'] / 5) +
    np.random.normal(0, 0.05, n_samples)
)

training_df = pd.DataFrame(data)
csv_path.parent.mkdir(parents=True, exist_ok=True)
training_df.to_csv(csv_path, index=False)

print(f"Training data written to: {csv_path}")
