// lib/models/budget_plan.dart

import 'package:uuid/uuid.dart';

class BudgetPlan {
    final String id;
    final String category; // e.g., "Groceries", "Rent", "Transportation"
    final double monthlyLimit;

    static const _uuid = Uuid();

    BudgetPlan({
        String? id,
        required this.category,
        required this.monthlyLimit,
    }) : id = id ?? _uuid.v4();

    Map<String, dynamic> toJson() => {
            'id': id,
            'category': category,
            'monthlyLimit': monthlyLimit,
        };

    factory BudgetPlan.fromJson(Map<String, dynamic> json) => BudgetPlan(
            id: json['id'],
            category: json['category'],
            monthlyLimit: json['monthlyLimit'],
        );
}
