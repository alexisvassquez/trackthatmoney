import 'package:flutter/material.dart';

/// Track That Money
/// lib/ui/dashboard/data/data_container.dart

class DashboardData {
  final String userName;
  final Mood mood;
  final String affirmation;
  final List<Insight> insights;
  final List<Expense> topExpenses;
  final VoidCallback onOpenChatbot;
  final VoidCallback onViewAllExpenses;

  const DashboardData({
    required this.userName, 
    required this.mood,
    required this.affirmation,
    required this.insights,
    required this.topExpenses,
    required this.onOpenChatbot,
    required this.onViewAllExpenses,
  });
}
