/// track_that_money
/// lib/models/analytics_stub.dart
import 'dart:convert';

/// Represents a single financial insight from a transaction
class SpendingInsight {
    final String category;
    final double amount;
    final String mood;
    final DateTime timestamp;

    SpendingInsight({
        required this.category,
        required this.amount,
        required this.mood,
        required this.timestamp,
    });

    /// Creates a SpendingInsight from a JSON map
    factory SpendingInsight.fromJson(Map<String, dynamic> json) {
        return SpendingInsight(
            category: json['category'] ?? 'Unknown',
            amount: (json['amount'] ?? 0).toDouble(),
            mood: json['mood'] ?? 'neutral',
            timestamp: DateTime.parse(json['timestamp']),
        );
    }

    /// Converts this SpendingInsight to a JSON map
    Map<String, dynamic> toJson() {
        return {
            'category': category,
            'amount': amount,
            'mood': mood,
            'timestamp': timestamp.toIso8601String(),
        };
    }

    @override
    String toString() =>
        '[$timestamp] $category: \$$amount (mood: $mood)';
}

/// Loads a list of SpendingInsight objects from a JSON string
List<SpendingInsight> parseInsights(String jsonString) {
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded
        .map((item) => SpendingInsight.fromJson(item))
        .toList();
}
