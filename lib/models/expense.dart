// track_that_money
// lib/models/expense.dart

import 'package:uuid/uuid.dart';

class Expense {
    final String id;
    final String category;
    final double amount;
    final bool isEssential;
    final DateTime date;
    final double moodScore;
    final double goalContribution;
    final bool isSubscription;
    final String note;

    static const _uuid = Uuid();

    Expense({
        String? id,
        required this.category,
        required this.amount,
        required this.isEssential,
        required this.date,
        required this.moodScore,
        required this.goalContribution,
        required this.isSubscription,
        required this.note,
    }) : id = id ?? _uuid.v4();

    // Convert to JSON (Map<String, dynamic>)
    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'category': category,
            'amount': amount,
            'isEssential': isEssential,
            'date': date.toIso8601String(),
            'moodScore': moodScore,
            'goalContribution': goalContribution,
            'isSubscription': isSubscription,
            'note': note,
        };
    }

    // Create Expense object from JSON (Map<String, dynamic>)
    factory Expense.fromJson(Map<String, dynamic> json) {
        return Expense(
            id: json['id'],
            category: json['category'],
            amount: json['amount'].toDouble(),
            isEssential: json['isEssential'],
            date: DateTime.parse(json['date']),
            moodScore: json['moodScore'].toDouble(),
            goalContribution: json['goalContribution'].toDouble(),
            isSubscription: json['isSubscription'] ?? false,
            note: json['note'],
        );
    }
}
        


