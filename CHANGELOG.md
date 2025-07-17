## [0.2.0] - 2025-06-13

### Added
- `piggy_bank_goal.dart` model class with `goalName`, `targetAmount`, and `currentAmount` fields
- `test/test_piggy_bank_goal.dart` unit test suite verifying goal initialization and savings update logic
- `journal_entry.dart` model updated to include UUID generation for each entry
- `test/test_mood_savings_entry.dart` suite created to validate UUID length and journal field integrity

### Changed
- Personalized piggy bank goal entries to reflect real-life savings targets:
  - Move to London
  - Build Raspberry Pi Mini PC
  - Emergency Fund
  - Charli XCX Tickets 🍏

### Fixed
- UI dependency errors in test suites by isolating model logic
- Incomplete property declarations in test assertions (e.g., missing `currentAmount`)

---

## [0.3.0] - 2025-07-15

### Added
- `Subscriptions` category added to `tips_with_mood_and_weights.json` with mood-based tips across `celebrate`, `caution`, and `alert`
- `isSubscription` field added to `expense.dart` model and JSON serialization logic
- `is_subscription` feature added to `predictor.py` model training and prediction logic
- New backend module: `subscriptions_insights.py` under `juniper2_core/subscription/`, which:
  - Calculates monthly subscription totals
  - Tracks % of budget spent on subscriptions
  - Detects "subscription fatigue" and assigns a `fatigue_rating` (celebrate / caution / alert)

### Changed
- Updated training data structure in `predictor.py` to support `is_subscription` feature for better model granularity

### Fixed
- Normalized subscription category handling across JSON inputs, predictor, and insights engine

---

## [0.3.0] - 2025-07-16

### Added
- `resources_library.json` with curated beginner-friendly financial education topics
- `educational_resource.dart` model for parsing JSON entries
- `resource_loader.dart` service for loading and decoding the educational content

### Planned
- `learn_tab.dart` UI screen to browse educational cards
- `resource_card.dart` widget for resource previews
- Optional: tag filters, category sections, and link buttons for user guidance

---

## [0.4.0] - 2025-07-17 Advanced Backend Sprint & Second GitHub Star!

- Implemented OAuth2 authentication via `auth.py`
- Patched `api.py` with FastAPI `Depends` for secure route access
- Resolved goblins related to module imports, model features, and Uvicorn startup
- Created `train_model.py` to decouple data generation from prediction logic
- Refactored `predictor.py` to be model-only (Mop Theory™ aligned)
- Verified API runs via Swagger UI and `curl` with token-based access
- Installed `python-multipart` to support form data in `/token` route
- 🌟 Project received its **second GitHub star** during development sprint!

