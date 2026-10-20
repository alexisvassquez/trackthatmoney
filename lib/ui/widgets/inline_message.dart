import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Track That Money
/// lib/ui/widgets/inline_message.dart
/// Inline message box shown inside screens and sheets.
/// Caution uses amber, never red. Notices use sage.
/// liveRegion lets TalkBack announce the message when it appears
/// for accessibility purposes.

class InlineMessage extends StatelessWidget {
  final String message;
  final bool isCaution;

  const InlineMessage({
    super.key,
    required this.message,
    this.isCaution = true,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isCaution ? AppColors.amber : AppColors.sage;

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isCaution
              ? AppColors.amber.withValues(alpha: .1)
              : AppColors.sageMist,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accent.withValues(alpha: .5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isCaution ? Icons.info_outline : Icons.check_circle_outline,
              color: isCaution ? AppColors.amber : AppColors.sageDark,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.deepMoss),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
