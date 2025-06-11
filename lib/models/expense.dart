// lib/models/expense.dart

import 'package:uuid/uuid.dart';

class Expense {
    final String id;
    final String category;
    final double amount;
    final DateTime date;
    final String note;

    static const _uuid = Uuid();

    Expense({
        String? id,
        required this.category,
        required this.amount,
        required this.date,
        required this.note,
    }) : id = id ?? _uuid.v4();

    // Convert to JSON (Map<String, dynamic>)
    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'category': category,
            'amount': amount,
            'date': date.toIso8601String(),
            'note': note,
        };
    }

    // Create Expense object from JSON (Map<String, dynamic>)
    factory Expense.fromJson(Map<String, dynamic> json) {
        return Expense(
            id: json['id'],
            category: json['category'],
            amount: json['amount'].toDouble(),
            date: DateTime.parse(json['date']),
            note: json['note'],
        );
    }
}
        


