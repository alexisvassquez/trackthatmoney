import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Track That Money
/// lib/services/expense_api.dart
/// Flutter service layer
/// HTTP services for CRUD endpoints + Juniper2.0 responses.
/// Token read from .env variables

class ExpenseApi {
  // Android emulator -> localhost
  static String get _base =>
      dotenv.env['TTM_API_BASE'] ?? 'http://10.0.2.2:8000';
  static String get _token => dotenv.env['TTM_API_TOKEN'] ?? '';

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_token',
  };

  // EXPENSES
  // Fetch all expenses, newest first
  static Future<List<Map<String, dynamic>>> fetchExpenses() async {
    final response = await http.get(
      Uri.parse('$_base/expenses'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch expenses: ${response.statusCode}');
  }

  // Log a new expense
  // Returns the saved record including Juniper's message
  // Includes: merchant, category, amount, is essential/subscription,
  // mood tag/score, user note, timestamp
  static Future<Map<String, dynamic>> addExpense({
    required String merchant,
    required String category,
    required double amount,
    int isEssential = 0,
    int isSubscription = 0,
    String? moodTag,
    double? moodScore,
    String? note,
  }) async {
    final body = jsonEncode({
      'merchant': merchant,
      'category': category,
      'amount': amount,
      'is_essential': isEssential,
      'is_subscription': isSubscription,
      'mood_tag': moodTag,
      'mood_score': moodScore,
      'note': note,
      'entry_day_of_week': _dayOfWeek(),
      'entry_time': _timeOfDay(),
    });

    final response = await http.post(
      Uri.parse('$_base/expenses'),
      headers: _headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to add expense: ${response.statusCode}');
  }

  // Timestamp posted
  static String _dayOfWeek() {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[DateTime.now().weekday - 1];
  }

  static String _timeOfDay() {
    final h = DateTime.now().hour;
    if (h < 12) return 'morning';
    if (h < 17) return 'afternoon';
    return 'evening';
  }

  // Delete saved expenses
  static Future<void> deleteExpense(String id) async {
    final response = await http.delete(
      Uri.parse('$_base/expenses/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete expense: ${response.statusCode}');
    }
  }

  // Update expenses
  static Future<Map<String, dynamic>> updateExpense({
    required String id,
    String? merchant,
    String? category,
    double? amount,
    int? isEssential,
    int? isSubscription,
    String? moodTag,
    String? note,
  }) async {
    final body = jsonEncode({
      'merchant': merchant,
      'category': category,
      'amount': amount,
      'is_essential': isEssential,
      'is_subscription': isSubscription,
      'mood_tag': moodTag,
      'note': note,
    }..removeWhere((_, v) => v == null));

    final response = await http.patch(
      Uri.parse('$_base/expenses/$id'),
      headers: _headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to update expense: ${response.statusCode}');
  }

  // JOURNAL
  // Add journal entries
  // Includes content, mood tags, links to expenses
  static Future<Map<String, dynamic>> addJournalEntry({
    required String content,
    String? moodTag,
    String? expenseId,
  }) async {
    final body = jsonEncode({
      'content': content,
      'mood_tag': moodTag,
      'expense_id': expenseId,
    });

    final response = await http.post(
      Uri.parse('$_base/journal'),
      headers: _headers,
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to save journal entry: ${response.statusCode}');
  }

  // Fetch list of logged journal entries
  static Future<List<Map<String, dynamic>>> fetchJournal() async {
    final response = await http.get(
      Uri.parse('$_base/journal'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch journal: ${response.statusCode}');
  }

  // Delete any logged journal entries
  static Future<void> deleteJournalEntry(String id) async {
    final response = await http.delete(
      Uri.parse('$_base/journal/$id'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete journal entry: ${response.statusCode}');
    }
  }

  // SAVINGS GOALS
  // Fetch list of goals
  static Future<List<Map<String, dynamic>>> fetchGoals() async {
    final response = await http.get(
      Uri.parse('$_base/goals'),
      headers: _headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    }
    throw Exception('Failed to fetch goals: ${response.statusCode}');
  }

  // Create a savings goal
  // Goal name, target amount, icon, primary tag
  static Future<Map<String, dynamic>> createGoal({
    required String name,
    required double target,
    String? icon,
    int isPrimary = 0,
  }) async {
    final body = jsonEncode({
      'name': name,
      'target': target,
      'icon': icon,
      'is_primary': isPrimary,
    });
    final response = await http.post(
      Uri.parse('$_base/goals'),
      headers: _headers,
      body: body,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to create goal: ${response.statusCode}');
  }

  // Update savings amount towards target amount
  static Future<Map<String, dynamic>> addToSavings({
    required String goalId,
    required double amount,
  }) async {
    final body = jsonEncode({'amount': amount});
    final response = await http.patch(
      Uri.parse('$_base/goals/$goalId'),
      headers: _headers,
      body: body,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to update savings: ${response.statusCode}');
  }

  // Set a chosen goal as primary
  static Future<void> setPrimaryGoal(String goalId) async {
    final response = await http.patch(
      Uri.parse('$_base/goals/$goalId/primary'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to set primaru goal: ${response.statusCode}');
    }
  }

  // Delete a goal
  static Future<void> deleteGoal(String goalId) async {
    final response = await http.delete(
      Uri.parse('$_base/goals/$goalId'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete goal: ${response.statusCode}');
    }
  }

  // SUMMARY
  // Fetch expenses summary
  static Future<Map<String, dynamic>> fetchSummary() async {
    final response = await http.get(
      Uri.parse('$_base/expenses/summary'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    throw Exception('Failed to fetch summary: ${response.statusCode}');
  }

  // Dynamic affirmations pulled from JSON library in encouragement engine
  static Future<String> fetchAffirmation() async {
    final response = await http.get(
      Uri.parse('$_base/affirmation'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['affirmation'] as String;
    }
    // fallback
    return "Awareness is progress. Tiny wins count.";
  }
}
