import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/user_prefs.dart';
import '../services/expense_api.dart';

/// Track That Money
/// lib/state/user_providers.dart
/// Serves as the centralized state provider for the application.
/// It acts as a single source of truth, decoupled from individual UI components.

// Auth state
// emits whenever the user signs in/out
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Current user's ID
// null when signed out
final currentUuidProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).value?.uid;
});

// Current user name
// user name is null if not set
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
  ref.watch(currentUuidProvider);
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

// Savings goals provider
final goalsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ExpenseApi.fetchGoals();
});
