import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../services/expense_api.dart';
import '../../../state/user_providers.dart';
import '../theme/colors.dart';

/// Track That Money
/// lib/ui/piggybank/piggybank_screen.dart
/// Piggybank savings screen
/// User stores a budgeting/savings goal which triggers a celebratory
/// animation at a certain threshold.
/// Piggybank / confetti animation

// Infer icon based on user input
String _inferIcon(String goalName) {
  final name = goalName.toLowerCase();
  if (name.contains('london') ||
      name.contains('travel') ||
      name.contains('trip') ||
      name.contains('flight') ||
      name.contains('vacation') ||
      name.contains('holiday')) {
    return 'flight_takeoff';
  }
  if (name.contains('car') ||
      name.contains('vehicle') ||
      name.contains('truck') ||
      name.contains('auto')) {
    return 'directions_car';
  }
  if (name.contains('vet') ||
      name.contains('pet') ||
      name.contains('dog') ||
      name.contains('cat') ||
      name.contains('animal')) {
    return 'pets';
  }
  if (name.contains('emergency') ||
      name.contains('fund') ||
      name.contains('safety') ||
      name.contains('backup')) {
    return 'shield';
  }
  if (name.contains('home') ||
      name.contains('house') ||
      name.contains('apartment') ||
      name.contains('rent') ||
      name.contains('mortgage')) {
    return 'home';
  }
  if (name.contains('music') ||
      name.contains('concert') ||
      name.contains('ticket') ||
      name.contains('show') ||
      name.contains('festival')) {
    return 'music_note';
  }
  if (name.contains('computer') ||
      name.contains('laptop') ||
      name.contains('raspberry') ||
      name.contains('tech') ||
      name.contains('phone') ||
      name.contains('gadget')) {
    return 'memory';
  }
  if (name.contains('wedding') ||
      name.contains('ring') ||
      name.contains('engagement')) {
    return 'favorite';
  }
  if (name.contains('baby') || 
      name.contains('child') || 
      name.contains('kid')) {
    return 'child_care';
  }
  if (name.contains('gym') ||
      name.contains('fitness') ||
      name.contains('health') ||
      name.contains('medical')) {
    return 'favorite_outline';
  }
  if (name.contains('book') ||
      name.contains('course') ||
      name.contains('class')) {
    return 'school';
  }
  return 'savings'; // default
}

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

  // track selected goal by its id string instead of index
  String? _selectedGoal;

  // first contribution animation
  // track which goals have had their first contribution
  final Set<String> _firstContributionDone = {};

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

  void _triggerCelebration(double pct, String goalId) {
    // Always bounce the piggy
    _piggyController.forward(from: 0);

    final isFirst = !_firstContributionDone.contains(goalId);

    // confetti bursts at first contribution and grows bigger w/ longer
    // duration as user reaches thresholds
    if (isFirst) {
      _firstContributionDone.add(goalId);
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

  void _showAddSavingsSheet(Map<String, dynamic> currentGoal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddSavingsSheet(
        goalName: currentGoal['name'] as String,
        onSave: (amount) async {
          final goalId = currentGoal['id'] as String;
          await ExpenseApi.addToSavings(goalId: goalId, amount: amount);
          ref.invalidate(goalsProvider);
          final newPct =
              (((currentGoal['saved'] as num).toDouble() + amount) /
                      (currentGoal['target'] as num).toDouble() *
                      100)
                  .clamp(0.0, 100.0);
          _triggerCelebration(newPct, goalId);
        },
      ),
    );
  }

  void _showNewGoalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _NewGoalSheet(
        onSave: (name, target, icon) async {
          await ExpenseApi.createGoal(name: name, target: target, icon: icon);
          ref.invalidate(goalsProvider);
        },
      ),
    );
  }

  // Confetti burst scales upwards as the user reaches more milestones
  // and gets closer to the goal
  double _confettiScale(double pct) {
    if (pct >= 100) return 2.0;
    if (pct >= 75) return 1.5;
    if (pct >= 50) return 1.2;
    if (pct >= 25) return 1.1;
    return 0.8; // first contribution - small welcome burst
  }

  // Milestone encouragement messages
  String _encouragement(double pct) {
    if (pct >= 100) return "You did it! Goal complete!";
    if (pct >= 75) return "So close - you've got this!";
    if (pct >= 50) return "Halfway there. Keep going!";
    if (pct >= 25) return "Great start. Every bit adds up.";
    return "Every bit counts. Even \$1 saved is a win.";
  }

  IconData _iconForGoal(String? icon) {
    switch (icon) {
      case 'flight_takeoff':
        return Icons.flight_takeoff_outlined;
      case 'shield':
        return Icons.shield_outlined;
      case 'memory':
        return Icons.memory_outlined;
      case 'music_note':
        return Icons.music_note_outlined;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'pets':
        return Icons.pets_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'favorite':
        return Icons.favorite_outlined;
      default:
        return Icons.savings_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    // watch goals from backend
    final goalsAsync = ref.watch(goalsProvider);

    return goalsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Text("Couldn't load goals - is the backend running"),
        ),
      ),
      data: (goals) {
        // if no goal selected yet, default to primary / first
        if (_selectedGoal == null && goals.isNotEmpty) {
          final primary = goals.firstWhere(
            (g) => (g['is_primary'] as int) == 1,
            orElse: () => goals.first,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _selectedGoal = primary['id'] as String);
            }
          });
        }

        // Current goal
        final currentGoal = goals.isEmpty
            ? null
            : goals.firstWhere(
                (g) => g['id'] == _selectedGoal,
                orElse: () => goals.first,
              );

        final saved = currentGoal != null
            ? (currentGoal['saved'] as num).toDouble()
            : 0.0;
        final target = currentGoal != null
            ? (currentGoal['target'] as num).toDouble()
            : 1.0;
        final pct = (saved / target * 100).clamp(0.0, 100.0);
        final progress = (saved / target).clamp(0.0, 1.0);

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
              } // switch
            }, // onTap
            // Bottom nav
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
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: AppColors.sageDark,
                                  letterSpacing: 0.08,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Piggybank',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
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

                // Body
                // Piggybank Hero
                Expanded(
                  child: goals.isEmpty
                      ? _EmptyGoals(onNewGoal: _showNewGoalSheet)
                      : SingleChildScrollView(
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
                                        _confettiController.duration =
                                            comp.duration;
                                      },
                                    ),
                                  ),

                                  // Piggybank
                                  GestureDetector(
                                    onTap: currentGoal != null
                                        ? () =>
                                              _showAddSavingsSheet(currentGoal)
                                        : null,
                                    child: Lottie.asset(
                                      'assets/animations/piggybank.json',
                                      controller: _piggyController,
                                      width: 200,
                                      height: 200,
                                      onLoaded: (comp) {
                                        _piggyController.duration =
                                            comp.duration;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              // Goal name
                              if (currentGoal != null) ...[
                                Text(
                                  currentGoal['name'] as String,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.deepMoss,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),

                                // Encouragement line
                                Text(
                                  _encouragement(pct),
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
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
                                    border: Border.all(
                                      color: AppColors.warmLinen,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(
                                            '\$${saved.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.deepMoss,
                                                ),
                                          ),
                                          Text(
                                            'of \$${target.toStringAsFixed(2)}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: AppColors.inkMuted,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(99),
                                        child: LinearProgressIndicator(
                                          value: progress.clamp(0.0, 1.0),
                                          minHeight: 8,
                                          backgroundColor: AppColors.warmLinen,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                AppColors.honeyGold,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${pct.toStringAsFixed(0)}% complete',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.inkMuted,
                                              ),
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
                                    onPressed: () =>
                                        _showAddSavingsSheet(currentGoal),
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Add to savings'),
                                  ),
                                ),
                              ],

                              const SizedBox(height: 24),

                              // All goals header
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'All goals',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: AppColors.deepMoss,
                                          letterSpacing: 0.06,
                                        ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _showNewGoalSheet(),
                                    child: Text(
                                      'New goal',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
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
                              ...goals.map((g) {
                                final gId = g['id'] as String;
                                final gSaved = (g['saved'] as num).toDouble();
                                final gTarget = (g['target'] as num).toDouble();
                                final gPct = (gSaved / gTarget * 100).clamp(
                                  0.0,
                                  100.0,
                                );
                                final isSelected = gId == _selectedGoal;

                                // Delete existing goals
                                return Dismissible(
                                  key: Key(gId),
                                  direction: DismissDirection.endToStart,
                                  resizeDuration: null,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(right: 20),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.sageLight,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDismissed: (_) async {
                                    try {
                                      await ExpenseApi.deleteGoal(gId);
                                      ref.invalidate(goalsProvider);
                                      // if deleted goal was selected, reset selection
                                      if (_selectedGoal == gId) {
                                        setState(() => _selectedGoal = null);
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Could not delete goal.',
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _selectedGoal = gId),
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
                                                  borderRadius:
                                                      BorderRadius.circular(9),
                                                  border: Border.all(
                                                    color: const Color(
                                                      0xFFE8D4A0,
                                                    ),
                                                  ),
                                                ),
                                                child: Icon(
                                                  _iconForGoal(
                                                    g['icon'] as String?,
                                                  ),
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            AppColors.deepMoss,
                                                      ),
                                                ),
                                              ),

                                              // Star for primary
                                              GestureDetector(
                                                onTap: () async {
                                                  await ExpenseApi.setPrimaryGoal(
                                                    gId,
                                                  );
                                                  ref.invalidate(goalsProvider);
                                                },
                                                child: Icon(
                                                  (g['is_primary'] as int? ??
                                                              0) ==
                                                          1
                                                      ? Icons.star_rounded
                                                      : Icons
                                                            .star_outline_rounded,
                                                  size: 18,
                                                  color:
                                                      (g['is_primary']
                                                                  as int? ??
                                                              0) ==
                                                          1
                                                      ? AppColors.honeyGold
                                                      : AppColors.inkMuted,
                                                ),
                                              ),

                                              // Completion state for goals that have reached 100%
                                              if (gPct >= 100)
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 6,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: AppColors.sageMist,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          99,
                                                        ),
                                                    border: Border.all(
                                                      color: AppColors.sage
                                                          .withValues(
                                                            alpha: .4,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Completed! 🎉',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall
                                                        ?.copyWith(
                                                          color: AppColors
                                                              .sageDark,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              const SizedBox(width: 8),

                                              Text(
                                                '\$${gSaved.toStringAsFixed(0)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppColors.deepMoss,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),

                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              99,
                                            ),
                                            child: LinearProgressIndicator(
                                              value: gSaved / gTarget,
                                              minHeight: 5,
                                              backgroundColor:
                                                  AppColors.warmLinen,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
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
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: AppColors.inkMuted,
                                                    ),
                                              ),
                                              Text(
                                                'of \$${gTarget.toStringAsFixed(0)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: AppColors.inkMuted,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.inkMuted,
                                            ),
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
      }, // data:
    ); // goalsAsync.when()
  } // build ()
} // _PiggyBankScreenState

// Empty State
class _EmptyGoals extends StatelessWidget {
  final VoidCallback onNewGoal;
  const _EmptyGoals({required this.onNewGoal});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.savings_outlined, size: 48, color: AppColors.warmLinen),
            const SizedBox(height: 16),
            Text(
              'No goals yet',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.deepMoss),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first savings goal and start celebrating every step.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.inkMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onNewGoal,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create a goal'),
            ),
          ],
        ),
      ),
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

// New Goal Sheet
class _NewGoalSheet extends StatefulWidget {
  final Function(String name, double target, String icon) onSave;
  const _NewGoalSheet({required this.onSave});

  @override
  State<_NewGoalSheet> createState() => _NewGoalSheetState();
}

class _NewGoalSheetState extends State<_NewGoalSheet> {
  final _nameController = TextEditingController();
  final _targetController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final target = double.tryParse(_targetController.text.trim());
    if (name.isEmpty || target == null || target <= 0) return;
    widget.onSave(name, target, _inferIcon(name));
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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
              'New goal',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: AppColors.deepMoss),
            ),
            const SizedBox(height: 4),
            Text(
              'What are you saving for?',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.inkMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Goal name',
                hintText: 'e.g., Emergency fund',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _targetController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Target amount',
                prefixText: '\$ ',
              ),
              onSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Create goal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
