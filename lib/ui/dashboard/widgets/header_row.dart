import 'package:flutter/material.dart';
import '../../models/model_mapping.dart';

/// Track That Money
/// lib/ui/dashboard/widgets/header_row.dart
/// Greeting, mood, affirmation in header row widget

class HeaderRow extends StatelessWidget {
  final String userName;
  final Mood mood;
  final String affirmation;
  const HeaderRow({
    super.key,
    required this.userName,
    required this.mood,
    required this.affirmation,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 680;

    final left = Expanded(
      flex: 3,
      child: _MoodCard(userName: userName, mood: mood),
    );

    final right = Expanded(flex: 4, child: _AffirmationCard(text: affirmation));

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [left, const SizedBox(width: 12), right],
      );
    }
    return Column(children: [left, const SizedBox(width: 12), right]);
  }
}

class _MoodCard extends StatelessWidget {
  final String userName;
  final Mood mood;
  const _MoodCard({required this.userName, required this.mood});

  @override
  Widget build(BuildContext context) {
    final h = DateTime.now().hour;
    final greeting = h < 12
        ? 'Good morning'
        : (h < 17 ? 'Good afternoon' : 'Good evening');
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: .55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $userName! 👋',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _MoodChip(mood: mood),
        ],
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final Mood mood;
  const _MoodChip({required this.mood});

  @override
  Widget build(BuildContext context) {
    final chipBg = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Row(
      children: [
        Text(
          'Mood today: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: chipBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Text(mood.emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(mood.hint, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}

class _AffirmationCard extends StatelessWidget {
  final String text;
  const _AffirmationCard({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
          theme.colorScheme.primaryContainer.withValues(alpha: .45),
          theme.colorScheme.tertiaryContainer.withValues(alpha: .35),
        ],
      ),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: .55)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.format_quote_rounded, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Affirmation',
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(text, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    ));
  }
}
