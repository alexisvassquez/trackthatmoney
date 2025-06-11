import 'lib/models/expense.dart';
import 'lib/models/budget_plan.dart';
import 'lib/services/budget_summary.dart';

void main() {
    // Mock budget plans
    final budgets = [
        BudgetPlan(category: 'Groceries', monthlyLimit: 1000.0),
        BudgetPlan(category: 'Rent', monthlyLimit: 2000.0),
        BudgetPlan(category: 'Transportation', monthlyLimit: 300.0),
    ];

    // Mock expenses
    final expenses = [
        Expense(
            id: 'exp1', 
            category: 'Groceries', 
            amount: 220.0, 
            date: DateTime(2025, 6, 3), 
            note: 'Weekly grocery run',
        ),
        Expense(
            id: 'exp2', 
            category: 'Groceries', 
            amount: 180.0, 
            date: DateTime(2025, 6, 10),
            note: 'Weekly grocery run',
        ),
        Expense(
            id: 'exp3', 
            category: 'Rent', 
            amount: 2000.0, 
            date: DateTime(2025, 6, 1),
            note: 'Ugh just take it',
        ),
        Expense(
            id: 'exp4', 
            category: 'Transportation', 
            amount: 80.0, 
            date: DateTime(2025, 6, 5),
            note: 'Weekly bus ticket',
        ),
        Expense(
            id: 'exp5', 
            category: 'Transportation', 
            amount: 25.0, 
            date: DateTime(2025, 6, 7),
            note: 'Uber to Miami',        
        ),
    ];

    final summary = BudgetSummary(expenses: expenses, budgets: budgets);
    final report = summary.generateFullSummary();

    for (var categoryReport in report) {
        print('📊 Category: ${categoryReport['category']}');
        print('   Limit: \$${categoryReport['limit']}');
        print('   Spent: \$${categoryReport['spent']}');
        print('   Remaining: \$${categoryReport['remaining']}');
        print('   Percent Used: ${(categoryReport['percentUsed'] * 100).toStringAsFixed(1)}%\n');
    }

    // Simple assertions
    assert(summary.totalSpent('Groceries') == 400.0);
    assert(summary.remaining('Groceries') == 600.0);
    assert((summary.percentUsed('Groceries') * 100).round() == 40);
    print('✅ BudgetSummary logic test passed.');
}
