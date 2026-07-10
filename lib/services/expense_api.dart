import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Track That Money
/// lib/services/expense_api.dart
/// HTTP service for expense CRUD + Juniper2.0 responses.
/// Token is hardcoded for dev, will be replaced with
/// real auth.

class ExpenseApi {
  // Android emulator -> localhost
  static String get _base =>
      dotenv.env['TTM_API_BASE'] ?? 'http://10.0.2.2:8000';
  static String get _token => dotenv.env['TTM_API_TOKEN'] ?? '';

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $_token',
  };

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
  static Future<Map<String, dynamic>> addExpense({
    required String merchant,
    required String category,
    required double amount,
    int isEssential = 0,
    String? moodTag,
    double? moodScore,
    String? note,
  }) async {
    final body = jsonEncode({
      'merchant': merchant,
      'category': category,
      'amount': amount,
      'is_essential': isEssential,
      'is_subscription': 0,    // wire to UI toggle (todo)
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

  // Affirmations pulled from encourager
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
