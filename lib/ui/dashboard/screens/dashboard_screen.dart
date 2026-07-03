import 'package:flutter/material.dart';
import '../../theme/colors.dart';

/// Track That Money
/// lib/ui/dashboard/screens/dashboard_screen.dart
/// v0.2 Removed wallet frame
/// Pivoting in different design

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;

  final String _affirmation = "✨ Awareness is progress. Tiny wins count.";
  final double _spentThisMonth = 312.45;
  final double _budgetThisMonth = 650.00;

  final List<_ExpenseRow> _topExpenses = const [
    _ExpenseRow(label: "Groceries", amount: 95.76, icon: Icons.shopping_cart),
    _ExpenseRow(label: "Bus pass", amount: 5.00, icon: Icons.directions_bus),
    _ExpenseRow(label: "Spotify", amount: 13.47, icon: Icons.music_note),
    _ExpenseRow(label: "Google Fi", amount: 55.36, icon: Icons.phone_android),
    _ExpenseRow(label: "Work clothes", amount: 17.98, icon: Icons.checkroom),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
          children: [
            // 1. Header
            const _DashboardHeader(),
            const SizedBox(height: 12),

            // 2. Affirmation
            _AffirmationPill(text: _affirmation),
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
                    // Sage accent bar
                    Container(
                      width: 4,
                      margin: const EdgeInsets.only(right: 16),
                      decoration: BoxDecoration(
                        color: AppColors.sage,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    // Content
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
                              Text(
                                _formatCurrency(_spentThisMonth),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
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

            if (_topExpenses.isEmpty)
              _EmptyExpensesCard(
                message: "No expenses yet — future you says thanks. 🙂",
                onAdd: () => _toast(
                  context,
                  "TODO: open add expense flow. In development.",
                ),
              )
            else
              ..._topExpenses
                  .take(5)
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ExpenseTile(expense: e),
                    ),
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onSurface.withValues(alpha: .60),
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

// Widgets

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
    final cs = Theme.of(context).colorScheme;
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

// Helpers

String _formatCurrency(double value) => "\$${value.toStringAsFixed(2)}";

// Toast notification
void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}
