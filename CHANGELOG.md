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

> Next Steps: Begin `dashboard.dart` wiring, then integrate mood + savings input UI. Juniper2.0 backend logic to follow.
