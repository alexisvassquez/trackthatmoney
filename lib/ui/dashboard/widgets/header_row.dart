import 'package: flutter/material.dart';
import '..lib/ui/theme/colors.dart';

/// Track That Money
/// Greeting + Mood | Affirmation
/// lib/ui/dashboard/widgets/header_row.dart

class _HeaderRow extends StatelessWidget {
  final String userName;
  final Mood mood;
  final String affirmation;
  const _HeaderRow({required this.userName, required this.mood, required this.affirmation});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 680;

    final left = Expanded(
      flex: 3,
      child: _ContainerCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, ${user.name}! 👋',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            _MoodRow(mood: '🤑 motivated'),
          ],
        ),
      ),
    );

    final right = Expanded(
      flex: 4,
      child: _AffirmationCard(text: '💫 Celebrate tiny wins; they pave the way for big change.'),
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          left, 
          SizedBox(width: 12), 
          right,
        ],
      );
    }
    return Column(
      children: [
        left,
        SizedBox(width: 12),
        right,
      ],
    );
  }
}

String _greetingText(String name) {
  final h = DateTime.now().hour,
  final s = h < 12 ? 'Good morning' : (h < 17 ? 'Good afternoon' : 'Good evening');
  return '$s, $name';
}

class MoodRow extends StatelessWidget {
  final Mood mood;
  const _MoodRow({required this.mood});

  @override
  Widget build(BuildContext context) {
    final chipBg = Theme.of(context).colorScheme.surfaceVariant;
    return Row(
      children: [
        Text(
          'Mood today: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: chipBg, borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              mood.emoji,
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(width: 8),
            Text(
              mood.hint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
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
    return _ContainerCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          theme.colorScheme.primaryContainer.withOpacity(.45),
          theme.colorScheme.tertiaryContainer.withOpacity(.35),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.format_quote_rounded, size: 28),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Affirmation',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
                ),
                SizedBox(height: 6),
                Text(text, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
