import 'lib/models/expense.dart';

void main() {
    Expense testExpense = Expense(
        id: '001',
        category: 'Coffee',
        amount: 4.75,
        date: DateTime.now(),
        note: 'Coding at the workstation ☕',
    );

    // Convert to JSON
    Map<String, dynamic> json = testExpense.toJson();
    print('Serialized JSON: $json');

    // Convert back to Expense
    Expense newExpense = Expense.fromJson(json);
    print('\nDeserialized Expense:');
    print('ID: ${newExpense.id}');
    print('Category: ${newExpense.category}');
    print('Amount: \$${newExpense.amount}');
    print('Date: ${newExpense.date}');
    print('Note: ${newExpense.note}');
}

