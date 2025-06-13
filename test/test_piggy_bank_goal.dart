import 'package:test/test.dart';
import 'package:track_that_money/models/piggy_bank_goal.dart';

void main() {
    group("PiggyBankGoal", () {
        test("initializes correctly with Lexy's goals", () {
            final goal = PiggyBankGoal(
                title: "Build Raspberry Pi 5 Mini PC",
                targetAmount: 400.0,
                currentAmount: 5.0,
            );

            expect(goal.id, isNotEmpty);
            expect(goal.title, "Build Raspberry Pi 5 Mini PC");
            expect(goal.targetAmount, 400.0);
            expect(goal.currentAmount, 5.0);
            expect(goal.progress, closeTo(0.0125, 0.001));
            expect(goal.isCompleted, isFalse);
            expect(goal.createdAt, isA<DateTime>());
        });

        test("adds savings for Move to London and caps at target", () {
            final goal = PiggyBankGoal(
                title: "Move to London",
                targetAmount: 6000.0,
            );

            goal.addSavings(1000.0);
            expect(goal.currentAmount, 1000.0);
            expect(goal.progress, closeTo(0.166, 0.01));
            expect(goal.isCompleted, isFalse);

            goal.addSavings(6000.0);
            expect(goal.currentAmount, 6000.0);
            expect(goal.isCompleted, isTrue);
        });

        test("nextMilestone for Emergency Fund returns next checkpoint", () {
            final goal = PiggyBankGoal(
                title: "Emergency Fund",
                targetAmount: 1000.0,
                milestones: [250.0, 500.0, 750.0],
            );

            goal.addSavings(300.0);
            expect(goal.nextMilestone, 500.0);

            goal.addSavings(300.0);
            expect(goal.nextMilestone, 750.0);
        });

        test("serializes and deserializes correctly for Charli xcx tickets", () {
            final goal = PiggyBankGoal(
                title: "Charli xcx Tickets",
                targetAmount: 350.0,
                currentAmount: 100.0,
                emojiIcon: '🍏',
                milestones: [150.0, 250.0, 350.0],
            );

            final json = goal.toJson();
            final fromJson = PiggyBankGoal.fromJson(json);

            expect(fromJson.title, "Charli xcx Tickets");
            expect(fromJson.targetAmount, 350.0);
            expect(fromJson.currentAmount, 100.0);
            expect(fromJson.emojiIcon, '🍏');
            expect(fromJson.milestones, containsAll([150.0, 250.0, 350.0]));
        });
    });
}
