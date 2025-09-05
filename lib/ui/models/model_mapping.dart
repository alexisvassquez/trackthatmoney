import 'package:uui/uuid.dart';

/// Track That Money
/// lib/ui/models/model_mapping.dart

class Mood {
  final String hint;    // mood label ("motivated")
  final String emoji;
  const Mood({required this.hint, required this.emoji});
}

class Insight {
  final String title;    // "this week spending"
  final String value;    // currency formatted for display ("$0.00")
  final String subtext;  // category
  final IconData icon;   // UI
  const Insight({
    required this.title, 
    required this.value, 
    required this.subtext,
    required this.icon,
  });
}

class DomainExpense {
  final String uuid;
  final String userUuid;
  final String merchant;
  final String category;
  final int amountCents;
  final DateTime date;
  final String emoji;
  final bool isSubscription;

  const DomainExpense({
    required this.uuid,
    required this.userUuid,
    required this.merchant,
    required this.category,
    required this.amountCents,
    required this.date,
    required this.emoji,
    required this.isSubscription,
  });
}

class ExpenseTileVM {
  final String uuid;        // identity for actions/nav
  final String emoji;       // quick category visual
  final String title;       // merchant name
  final String subtitle;    // category
  final String amountText;  // currency format "$0.00"

  const ExpenseTileVM({
    required this.uuid,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.subtitle,
    required this.amountText,
  });
}
