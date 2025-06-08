import 'dart:convert';
import 'lib/models/goal.dart';

void main() {
    // Create a new goal
    Goal lexyGoal = Goal(
        id: 'goal001',
        title: 'Emergency Fund',
        targetAmount: 100.0,
        savedAmount: 25.0,
    );

    // Add another contribution
    lexyGoal.addContribution(10.0);

    // Convert to JSON
    Map<String, dynamic> jsonGoal = lexyGoal.toJson();
    String encoded = jsonEncode(jsonGoal);
    print("Serialized JSON:");
    print(encoded);

    // Convert back from JSON
    Goal decodedGoal = Goal.fromJson(jsonDecode(encoded));
    print("\nDeserialized Goal:");
    print("Title: ${decodedGoal.targetAmount}");
    print("Target: \$${decodedGoal.targetAmount}");
    print("Saved: \$${decodedGoal.savedAmount}");
    print("Progress: ${(decodedGoal.progressPercent * 100).toStringAsFixed(2)}%");
    print("Completed: ${decodedGoal.isCompleted}");

    // Print completed milestones
    List<double> completed = decodedGoal.getCompletedMilestones();
    print("Completed Milestones: ${completed.map((m) => "\$${m.toStringAsFixed(2)}").join(', ')}");
}
