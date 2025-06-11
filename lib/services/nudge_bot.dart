// lib/services/nudge_bot.dart

import 'budget_summary.dart';

class NudgeBot {
    final BudgetSummary summary;

    NudgeBot(this.summary);

    List<String> getSuggestions() {
        final nudges = <String>[];

        for (var item in summary.generateFullSummary()) {
            final usage = item['percentUsed'] as double;
            final remaining = item['remaining'] as double;
            final category = item['category'];

            if (usage < 0.25) {
                nudges.add(
                    "💡 You've only used ${(usage * 100).toStringAsFixed(1)}% of your $category budget. Consider moving some of that to savings?",
                );
            } else if (remaining < 20) {
                nudges.add(
                    "❕ Your $category budget is down to \$${remaining.toStringAsFixed(2)}. You may want to ease up for the rest of the month. 🥴",
                );
            }
        }

        return nudges;
    }
}
