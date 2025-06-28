import os
import numpy as np
import pandas as pd
from sklearn.linear_model import LinearRegression

class SpendingPredictor:
    def __init__(self):
        self.model = LinearRegression()

        # Load real training data
        df = pd.read_csv('backend/juniper2_0/data/processed/training_data.csv')
        x = df[['amount', 'is essential', 'mood_score', 'goal_contribution']].values
        y = df['target'].values

        self.model.fit(X, y)

    def predict(self, data):
        features = np.array([[
            data.get('amount', 0),
            data.get('is_essential', 0),
            data.get('mood_score', 0),
            data.get('goal_contribution', 0)
        ]])
        prediction = self.model.predict(features)
        return float(prediction[0])

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
    os.makedirs('backend/juniper2_0/data/processed', exist_ok=True)
    training_df.to_csv('backend/juniper2_0/data/processed/training_data.csv', index=False)
