import 'lib/models/goal.dart';

void main() {
    Goal lexyGoal = Goal(
        id: 'goal001',
        title: 'Emergency Fund',
        targetAmount: 100.0,
        milestones: [1, 5, 10, 25, 50, 75, 100],
    );

    lexyGoal.addContribution(5);
    print("Saved: \$${lexyGoal.savedAmount}");
    print("Progress: ${(lexyGoal.progressPercent * 100).toStringAsFixed(2)}%");
    print("Completed: ${lexyGoal.isCompleted}");
}
