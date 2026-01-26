import 'package:flutter/material.dart';
import '../widgets/wallet_frame.dart';

/// Track That Money
/// lib/ui/dashboard/dashboard_screen.dart
///
/// v0.1 dashboard layout. Includes only:
/// - Header (title + subtitle)
/// - Affirmation (one line)
/// - WalletFrame (with monthly summary)
/// - Top 3-5 expenses
/// Hardcoded placeholders until my wiring is complete

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _navIndex = 0;

  // TODO: replace with real data source. These are hardcoded for a reason.
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

            // 3. Monthly summary (inside WalletFrame)
            WalletFrame(
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
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          "spent",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 4. Top expenses (3-5 of the month)
            _SectionHeader(
              title: "Top expenses",
              actionLabel: "View all",
              onAction: () {
                // TODO: route to full expenses screen
                _toast(context, "TODO: Navigate to full expenses list. In development.");
              },
            ),
            const SizedBox(height: 10),

            if (_topExpenses.isEmpty)
              _EmptyExpensesCard(
                message: "No expenses yet - future you says thanks. 🙂",
                onAdd: () => _toast(context, "TODO: open add expense flow. In development."),
              )
            else
              ..._topExpenses.take(5).map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ExpenseTile(expense: e),
                  )),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (index) {
          setState(() => _navIndex = index);
          _toast(context, "TODO: route index=$index. In development.");
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Data"),
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: "Piggybank"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
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
  Widget build(BuildContext cont) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: cs.secondaryContainer.withOpacity(.55),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outlineVariant.withOpacity(.6)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(
            actionLabel,
            style: TextStyle(
              color: cs.primary,
              fontWeight: FontWeight.w700,
            ),
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
        color: cs.surfaceContainerHighest.withOpacity(.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(.55)),
      ),
      child: Row(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: cs.primaryContainer.withOpacity(.55),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              expense.icon,
              color: cs.onPrimaryContainer,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              expense.label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
          Text(
            _formatCurrency(expense.amount),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _EmptyExpensesCard extends StatelessWidget {
  final String message;
  final VoidCallback onAdd;

  const _EmptyExpensesCard({
    required this.message,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withOpacity(.45),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(.55)),
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
          ElevatedButton(
            onPressed: onAdd,
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}

void _openJuniperAssistant(BuildContext context) {
  // Placeholder until real Juniper2.0 sheet is ready
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scroll) => Container(
        decoration: BoxDecoration(
          color: Theme.of(ctx).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: ListView(
          controller: scroll,
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "Juniper2.0 assistant",
              style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "In development: insights, nudges, and encouragment mode.",
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    ),
  );
}

String _formatCurrency(double value) {
  // Lightweight formatting
  return "\$${value.toStringAsFixed(2)}";
}

void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)))
}
