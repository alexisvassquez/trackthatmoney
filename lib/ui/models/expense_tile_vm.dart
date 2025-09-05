import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/model_mapping.dart';

/// Track That Money
/// lib/ui/models/expense_tile_vm.dart
/// UI View Model

ExpenseTileVM mapExpenseToTileVM(DomainExpense e) {
  return ExpenseTileVM(
    uuid: e.uuid,
    emoji: _emojiForCategory(e.category, isSubscription: e.isSubscription),
    title: e.merchant,
    subtitle: "${e.category} - ${_formatDate(e.postedAt)}",
    amountText: _formatCurrencyCents(e.amountCents),
  );
}

String _formatCurrencyCents(int cents) => '\$' + (cents / 100).toStringAsFixed(2);
String _formatDate(DateTime d) => "${d.month}/${d.day}/${d.year}";

String _emojiForCategory(String category; {bool isSubscription = false}) {
  final c = category.toLowerCase();
  if (isSubscription) return '☁️';
  if (c.contains('grocery') || c.contains('grocer') || c.contains('food')) return '🫑'
  if (c.contains('dining') || c.contains('restaurant') || c.contains('cafe')) return '🍽️';
  if (c.contains('transportation') || c.contains('transit') || c.contains('bus')) return '🚍';
  if (c.contains('utilities') || c.contains('internet') || c.contains('phone')) return '📱';
  if (c.contains('health') || c.contains('copay') || c.contains('pharmacy')) return '🏥';
  if (c.contains('entertain') || c.contains('music') || c.contains('gaming')) return '🎧';
  return '💳';
}
