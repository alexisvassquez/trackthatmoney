import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
            // 1. Dashboard Header
            const _DashboardHeader(),
            const SizedBox(height: 12),

            // 2. Affirmation (dynamic)
            ref
                .watch(affirmationProvider)
                .when(
                  loading: () => const _AffirmationPill(text: "✨ ..."),
                  error: (_, _) => const _AffirmationPill(
                    text: "✨ Awareness is progress. Tiny wins count.",
                  ),
                  data: (affirmation) =>
                      _AffirmationPill(text: "✨ $affirmation"),
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
                              ref
                                  .watch(summaryProvider)
                                  .when(
                                    loading: () => const Text(
                                      "...",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    error: (_, _) => const Text("\$0.00"),
                                    data: (summary) => Text(
                                      _formatCurrency(
                                        (summary['total_spent'] as num)
                                            .toDouble(),
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
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

                          // Budget Summary
                          Text(
                            "Budget: ${_formatCurrency(_budgetThisMonth)}",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: ref
                                .watch(summaryProvider)
                                .when(
                                  loading: () => const SizedBox(height: 6),
                                  error: (_, _) => const SizedBox(height: 6),
                                  data: (summary) {
                                    final spent =
                                        (summary['total_spent'] as num)
                                            .toDouble();
                                    final pct = (_budgetThisMonth > 0
                                        ? (spent / _budgetThisMonth).clamp(
                                            0.0,
                                            1.0,
                                          )
                                        : 0.0);
                                    return LinearProgressIndicator(
                                      value: pct,
                                      minHeight: 6,
                                      backgroundColor: AppColors.warmLinen,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        pct > 0.9
                                            ? AppColors.amber
                                            : AppColors.sage,
                                      ),
                                    );
                                  },
                                ),
                          ),
                          const SizedBox(height: 6),
                          ref
                              .watch(summaryProvider)
                              .maybeWhen(
                                data: (summary) {
                                  final spent = (summary['total_spent'] as num)
                                      .toDouble();
                                  final pct = (_budgetThisMonth > 0
                                      ? (spent / _budgetThisMonth * 100).clamp(
                                          0,
                                          100,
                                        )
                                      : 0);
                                  // Progress bar
                                  return Text(
                                    "${pct.toStringAsFixed(0)}% of budget used",
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: AppColors.inkMuted),
                                  );
                                },
                                orElse: () => const SizedBox.shrink(),
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
                                category: e['category'] as String? ?? '',
                                moodTag: e['mood_tag'] as String?,
                                isEssential:
                                    (e['is_essential'] as int? ?? 0) == 1,
                                isSubscription:
                                    (e['is_subscription'] as int? ?? 0) == 1,
                                note: e['note'] as String?,
                                juniperMessage: e['juniper_message'] as String?,
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
      // Navigates to Journal Screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _navIndex = index);
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/journal');
            default:
              _toast(context, "TODO: route index=$index. In development.");
          }
        },
        backgroundColor: cs.surface,
        selectedItemColor: cs.primary,
        unselectedItemColor: cs.onSurface.withValues(alpha: .60),
        
        // Bottom nav icons
        // Shows outlined and filled when selected
        // Currently, only Journal is functioning.
        items: const [
          // Home screen
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), 
            label: "Home",
          ),
          // Journal screen
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: "Journal",
          ),
          // Data analytics screen (in dev)
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined), 
            activeIcon: Icon(Icons.bar_chart),
            label: "Data",
          ),
          // Piggy bank screen (in dev)
          BottomNavigationBarItem(
            icon: Icon(Icons.savings_outlined),
            activeIcon: Icon(Icons.savings),
            label: "Piggybank",
          ),
          // User account screen (in dev)
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "You",
          ),
        ],
      ),
    );
  }
}

// Widgets
// Dashboard header / greeting
class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.sageDark,
            letterSpacing: 0.08,
          ),
        ),
        const SizedBox(height: 2),
        // hardcoded name for now, will change to user name as consumer widget
        Text(
          'Alexis',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.deepMoss,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'Your money. No judgment.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.inkMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}

// Affirmation pill
class _AffirmationPill extends StatelessWidget {
  final String text;
  const _AffirmationPill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.peachLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.peach.withValues(alpha: .5)),
            ),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.deepMoss,
              ),
            ),
          ),
        ),
      ],
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

// Expense row fields
class _ExpenseRow {
  final String label;
  final double amount;
  final IconData icon;
  final String category;
  final String? moodTag;
  final bool isEssential;
  final bool isSubscription;
  final String? note;
  final String? juniperMessage;

  const _ExpenseRow({
    required this.label,
    required this.amount,
    required this.icon,
    required this.category,
    this.moodTag,
    this.isEssential = false,
    this.isSubscription = false,
    this.note,
    this.juniperMessage,
  });
}

// Expense tiles
class _ExpenseTile extends StatefulWidget {
  final _ExpenseRow expense;
  const _ExpenseTile({required this.expense});

  @override
  State<_ExpenseTile> createState() => _ExpenseTileState();
}

class _ExpenseTileState extends State<_ExpenseTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final e = widget.expense;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.sand,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.warmLinen),
        ),
        child: Column(
          children: [
            // Collapsed row
            Row(
              children: [
                Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: AppColors.sageMist,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(e.icon, color: AppColors.sageDark, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.label,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.deepMoss,
                        ),
                      ),
                      Text(
                        e.category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatCurrency(e.amount),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.deepMoss,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),

            // Expanded detail
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _expanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Divider(color: AppColors.warmLinen, height: 1),
                  const SizedBox(height: 12),

                  // Mood tag + essential row
                  Row(
                    children: [
                      if (e.moodTag != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.peachLight,
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                              color: AppColors.peach.withValues(alpha: .4),
                            ),
                          ),
                          child: Text(
                            e.moodTag!,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: AppColors.sageDark),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: e.isEssential
                              ? AppColors.sageMist
                              : AppColors.sand,
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: AppColors.warmLinen),
                        ),
                        child: Text(
                          e.isEssential ? 'Essential' : 'Discretionary',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: e.isEssential
                                    ? AppColors.sageDark
                                    : AppColors.inkMuted,
                              ),
                        ),
                      ),
                    ],
                  ),

                  // Subscription chip - recurring payments
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: e.isSubscription
                          ? AppColors.sageMist
                          : AppColors.sand,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: AppColors.warmLinen),
                    ),
                    child: Text(
                      e.isSubscription ? 'Recurring' : 'One-time',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: e.isSubscription
                            ? AppColors.sageDark
                            : AppColors.inkMuted,
                      ),
                    ),
                  ),

                  // Note
                  if (e.note != null && e.note!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      e.note!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.inkMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  // Juniper message
                  if (e.juniperMessage != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.peachLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.peach.withValues(alpha: .3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.eco_rounded,
                            size: 14,
                            color: AppColors.sageDark,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              e.juniperMessage!,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.deepMoss),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
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
