# 💸 Track That Money

_An expense tracking app to know why you're broke_

**Track That Money** is a Flutter-based mobile app that combines emotion-tagged expense tracking, reflective journaling, and an AI companion (Juniper2.0) to help neurodivergent and financially overwhelmed individuals build a healthier relationship with money — one gentle nudge at a time.

---

## Who this is for

Most finance apps are built for people who are already financially stable and want to optimize. **Track That Money** is built for everyone else.

If you've ever:

- Closed a budgeting app because the red numbers made your chest tight
- Avoided checking your bank balance because you already knew it was bad
- Spent money you didn't have because you were stressed, lonely, or exhausted
- Wanted to get your finances together but didn't know where to start without feeling judged

— this app was built with you in mind, by someone who gets it.

Over 54% of Americans are living paycheck to paycheck. That's not a niche. That's most people. And almost nothing in the fintech space is actually designed for them.

---

## Why?

Because understanding and managing your finances shouldn't feel shameful, overwhelming, anxiety-inducing, inaccessible, bloated, or like a sales pitch.

Traditional finance apps treat money as a purely numerical problem. They give you charts, alerts, and red numbers — and leave you alone with the shame of what those numbers mean.

**Track That Money** treats money as an emotional experience. The goal isn't to make you feel guilty about what you've spent. It's to help you understand _why_ you spent it, celebrate what you're doing right, and build momentum — even if your wins are small.

Even $1 saved is a win. This app will treat it like one.

---

## Core Features

- **Expense tracking** — add, edit, and delete expenses with mood tags and notes
- **Juniper2.0** — an AI companion that responds to your spending with encouragement, gentle insights, and real suggestions (not judgment)
- **Journal entries** — link reflections to purchases ("I bought this because I was stressed")
- **Piggy bank goals** — savings goals with light celebratory animations when you make progress
- **Budget summary** — see where your money is going without a wall of red numbers
- **Spending insights** — understand patterns over time ("you tend to spend more on Fridays")
- **Educational resources** — financial literacy content that meets you where you are
- **CSV/XLSX export** — your data, your way
- _Planned:_ OAuth2 / Plaid bank linking

---

## What makes this different

| | Traditional finance apps | Track That Money |
| --- | --- | --- |
| Tone | Accountability | Compassion |
| When you overspend | Red alert | Gentle curiosity |
| AI purpose | Categorization | Encouragement |
| Built for | Financially stable optimizers | People starting from overwhelmed |
| Emotional design | None | CBT-informed throughout |

---

## Wellness Fintech Concept Framework: The Emotional Economy

### Core Idea

Money is emotional. Traditional finance apps track numbers; **Track That Money** tracks feelings behind the numbers.
The app fuses financial technology (fintech) with behavioral wellness (CBT principles) to help users understand and heal their relationship with money — turning budgeting into self-discovery.

---

### 1. Emotional Input Layer

- **User Actions:** Emotion tagging, journaling, reflection prompts, spending notes
- **Goal:** Identify emotional triggers and motivations behind financial behavior
- **Example:** "I spent $25 on takeout because I felt lonely."
- **Result:** Awareness replaces shame — the user learns to observe rather than judge

---

### 2. Behavioral Finance Layer

- **System Logic**
  - Analyzes spending + emotion patterns over time
  - Uses simple analytics and AI prompts to show links between _mood states_ and _money habits_
  - **Example:**
  > "You tend to overspend when stressed on Fridays — try planning a treat budget in advance."
  - **Goal:** Bridge the gap between _intentions_ and _actions_ through insight and gentle behavioral nudges

---

### 3. Wellness Guidance Layer

- **Tools:**
  - Mindful spending reflections
  - Encouragement messages (tone-based, not judgmental)
  - CBT-inspired reframing ("What need was I trying to meet when I made that purchase?")
- **Goals:**
  - Transform self-criticism into curiosity
  - Help users regulate their emotions before financial consequences accumulate

---

### 4. Growth & Empowerment Layer

- **Outcome**
  - Financial literacy becomes emotional literacy
  - Money anxiety decreases as users see progress holistically (not just in numbers)
  - Users experience budgeting as self-care, not punishment
- **Example Output**

> "You've reduced stress spending by 12% this month. That's growth!"

---

### Vision: A New Kind of Financial Wellness

**Track That Money** isn't just about managing funds — it's about healing _financial trauma_ and building emotional resilience.
By merging fintech precision with wellness empathy, we create a new class of technology: _Wellness FinTech._
> "Because understanding your money starts with understanding yourself."

---

## Tech Stack

- **Frontend**
  - Flutter `^3.8.1` / Dart
  - Riverpod for state management
  - GoRouter for navigation
  - Target platform: Android (mobile-first)

- **Backend**
  - Python / FastAPI
  - Uvicorn (ASGI server)
  - scikit-learn, pandas, numpy (Juniper2.0 ML core)
  - OAuth2 authentication

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.8.1`
- Dart SDK (included with Flutter)
- Android SDK (CLI tools or Android Studio)
- Python `3.10+`
- pip

---

### 1. Clone the repo

```bash
git clone https://github.com/alexisvassquez/trackthatmoney.git
cd trackthatmoney
```

---

### 2. Run the backend

```bash
cd backend/juniper2_0

# Create and activate a virtual environment
python -m venv .venv
source .venv/bin/activate        # Linux/macOS
# .venv\Scripts\activate         # Windows

# Install dependencies
pip install -r requirements.txt

# Start the API server
uvicorn api:app --reload --host 0.0.0.0 --port 8000
```

The API will be available at `http://localhost:8000`.
Interactive docs at `http://localhost:8000/docs`.

**Dev note:** The `/token` endpoint uses hardcoded credentials for local development:

```bash
username: test
password: password
```

This will be replaced with real auth before any public release.

---

### 3. Run the Flutter app

```bash
# From the project root
flutter pub get
flutter run
```

To run on a specific device:

```bash
flutter devices              # list available devices
flutter run -d <device-id>
```

To build a debug APK:

```bash
flutter build apk --debug
```

---

## Project Structure

```cpp
trackthatmoney/
├── backend/
│   └── juniper2_0/          # FastAPI backend + Juniper2.0 AI engine
│       ├── api.py            # API routes (/encourage, /predict, /token)
│       ├── juniper2_core/    # ML models, encouragement engine, mood utils
│       ├── auth/             # Token verification
│       ├── data/             # Training data, tips, affirmations
│       └── requirements.txt
├── lib/
│   ├── main.dart
│   ├── models/               # Expense, JournalEntry, BudgetPlan, Goal, User
│   ├── services/             # BudgetSummary, ResourceLoader, UserPrefs
│   ├── state/                # Riverpod providers, JuniperSheet
│   └── ui/
│       ├── app.dart          # GoRouter setup
│       ├── dashboard/        # Dashboard screen + widgets
│       ├── journal/          # Journal screen + form
│       ├── screens/          # LearnAndGrow screen
│       └── theme/            # AppColors, buildAppTheme()
└── test/                     # Unit tests
```

---

## API Endpoints

| Method | Endpoint | Description | Auth |
| --- | --- | --- | --- |
| `POST` | `/token` | Get dev access token | None |
| `POST` | `/encourage` | Get Juniper2.0 encouragement for an expense | Bearer token |
| `POST` | `/predict` | Predict spending behavior | Bearer token |

Full interactive documentation available at `http://localhost:8000/docs` when the backend is running.

---

## App Color Palette: "Warm & Hopeful" Theme

**Track That Money's** palette is built around warmth, calm, and encouragement. No corporate blues, no alarm reds — just colors that feel like exhaling.

| Role | Color Name | Hex Code | Purpose / Mood |
| --- | --- | --- | --- |
| 💚 Primary | Sage | `#7AAE82` | Growth · calm · safety |
| 🍑 Accent 1 | Peach | `#F2A98A` | Warmth · self-kindness · reward |
| ✨ Accent 2 | Honey gold | `#D4A843` | Achievement · celebration |
| 🌊 Highlight | Seafoam | `#7EB5A6` | Reflection · calm · flow |
| ☁️ Background | Cream | `#FAF6F0` | Comfort · breathing room |
| 🪨 Surface | Sand | `#F2EAD8` | Card backgrounds |
| 🖊️ Text | Deep moss | `#2C3828` | Legibility · warmth |

**Why no red?**
Traditional finance apps use red to signal overdrafts, overspending, or "bad" behavior.
**Track That Money** avoids punitive color language entirely — because shame doesn't help anyone build better habits.

> Color itself becomes a grounding technique. Users should feel calmer _after_ opening the app than before.

---

## Status

Actively in development. Paused mid-2025, fully resumed and refactored July 2026.

**Completed:**

- FastAPI backend with `/encourage` and `/predict` endpoints (Juniper2.0 core)
- SQLite persistence via SQLAlchemy — expenses survive backend restarts
- Full expense CRUD — add, list, delete via REST API
- Flutter dashboard — live expense list, real-time spending total, swipe to delete
- Add expense bottom sheet — merchant, amount, category, mood tag, essential toggle
- Juniper2.0 response displayed after every expense submission
- Riverpod state management wired to backend
- Environment variable security on both Flutter and FastAPI sides
- Color palette and design system — "Warm & Hopeful" theme
- "Encouraged, not guilty" UX philosophy applied throughout

**In progress:**

- Juniper2.0 dashboard greeting card — wired to real spending data
- Mood tag display on expense tiles
- Tip content tuning — more contextual Juniper responses

**Planned:**

- Journal screen — write entries, link to purchases, tag moods
- Piggybank screen — savings goals with celebratory animations
- Data/analytics tab — spending trends, mood vs spending patterns
- Resources tab — educational financial literacy content
- Persistent Juniper floating button — accessible from every screen
- CSV/XLSX export
- Plaid / OAuth2 bank linking
- APK build for personal use / Play Store submission

---

## Contributing

This is a solo passion project but contributions, feedback, and ideas are welcome — especially from people who are the target audience.

If you want to contribute:

1. Fork the repo
2. Create a branch (`git checkout -b feature/your-feature-name`)
3. Make your changes
4. Run `flutter analyze` and make sure there are no errors
5. Open a pull request with a clear description of what you changed and why

**Please keep the spirit of the project in mind.** PRs that introduce punitive UI patterns, red color usage for negative states, or shame-based language will not be merged. The emotional contract with the user is non-negotiable.

**Found a bug or have a feature idea?**
Open an issue — especially if you're a neurodivergent person who has thoughts on what would actually be useful.

---

## License

Designed and built by © Alexis M Vasquez [@alexisvassquez](https://github.com/alexisvassquez) 2026

This project is protected under the GPLv3 License. See [LICENSE.txt](LICENSE.txt) for full terms.
