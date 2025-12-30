import 'package:flutter/material.dart';
import 'expense_tile_vm.dart';

/// Track That Money
/// lib/ui/models/model_mapping.dart
/// Central place for domain models + UI mapping helpers

class Mood {
  final String hint;    // mood label "motivated"
  final String emoji;
  const Mood({required this.hint, required this.emoji});
}

class Insight {
  final String title;    // "this week"
  final String value;    // currency formatted "$0.00"
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
  final DateTime postedAt;
  final bool isSubscription;

  const DomainExpense({
    required this.uuid,
    required this.userUuid,
    required this.merchant,
    required this.category,
    required this.amountCents,
    required this.postedAt,
    required this.isSubscription,
  });
}

ExpenseTileVM mapExpenseToTileVM(DomainExpense e) {
  return ExpenseTileVM(
    uuid: e.uuid,
    emoji: _emojiForCategory(e.category, isSubscription: e.isSubscription),
    title: e.merchant,
    subtitle: "${e.category} • ${_formatDate(e.postedAt)}",
    amountText: _formatCurrencyCents(e.amountCents),
  );
}

String _formatCurrencyCents(int cents) => '\$' + (cents / 100).toStringAsFixed(2);

String _formatDate(DateTime d) => "${d.month}/${d.day}/${d.year}";

String _emojiForCategory(String category, {bool isSubscription = false}) {
  final c = category.toLowerCase();
  if (isSubscription) return '☁️';
  if (c.contains('grocery') || c.contains('grocer') || c.contains('food')) return '🍅';
  if (c.contains('dining') || c.contains('restaurant') || c.contains('cafe')) return '🍽️';
  if (c.contains('transportation') || c.contains('transit') || c.contains('bus')) return '🚍';
  if (c.contains('utilities') || c.contains('internet') || c.contains('phone')) return '📱';
  if (c.contains('health') || c.contains('copay') || c.contains('pharmacy')) return '🏥';
  if (c.contains('entertain') || c.contains('music') || c.contains('gaming')) return '🎧';
  return '💳';
}
