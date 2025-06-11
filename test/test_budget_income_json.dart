import 'dart:convert';
import 'lib/models/budget_plan.dart';
import 'lib/models/income.dart';

void main() {
    // Test BudgetPlan
    final groceriesBudget = BudgetPlan(
        category: 'Groceries', 
        monthlyLimit: 1000.0,
    );

    final groceriesJson = jsonEncode(groceriesBudget.toJson());
    print('🛒 BudgetPlan JSON: $groceriesJson');

    final decodedBudget = BudgetPlan.fromJson(jsonDecode(groceriesJson));
    assert(decodedBudget.category == groceriesBudget.category);
    assert(decodedBudget.monthlyLimit == groceriesBudget.monthlyLimit);
    print('✅ BudgetPlan test passed.\n');

    // Test IncomeEntry with tags
    final freelanceIncome = IncomeEntry(
        source: 'Freelance',
        amount: 500.0,
        receivedDate: DateTime(2025, 6, 1),
        tags: ['remote', 'side-hustle'],
    );

    final incomeJson = jsonEncode(freelanceIncome.toJson());
    print('💸 IncomeEntry JSON: $incomeJson');

    final decodedIncome = IncomeEntry.fromJson(jsonDecode(incomeJson));
    assert(decodedIncome.source == freelanceIncome.source);
    assert(decodedIncome.amount == freelanceIncome.amount);
    assert(decodedIncome.receivedDate == freelanceIncome.receivedDate);
    assert(decodedIncome.tags.join(',') == freelanceIncome.tags.join(','));
    print('✅ IncomeEntry test passed.');
} 
