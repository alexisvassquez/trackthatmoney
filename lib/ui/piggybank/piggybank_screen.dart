import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../theme/colors.dart';

/// Track That Money
/// lib/ui/piggybank/piggybank_screen.dart
/// Piggybank savings screen
/// User stores a budgeting/savings goal which triggers a celebratory
/// animation at a certain threshold.
/// Piggybank / confetti animation

class PiggyBankScreen extends ConsumerStatefulWidget {
  const PiggyBankScreen({super.key});

  @override
  ConsumerState<PiggyBankScreen> createState() => _PiggyBankScreenState();
}

class _PiggyBankScreenState extends ConsumerState<PiggyBankScreen>
    with TickerProviderStateMixin {
  // Piggybank animation controller
  late AnimationController _piggyController;

  // Confetti animation controller
  late AnimationController _confettiController;

  // Currently selected goal index
  int _selectedGoal = 0;

  // First contribution animation
  final Set<int> _firstContributionDone = {};

  // Hardcoded goals for now
  // will wire to backend in next phase (todo)
  final List<Map<String, dynamic>> _goals = [
    {
      'name': 'Move to London',
      'icon': Icons.flight_takeoff_outlined,
      'saved': 1500.00,
      'target': 10000.00,
    },
    {
      'name': 'Emergency fund',
      'icon': Icons.shield_outlined,
      'saved': 450.00,
      'target': 1000.00,
    },
    {
      'name': 'New car',
      'icon': Icons.car_rental_outlined,
      'saved': 2300.00,
      'target': 5000.00,
    },
    {
      'name': 'Charli XCX tickets',
      'icon': Icons.music_note_outlined,
      'saved': 18.00,
      'target': 150.00,
    },
  ];

  @override
  void initState() {
    super.initState();

    _piggyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void dispose() {
    _piggyController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Map<String, dynamic> get _currentGoal => _goals[_selectedGoal];

  double get _progress =>
      (_currentGoal['saved'] as double) / (_currentGoal['target'] as double);

  void _onAddSavings() {
    _showAddSavingsSheet();
  }

  void _triggerCelebration(double pct, int goalIndex) {
    // Always bounce the piggy
    _piggyController.forward(from: 0);

    final isFirst = !_firstContributionDone.contains(goalIndex);

    // confetti bursts at first contribution and grows bigger w/ longer
    // duration as user reaches thresholds
    if (isFirst) {
      _firstContributionDone.add(goalIndex);
      _confettiController.duration = const Duration(seconds: 1);
      _confettiController.forward(from: 0);
    } else if (pct >= 100) {
      _confettiController.duration = const Duration(seconds: 4);
      _confettiController.forward(from: 0);
    } else if (pct >= 75) {
      _confettiController.duration = const Duration(seconds: 2);
      _confettiController.forward(from: 0);
    } else if (pct >= 50) {
      _confettiController.duration = const Duration(seconds: 2);
      _confettiController.forward(from: 0);
    } else if (pct >= 25) {
      _confettiController.duration = const Duration(seconds: 2);
      _confettiController.forward(from: 0);
    }
    // between 0-25% after first contribution: piggy bounces, no confetti
    // surprise effect
  }

  void _showAddSavingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddSavingsSheet(
        goalName: _currentGoal['name'] as String,
        onSave: (amount) {
          setState(() {
            _goals[_selectedGoal]['saved'] =
                (_currentGoal['saved'] as double) + amount;
          });
          final newPct =
              ((_goals[_selectedGoal]['saved'] as double) /
                      (_goals[_selectedGoal]['target'] as double) *
                      100)
                  .clamp(0.0, 100.0);
          _triggerCelebration(newPct, _selectedGoal);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goal = _currentGoal;
    final saved = goal['saved'] as double;
    final target = goal['target'] as double;
    final pct = (_progress * 100).clamp(0.0, 100.0);

    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cream,
        selectedItemColor: AppColors.sageDark,
        unselectedItemColor: AppColors.inkMuted,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/journal');
            case 3:
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("TODO: route index=$index. In development"),
                ),
              );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: "Journal",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: "Data",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings_outlined),
            activeIcon: Icon(Icons.savings),
            label: "Piggybank",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "You",
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              decoration: BoxDecoration(
                color: AppColors.goldLight,
                border: Border(
                  bottom: BorderSide(color: const Color(0xFFE8D4A0)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.savings_outlined,
                        size: 16,
                        color: AppColors.sageDark,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Your goals',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.sageDark,
                          letterSpacing: 0.08,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Piggybank',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.deepMoss,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Every bit counts. Event \$1 saved is a win.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.inkMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Piggybank Hero
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Confetti overlay + piggybank
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Confetti - plays on milestone
                        Transform.scale(
                          scale: _confettiScale(pct),
                          child: Lottie.asset(
                            'assets/animations/confetti.json',
                            controller: _confettiController,
                            width: 300,
                            height: 300,
                            onLoaded: (comp) {
                              _confettiController.duration = comp.duration;
                            },
                          ),
                        ),

                        // Piggybank
                        GestureDetector(
                          onTap: _onAddSavings,
                          child: Lottie.asset(
                            'assets/animations/piggybank.json',
                            controller: _piggyController,
                            width: 200,
                            height: 200,
                            onLoaded: (comp) {
                              _piggyController.duration = comp.duration;
                            },
                          ),
                        ),
                      ],
                    ),

                    // Goal name
                    Text(
                      goal['name'] as String,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.deepMoss,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // Encouragement line
                    Text(
                      _encouragement(pct),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.inkMuted,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    // Progress card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.warmLinen),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '\$${saved.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.deepMoss,
                                    ),
                              ),
                              Text(
                                'of \$${target.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppColors.inkMuted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(99),
                            child: LinearProgressIndicator(
                              value: _progress.clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: AppColors.warmLinen,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.honeyGold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              '${pct.toStringAsFixed(0)}% complete',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.inkMuted),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Add savings button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _onAddSavings,
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add to savings'),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Goal selector row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All goals',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: AppColors.deepMoss,
                                letterSpacing: 0.06,
                              ),
                        ),
                        GestureDetector(
                          onTap: () => _showNewGoalSheet(),
                          child: Text(
                            'New goal',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.sageDark,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Goal tiles
                    ..._goals.asMap().entries.map((entry) {
                      final i = entry.key;
                      final g = entry.value;
                      final gPct =
                          ((g['saved'] as double) /
                                  (g['target'] as double) *
                                  100)
                              .clamp(0.0, 100.0);
                      final isSelected = i == _selectedGoal;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedGoal = i),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.goldLight
                                : AppColors.sand,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFFE8D4A0)
                                  : AppColors.warmLinen,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      color: AppColors.goldLight,
                                      borderRadius: BorderRadius.circular(9),
                                      border: Border.all(
                                        color: const Color(0xFFE8D4A0),
                                      ),
                                    ),
                                    child: Icon(
                                      g['icon'] as IconData,
                                      size: 16,
                                      color: AppColors.honeyGold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      g['name'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.deepMoss,
                                          ),
                                    ),
                                  ),
                                  Text(
                                    '\$${(g['saved'] as double).toStringAsFixed(0)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.deepMoss,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: LinearProgressIndicator(
                                  value:
                                      (g['saved'] as double) /
                                      (g['target'] as double),
                                  minHeight: 5,
                                  backgroundColor: AppColors.warmLinen,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.honeyGold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${gPct.toStringAsFixed(0)}%',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: AppColors.inkMuted),
                                  ),
                                  Text(
                                    'of \$${(g['target'] as double).toStringAsFixed(0)}',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(color: AppColors.inkMuted),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // New goal dashed button
                    GestureDetector(
                      onTap: _showNewGoalSheet,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: AppColors.warmLinen,
                            width: 1.5,
                            strokeAlign: BorderSide.strokeAlignInside,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add,
                              size: 18,
                              color: AppColors.inkMuted,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Add a new goal',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.inkMuted),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _confettiScale(double pct) {
    if (pct >= 100) return 2.0;
    if (pct >= 75) return 1.5;
    if (pct >= 50) return 1.2;
    if (pct >= 25) return 1.1;
    return 0.8; // first contribution - small welcome burst
  }

  String _encouragement(double pct) {
    if (pct >= 100) return "You did it! Goal complete!";
    if (pct >= 75) return "So close - you've got this!";
    if (pct >= 50) return "Halfway there. Keep going!";
    if (pct >= 25) return "Great start. Every bit adds up.";
    return "Every bit counts. Even \$1 saved is a win.";
  }

  void _showNewGoalSheet() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("TODO: New goal form. In development.")),
    );
  }
}

// Add Savings Sheet
class _AddSavingsSheet extends StatefulWidget {
  final String goalName;
  final Function(double) onSave;

  const _AddSavingsSheet({required this.goalName, required this.onSave});

  @override
  State<_AddSavingsSheet> createState() => _AddSavingsSheetState();
}

class _AddSavingsSheetState extends State<_AddSavingsSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_controller.text.trim());
    if (amount == null || amount <= 0) return;
    widget.onSave(amount);
    Navigator.of(context).pop();
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 31),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              'Add to savings',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.deepMoss),
            ),
            const SizedBox(height: 4),
            Text(
              widget.goalName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.inkMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '\$ ',
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
