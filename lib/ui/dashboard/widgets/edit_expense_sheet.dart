import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/expense_api.dart';
import '../../../state/user_providers.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';

/// Track That Money
/// lib/ui/dashboard/widgets/edit_expense_sheet.dart

class EditExpenseSheet extends ConsumerStatefulWidget {
  final Map<String, dynamic> expense;

  const EditExpenseSheet({super.key, required this.expense});

  @override
  ConsumerState<EditExpenseSheet> createState() => _EditExpenseSheetState();
}

class _EditExpenseSheetState extends ConsumerState<EditExpenseSheet> {
  late TextEditingController _merchantController;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late String _category;
  late String? _moodTag;
  late bool _isEssential;
  late bool _isSubscription;
  bool _isLoading = false;

  static const _categories = [
    'Food',
    'Groceries',
    'Transport',
    'Entertainment',
    'Subscriptions',
    'Clothing',
    'Health',
    'Housing',
    'Utilities',
    'Other',
  ];

  static const _moods = [
    'planned',
    'joy',
    'tired',
    'stressed',
    'bored',
    'celebratory',
    'calm',
    'anxious',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-fill all fields from the existing expense
    _merchantController = TextEditingController(
      text: widget.expense['merchant'] as String? ?? '',
    );
    _amountController = TextEditingController(
      text: (widget.expense['amount'] as num?)?.toStringAsFixed(2) ?? '',
    );
    _noteController = TextEditingController(
      text: widget.expense['note'] as String? ?? '',
    );
    _category = widget.expense['category'] as String? ?? 'Other';
    _moodTag = widget.expense['mood_tag'] as String?;
    _isEssential = (widget.expense['is_essential'] as int? ?? 0) == 1;
    _isSubscription = (widget.expense['is_subscription'] as int? ?? 0) == 1;
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final merchant = _merchantController.text.trim();
    final amountText = _amountController.text.trim();
    final note = _noteController.text.trim();

    if (merchant.isEmpty || amountText.isEmpty) return;

    final amount = double.tryParse(amountText);
    if (amount == null) return;

    setState(() => _isLoading = true);

    try {
      await ExpenseApi.updateExpense(
        id: widget.expense['id'] as String,
        merchant: merchant,
        category: _category,
        amount: amount,
        isEssential: _isEssential ? 1 : 0,
        isSubscription: _isSubscription ? 1 : 0,
        moodTag: _moodTag,
        note: note.isEmpty ? null : note,
      );

      ref.invalidate(expensesProvider);
      ref.invalidate(summaryProvider);

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not update expense: $e')));
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
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.lg),
          ),
          border: Border(top: BorderSide(color: AppColors.warmLinen)),
        ),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm + 4,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.warmLinen,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                  ),
                ),
              ),

              Text(
                'Edit expense',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: AppColors.deepMoss),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Merchant
              TextField(
                controller: _merchantController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Merchant or description',
                ),
              ),
              const SizedBox(height: AppSpacing.sm + 4),

              // Amount
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Category chips
              Text(
                'Category',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppColors.deepMoss),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
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
              const SizedBox(height: AppSpacing.md),

              // Mood chips
              Text(
                'How were you feeling?',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: AppColors.deepMoss),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
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
              const SizedBox(height: AppSpacing.md),

              // Note
              TextField(
                controller: _noteController,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  hintText: 'Why did you make this purchase?',
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              // Essential toggle
              Row(
                children: [
                  Switch(
                    value: _isEssential,
                    onChanged: (v) => setState(() => _isEssential = v),
                    activeThumbColor: AppColors.sage,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Essential expense',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ], // Children
              ),

              // Recurring toggle
              Row(
                children: [
                  Switch(
                    value: _isSubscription,
                    onChanged: (v) => setState(() => _isSubscription = v),
                    activeThumbColor: AppColors.sage,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Recurring payment',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ], // Children
              ),
              const SizedBox(height: AppSpacing.lg),

              // Save button
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
                      : const Text('Save changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
