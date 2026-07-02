# 💸 Track That Money

## 📦 CHANGELOG

---

## [0.6.0] - 2026-07-02

### Major Refactor & Project Revival

After an extended hiatus, the project was fully resumed and refactored. This release focused on
stabilizing the codebase, resolving accumulated technical debt, and re-centering the project vision.

#### Fixed

- Resolved 780 → 2 `flutter analyze` issues across the codebase
- Deleted `ui/dashboard.dart` — dead legacy file causing 302 cascading errors
- Fixed broken import paths across `header_row.dart`, `insights_grid.dart`, `bottom_nav.dart`, `expenses_list.dart`, `learn_and_grow_screen.dart`
- Fixed unresolved Git merge conflict in `container_card.dart` (`<<<<<<< HEAD` markers left in source)
- Fixed `$1` regex substitution artifacts left in `dashboard_screen.dart` from a bad find-and-replace
- Fixed `journal_entry.dart` — `toJson()` and `fromJson()` were accidentally outside the class body; constructor used `this.date` but field was named `timestamp`
- Fixed `juniper_sheet.dart` — `extended` instead of `extends`, `circuler` typo, `const` list being mutated, undefined `reply` variable
- Fixed `insights_grid.dart` — `matrial` typo in Flutter import, class name mismatch (`_InsightsCard` vs `_InsightsGrid`)
- Fixed `header_row.dart` — space in package import (`package: flutter`), comma instead of semicolon, `user` referenced but not a parameter
- Fixed `wallet_frame.dart` — `_StitchesPainter` constructor not initializing final fields with `this.`, `inset` field mismanagement
- Fixed `user_providers.dart` — syntax error in setter provider definition
- Fixed `app.dart` — missing `theme/theme.dart` import causing `buildAppTheme()` undefined
- Fixed `journal_form.dart` — `SizedBox` typo, private type leaking into public API via `createState()`
- Fixed `data_container.dart` — `List<Expense>` replaced with correct `List<DomainExpense>`
- Fixed `theme.dart` — `CardTheme` renamed to `CardThemeData`, deprecated `background`/`onBackground` replaced with `surface`/`onSurface`
- Fixed `learn_and_grow_screen.dart` — unterminated string literal causing 40 cascading errors, `horizonal` and `BoxDecoraton` typos, wrong import paths
- Replaced all deprecated `withOpacity()` calls with `withValues(alpha:)` across the codebase
- Added missing `url_launcher` dependency to `pubspec.yaml`
- Removed `DomainExpense.create()` call without factory — added factory constructor to `model_mapping.dart`

#### Changed

- `main.dart` cleaned up — removed duplicate `TrackThatMoneyApp` definition, now delegates to `app.dart`
- `JuniperSheet` — `_ChatMessage` made private to match `_Role`; `const` list made mutable; stub response added for `_send()`
- `bottom_nav.dart` — `_BottomBar` made public as `BottomBar`; import paths corrected
- `header_row.dart` — fully rewritten as `HeaderRow` (public); broken private widget references replaced with self-contained implementation
- `insights_grid.dart` — fully rewritten as `InsightsGrid` (public); removed dependency on undefined `_ContainerCard`
- Deleted `ui/dashboard/widgets/expenses_list.dart` — dead code, nothing referenced `_ExpenseTile`
- Removed `_openJuniperAssistant` dead function from `dashboard_screen.dart`
- Removed unused `journal_screen.dart` — half-baked, will be rebuilt properly in a future sprint

#### Documentation

- README fully rewritten — added "Who this is for" section, comparison table vs traditional finance apps, full getting started guide, project structure tree, API endpoints table, contributing guidelines
- Updated color palette in README to reflect new warm palette
- CHANGELOG updated (this entry)
- Tagline restored: *"An expense tracking app to know why you're broke"* — it stays, it has a story

---

## [0.5.0] - 2025-09-xx

### Dashboard & UI Architecture Sprint

- Refactored dashboard from monolith into modular widget structure
- Created `DashboardScreen` as the canonical dashboard (replaced `DashboardPage`)
- Added `WalletFrame` widget with custom `_StitchesPainter` for decorative stitch border
- Added `ContainerCard` reusable widget
- Added `HeaderRow`, `InsightsGrid`, `BottomBar` widgets as separate files
- Created view model layer — `ExpenseTileVM`, `DashboardTileVM`, `model_mapping.dart`
- Added mock expense data in `mock_data_expenses.dart` using `DomainExpense`
- Added `DashboardData` container model
- Added `preview_shell.dart` and dev preview entry points for isolated widget testing
- Added shared user name preferences via `UserPrefs` and Riverpod providers
- Integrated `go_router` for navigation and `flutter_riverpod` for state management
- Defined `AppColors` palette and `buildAppTheme()` in `theme/colors.dart` and `theme/theme.dart`

---

## [0.4.0] - 2025-07-17

### Advanced Backend Sprint & Second GitHub Star

- Implemented OAuth2 authentication via `auth.py`
- Patched `api.py` with FastAPI `Depends` for secure route access
- Resolved errors related to module imports, model features, and Uvicorn startup
- Created `train_model.py` to decouple data generation from prediction logic
- Refactored `predictor.py` to be model-only
- Verified API runs via Swagger UI and `curl` with token-based access
- Installed `python-multipart` to support form data in `/token` route
- 🌟 Project received its second GitHub star during development sprint!

---

## [0.3.0] - 2025-07-16

### Educational Resources

- `resources_library.json` with curated beginner-friendly financial education topics
- `educational_resource.dart` model for parsing JSON entries
- `resource_loader.dart` service for loading and decoding the educational content

### Planned

- `learn_tab.dart` UI screen to browse educational cards
- `resource_card.dart` widget for resource previews
- Optional: tag filters, category sections, and link buttons for user guidance

---

## [0.3.0] - 2025-07-15

### Subscription Intelligence

- `Subscriptions` category added to `tips_with_mood_and_weights.json` with mood-based tips across `celebrate`, `caution`, and `alert`
- `isSubscription` field added to `expense.dart` model and JSON serialization logic
- `is_subscription` feature added to `predictor.py` model training and prediction logic
- New backend module: `subscriptions_insights.py` under `juniper2_core/subscription/`:
  - Calculates monthly subscription totals
  - Tracks % of budget spent on subscriptions
  - Detects "subscription fatigue" and assigns a `fatigue_rating` (celebrate / caution / alert)

### Changed

- Updated training data structure in `predictor.py` to support `is_subscription` feature

### Fixed

- Normalized subscription category handling across JSON inputs, predictor, and insights engine

---

## [0.2.0] - 2025-06-13

### Piggy Bank & Journal Foundation

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

## [0.1.0] - 2025 (Initial builds)

### Foundation

- Initial Flutter project scaffold
- Core models: `Expense`, `Goal`, `BudgetPlan`, `IncomeEntry`, `JournalEntry`
- `BudgetSummary` service — spending totals, budget limits, alerts, percent used
- `NudgeBot` for budget alert messages
- `BudgetExport` for CSV/XLSX export logic
- Initial Juniper2.0 scaffold — `SpendingPredictor` with simulated training data
- `EncouragementEngine` with mood-weighted tips from JSON dataset
- FastAPI `api.py` with `/encourage`, `/predict`, and `/token` endpoints
- CORS middleware configured
- Unit test coverage for budget summary, expense, goal, journal entry models
- 🌟 First GitHub star received
