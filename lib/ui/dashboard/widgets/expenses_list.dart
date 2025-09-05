import 'package:flutter/material.dart';
import '..lib/ui/theme/colors.dart';
import '../widgets/dashboard_screen.dart';

/// Track That Money
/// lib/ui/dashboard/widgets/expenses_list.dart

class _ExpenseTile extends StatelessWidget {
  final Expense expense;
  const _ExpenseTile({required this.expense});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(.5),
          width: 1,
        ),
      ),
      child: Row(children: [
        Container(
          height: 44,
          width: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            expense.emoji, 
            style: const TextStyle(fontSize: 22),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.merchant,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 2),
              Text(
                '${expense.category} - ${_formatDate(expense.date)}',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        SizedBox(width: 8),
        Text(
          _formatCurrency(expense.amount),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ]),
    ),
  }
}

String _formatCurrency(double v) => '\$' + v.toStringAsFixed(2);
String _formatDate(DateTime d) => '${d.month}/${d.day}/${d.year}';
