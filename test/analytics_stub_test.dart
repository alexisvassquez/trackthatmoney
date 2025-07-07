/// track_that_money
/// test/analytics_stub_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:track_that_money/models/analytics_stub.dart';

void main() {
    group('SpendingInsight', () {
        test('fromJson and toJson round trip', () {
            final jsonMap = {
                'category': 'Household',
                'amount': 22.75,
                'mood': 'motivated',
                'timestamp': '2025-07-06T12:00:00Z',
            };

            final insight = SpendingInsight.fromJson(jsonMap);
            final jsonBack = insight.toJson();

            expect(jsonBack['category'], 'Household');
            expect(jsonBack['amount'], 22.75);
            expect(jsonBack['mood'], 'motivated');
            expect(jsonBack['timestamp'], '2025-07-06T12:00:00.000Z');
        });

        test('parseInsights parses a JSON array correctly', () {
            final jsonString = '''
                [
                    {
                        "category": "Transportation",
                        "amount": 5.00,
                        "mood": "tired",
                        "timestamp": "2025-07-05T09:30:00Z"
                    },
                    {
                        "category": "Subscription",
                        "amount": 20.00,
                        "mood": "hopeful",
                        "timestamp": "2025-07-06T18:30:00Z"     
                    }
                ]
            ''';

            final insights = parseInsights(jsonString);

            expect(insights.length, 2);
            expect(insights[0].category, 'Transportation');
            expect(insights[1].mood, 'hopeful');
        });
    });
}
