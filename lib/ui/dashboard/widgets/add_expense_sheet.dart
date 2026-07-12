import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/expense_api.dart';
import '../../../state/user_providers.dart';
import '../../theme/colors.dart';

/// Track That Money
/// lib/ui/dashboard/widgets/add_expense_sheet.dart
/// Wires the "Add" button to post an expense
/// Opens a bottom sheet with minimum fields when button is tapped
/// Feeds data into dashboard screen

class AddExpenseSheet extends ConsumerStatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();
  String _category = 'Food';
  String? _moodTag;
  bool _isEssential = false;
  bool _isSubscription = false;
  bool _isLoading = false;
  String? _juniperMessage;

  static const _categories = [
    'Food',
    'Groceries',
    'Transport',
    'Entertainment',
    'Subscriptions',
    'Clothing',
    'Health',
    'Other',
  ];

  static const _moods = [
    'planned',
    'joy',
    'tired',
    'stressed',
    'bored',
    'celebratory',
  ];

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final merchant = _merchantController.text.trim();
    final amountText = _amountController.text.trim();

    if (merchant.isEmpty || amountText.isEmpty) return;

    final amount = double.tryParse(amountText);
    if (amount == null) return;

    setState(() => _isLoading = true);

    try {
      final result = await ExpenseApi.addExpense(
        merchant: merchant,
        category: _category,
        amount: amount,
        isEssential: _isEssential ? 1 : 0,
        isSubscription: _isSubscription ? 1 : 0,
        moodTag: _moodTag,
      );

      setState(() {
        _juniperMessage = result['juniper_message'] as String?;
        _isLoading = false;
      });

      ref.invalidate(expensesProvider);
      ref.invalidate(summaryProvider);

      await Future.delayed(const Duration(seconds: 3));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not save expense: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.warmLinen)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.warmLinen,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),

            // Juniper response — shown after submit
            if (_juniperMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.peachLight,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.peach.withValues(alpha: .4),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.eco_rounded, color: AppColors.sageDark),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _juniperMessage!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.deepMoss,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Form — hidden after submit
            if (_juniperMessage == null) ...[
              Text(
                "Add expense",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),

              // Merchant
              TextField(
                controller: _merchantController,
                decoration: const InputDecoration(
                  labelText: 'Merchant or description',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 12),

              // Amount
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 16),

              // Category chips
              Text("Category", style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories
                    .map(
                      (c) => ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        onSelected: (_) => setState(() => _category = c),
                        selectedColor: AppColors.sageMist,
                        side: BorderSide(
                          color: _category == c
                              ? AppColors.sage
                              : AppColors.warmLinen,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Mood chips
              Text(
                "How are you feeling about this purchase?",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _moods
                    .map(
                      (m) => ChoiceChip(
                        label: Text(m),
                        selected: _moodTag == m,
                        onSelected: (_) =>
                            setState(() => _moodTag = _moodTag == m ? null : m),
                        selectedColor: AppColors.peachLight,
                        side: BorderSide(
                          color: _moodTag == m
                              ? AppColors.peach
                              : AppColors.warmLinen,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Essential toggle
              Row(
                children: [
                  Switch(
                    value: _isEssential,
                    onChanged: (v) => setState(() => _isEssential = v),
                    activeThumbColor: AppColors.sage,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Essential expense",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Subscription toggle
              Row(
                children: [
                  Switch(
                    value: _isSubscription,
                    onChanged: (v) => setState(() => _isSubscription = v),
                    activeThumbColor: AppColors.sage,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Recurring payment",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Save expense"),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
