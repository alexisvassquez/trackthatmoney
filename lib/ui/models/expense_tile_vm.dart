/// Track That Money
/// lib/ui/models/expense_tile_vm.dart
/// UI View Model

class ExpenseTileVM {
  final String uuid;        // identity for actions/nav
  final String emoji;       // quick category visual
  final String title;       // merchant name
  final String subtitle;    // category + date
  final String amountText;  // currency format "$0.00"

  const ExpenseTileVM({
    required this.uuid,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.amountText,
  });
}
