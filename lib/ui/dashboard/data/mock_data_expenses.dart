import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../lib/ui/theme/colors.dart';
import '../widgets/dashboard_screen.dart';

/// Track That Money
/// lib/ui/dashboard/data/mock_data_expenses.dart

const _mockExpenses = <Expense>[
  Expense(id: '1', merchant: 'Publix', category: 'Groceries', amount: 42.67, date: DateTime(2025, 9, 4), emoji: '🫑'),
  Expense(id: '2', merchant: 'BCT', category: 'Transportation', amount: 5.00, date: DateTime(2025, 9, 3), emoji: '🚍'),
  Expense(id: '3', merchant: 'Spotify', category: 'Subscription', amount: 11.99, date: DateTime(2025, 9, 4), emoji: '🎧'),
  Expense(id: '4', merchant: 'Google Fi', category: 'Phone', amount: 55.36, date: DateTime(2025, 9, 3), emoji: '📱'),
  Expense(id: '5', merchant: 'BandCamp', category: 'Merch', amount: 10.84, date: DateTime(2025, 9, 2), emoji: '💿'),
];
