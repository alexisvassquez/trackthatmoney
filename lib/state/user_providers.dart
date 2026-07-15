import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_prefs.dart';
import '../services/expense_api.dart';

/// Track That Money
/// lib/state/user_providers.dart

// Current user name (null if not set)
// User Name
final userNameProvider = FutureProvider<String?>((ref) async {
  return UserPrefs.getUserName();
});

// Invalidates the reader so UI updates
final setUserNameProvider = Provider<Future<void> Function(String)>((ref) {
  return (String name) async {
    await UserPrefs.setUserName(name);
    ref.invalidate(userNameProvider);
  };
});

// Expenses
final expensesProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  return ExpenseApi.fetchExpenses();
});

// Calls after adding an expense to force a refresh
final refreshExpensesProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    ref.invalidate(expensesProvider);
  };
});

// Journal provider
final journalProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ExpenseApi.fetchJournal();
});

// Summary provider, fetches expenses summary
final summaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return ExpenseApi.fetchSummary();
});

// Affirmations provider, shuffles affirmations
final affirmationProvider = FutureProvider<String>((ref) async {
  return ExpenseApi.fetchAffirmation();
});
