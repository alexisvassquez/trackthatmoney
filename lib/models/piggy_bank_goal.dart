/// lib/models/piggy_bank_goal.dart

import 'package:uuid/uuid.dart';

class PiggyBankGoal {
    final String id;
    final String title;
    final double targetAmount;
    double currentAmount;
    final DateTime createdAt;
    DateTime? deadline;
    String? emojiIcon;
    List<double>? milestones;
 
    PiggyBankGoal({
        String? id,
        required this.title,
        required this.targetAmount,
        this.currentAmount = 0.0,
        DateTime? createdAt,
        this.deadline,
        this.emojiIcon,
        this.milestones,
    }) : id = id ?? const Uuid().v4(),
         createdAt = createdAt ?? DateTime.now();

    /// Get progress as a percentage (0.0 - 1.0)
    double get progress {
        if (targetAmount <= 0) return 0.0;
        return (currentAmount / targetAmount).clamp(0.0, 1.0);
    }

    /// Check if savings goal is complete
    bool get isCompleted => currentAmount >= targetAmount;

    /// Return the next milestone (check if there are any)
    double? get nextMilestone {
        if (milestones == null || milestones!.isEmpty) return null;
        milestones!.sort();
        return milestones!.firstWhere(
            (m) => currentAmount < m,
            orElse: () => targetAmount,
        );
    }

    /// Update the current savings amount
    void addSavings(double amount) {
        if (amount <= 0) return;
        currentAmount += amount;
        if (currentAmount > targetAmount) {
            currentAmount = targetAmount;
        }
    }

    /// Convert to JSON
    Map<String, dynamic> toJson() => {
            'id': id,
            'title': title,
            'targetAmount': targetAmount,
            'currentAmount': currentAmount,
            'createdAt': createdAt.toIso8601String(),
            'deadline': deadline?.toIso8601String(),
            'emojiIcon': emojiIcon,
            'milestones': milestones,
        };

    // Create from JSON
    factory PiggyBankGoal.fromJson(Map<String, dynamic> json) {
        return PiggyBankGoal(
            id: json['id'],
            title: json['title'],
            targetAmount: (json['targetAmount'] as num).toDouble(),
            currentAmount: (json['currentAmount'] as num).toDouble(),
            createdAt: DateTime.parse(json['createdAt']),
            deadline:
                json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
            emojiIcon: json['emojiIcon'],
            milestones: (json['milestones'] as List<dynamic>?)
                ?.map((e) => (e as num).toDouble())
                .toList(),
        );
    }
}
