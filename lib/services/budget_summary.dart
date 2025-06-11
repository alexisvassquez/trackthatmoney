// lib/services/budget_summary.dart

import '../models/expense.dart';
import '../models/budget_plan.dart';

class BudgetSummary {
    final List<Expense> expenses;
    final List<BudgetPlan> budgets;

    BudgetSummary({required this.expenses, required this.budgets});

    /// Calculate total spent in a given category
    double totalSpent(String category) {
        return expenses
            .where((e) => e.category == category)
            .fold(0.0, (sum, e) => sum + e.amount);
    }

    /// Return budget limit for a category
    double? budgetLimit(String category) {
        final match = budgets.firstWhere(
            (b) => b.category == category,
            orElse: () => BudgetPlan(category: category, monthlyLimit: 0.0),
        );
        return match.monthlyLimit;
    }

    /// Get remaining balance for a category
    double remaining(String category) {
        return (budgetLimit(category) ?? 0.0) - totalSpent(category);
    }

    /// Get percent of budget used (0.0 to 1.0)
    double percentUsed(String category) {
        final limit = budgetLimit(category);
        if (limit == null || limit == 0.0) return 0.0;
        return totalSpent(category) / limit;
    }

    /// Generate summary for all budgeted categories
    List<Map<String, dynamic>> generateFullSummary() {
        return budgets.map((b) {
            final spent = totalSpent(b.category);
            final percent = percentUsed(b.category);
            return {
                'id': b.id,
                'category': b.category,
                'limit': b.monthlyLimit,
                'spent': spent,
                'remaining': b.monthlyLimit - spent,
                'percentUsed': percent.clamp(0.0, 1.0),
            };
        }).toList();
    }

    /// Generate auto-trigger alerts exceeding budget cap
    Map<String, String> getAlerts({double warningLevel = 0.75}) {
        final alerts = <String, String>{};
   
        for (var item in generateFullSummary()) {
            final usage = item['percentUsed'] as double;
            if (usage >= warningLevel) {
                alerts[item['category']] =
                    "⚠️ You've used ${(usage * 100).toStringAsFixed(1)}% of your ${item['category']} budget! Let's work on that!";
            }
        }

        return alerts;
    }
}
