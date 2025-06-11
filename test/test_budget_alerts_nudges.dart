import 'package:track_that_money/models/expense.dart';
import 'package:track_that_money/models/budget_plan.dart';
import 'package:track_that_money/services/budget_summary.dart';
import 'package:track_that_money/services/nudge_bot.dart';

void main() {
    final budgets = [
        BudgetPlan(category: 'Groceries', monthlyLimit: 1000.0),
        BudgetPlan(category: 'Rent', monthlyLimit: 2000.0),
        BudgetPlan(category: 'Transportation', monthlyLimit: 300.0),
        BudgetPlan(category: 'Dining Out', monthlyLimit: 150.0),
    ];

    final expenses = [
        Expense(
            category: 'Groceries',
            amount: 750.0,
            date: DateTime(2025, 6, 10),
            note: 'Bulk food haul',
        ),
        Expense(
            category: 'Rent',
            amount: 2000.0,
            date: DateTime(2025, 6, 1),
            note: 'Monthly rent',
        ),
        Expense(
            category: 'Transportation',
            amount: 50.0,
            date: DateTime(2025, 6, 5),
            note: 'Weekly bus pass',
        ),
        Expense(
            category: 'Dining Out',
            amount: 10.0,
            date: DateTime(2025, 6, 3),
            note: 'Blue Lotus Latte @ The Seed',
        ),
    ];

    final summary = BudgetSummary(expenses: expenses, budgets: budgets);

    print('\n🔔 Budget Alerts (≥ 75% usage):');
    final alerts = summary.getAlerts();
    alerts.forEach((cat, msg) => print(msg));

    print('\n🤖 Nudge Bot Suggestions:');
    final bot = NudgeBot(summary);
    final suggestions = bot.getSuggestions();
    suggestions.forEach(print);
}
