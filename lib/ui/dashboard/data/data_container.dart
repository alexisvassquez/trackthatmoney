import 'package:flutter/material.dart';

/// Track That Money
/// lib/ui/dashboard/data/data_container.dart

class DashboardData {
  final String userName;
  final Mood mood;
  final String affirmation;
  final List<Insight> insights;
  final List<Expense> topExpenses;

  const DashboardData({
    required this.userName, 
