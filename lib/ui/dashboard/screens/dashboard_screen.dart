import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../state/user_providers.dart';
import '../../../services/expense_api.dart';
import '../widgets/add_expense_sheet.dart';
import '../../theme/colors.dart';

/// Track That Money
/// lib/ui/dashboard/screens/dashboard_screen.dart

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _navIndex = 0;

  final double _budgetThisMonth = 650.00;

  void _openAddExpense() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddExpenseSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.sage,
        foregroundColor: Colors.white,
        onPressed: _openAddExpense,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            // 1. Header
            const _DashboardHeader(),
            const SizedBox(height: 12),

            // 2. Affirmation
            ref.watch(affirmationProvider).when(
              loading: () => const _AffirmationPill(
                text: "✨ ...",
              ),
              error: (_, _) => const _AffirmationPill(
                text: "✨ Awareness is progress. Tiny wins count.",
              ),
              data: (affirmation) => _AffirmationPill(
                text: "✨ $affirmation",
              ),
            ),
            const SizedBox(height: 14),

            // 3. Monthly summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE4CC),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.warmLinen),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.deepMoss.withValues(alpha: .08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 4,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: AppColors.sage,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "This month",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ref.watch(summaryProvider).when(
                                loading: () => const Text(
                                  "...",
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                                ),
                                error: (_, _) => const Text("\$0.00"),
                                data: (summary) => Text(
                                  _formatCurrency((summary['total_spent'] as num).toDouble()),
                                  style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  "spent",
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: cs.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Budget: ${_formatCurrency(_budgetThisMonth)}",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 4. Top expenses
            _SectionHeader(
              title: "Top expenses",
              actionLabel: "View all",
              onAction: () => _toast(
                context,
                "TODO: Navigate to full expenses list. In development.",
              ),
            ),
            const SizedBox(height: 10),

            // ExpensesTile wrapped in dismissible
            ref
                .watch(expensesProvider)
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text(
                    "Couldn't load expenses — is the backend running?",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  data: (expenses) {
                    if (expenses.isEmpty) {
                      return _EmptyExpensesCard(
                        message: "No expenses yet — future you says thanks. 🙂",
                        onAdd: _openAddExpense,
                      );
                    }
                    return Column(
                      children: expenses.take(5).map((e) {
                        final id = e['id'] as String;
                        return Dismissible(
                          key: Key(id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: AppColors.amber,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (_) async {
                            try {
                              await ExpenseApi.deleteExpense(id);
                              ref.invalidate(expensesProvider);
                            } catch (err) {
                              if (context.mounted) {
                                _toast(context, 'Could not delete expense.');
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _ExpenseTile(
                              expense: _ExpenseRow(
                                label:
                                    e['merchant'] as String? ??
                                    e['category'] as String? ??
                                    'Expense',
                                amount: (e['amount'] as num).toDouble(),
                                icon: _iconForCategory(
                                  e['category'] as String? ?? '',
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
          ],
        ),
      ),

      // Bottom nav
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _navIndex = index);
          _toast(context, "TODO: route index=$index. In development.");
        },
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurface.withValues(alpha: .60),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Data"),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings),
            label: "Piggybank",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

// ─── Widgets ────────────────────────────────────────────────────────────────

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Track That Money 💸",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          "An expense tracking app to know why you're broke",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

class _AffirmationPill extends StatelessWidget {
  final String text;
  const _AffirmationPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.peachLight,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.peach.withValues(alpha: .5)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.deepMoss,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(
            actionLabel,
            style: TextStyle(color: cs.primary, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _ExpenseRow {
  final String label;
  final double amount;
  final IconData icon;

  const _ExpenseRow({
    required this.label,
    required this.amount,
    required this.icon,
  });
}

class _ExpenseTile extends StatelessWidget {
  final _ExpenseRow expense;
  const _ExpenseTile({required this.expense});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.sand,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warmLinen),
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: AppColors.sageMist,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(expense.icon, color: AppColors.sageDark, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              expense.label,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            _formatCurrency(expense.amount),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

class _EmptyExpensesCard extends StatelessWidget {
  final String message;
  final VoidCallback onAdd;

  const _EmptyExpensesCard({required this.message, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: .45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: .55)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(onPressed: onAdd, child: const Text("Add")),
        ],
      ),
    );
  }
}

// ─── Helpers ────────────────────────────────────────────────────────────────

String _formatCurrency(double value) => "\$${value.toStringAsFixed(2)}";

IconData _iconForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'food':
      return Icons.restaurant;
    case 'groceries':
      return Icons.shopping_cart;
    case 'transport':
      return Icons.directions_bus;
    case 'entertainment':
      return Icons.movie;
    case 'subscriptions':
      return Icons.repeat;
    case 'clothing':
      return Icons.checkroom;
    case 'health':
      return Icons.favorite;
    default:
      return Icons.attach_money;
  }
}

void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
