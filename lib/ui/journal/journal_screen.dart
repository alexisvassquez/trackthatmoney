import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/colors.dart';
import '../../state/user_providers.dart';
import '../../services/expense_api.dart';
import 'journal_form.dart';

/// Track That Money
/// lib/ui/journal/journal_screen.dart
/// Journal screen widget, connects to dashboard
/// Fed data from journal_form.dart
/// Includes header, write entry, labels, bottom sheet, entry tile
/// mood tags, expanded

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Journal',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.deepMoss,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your money. Your feelings. No judgment.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.inkMuted,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Write entry button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _openJournalForm(context, ref),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Write today\'s entry'),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Divider
            Divider(color: AppColors.warmLinen, height: 1),

            const SizedBox(height: 16),

            // Past entries label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Past entries',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.deepMoss,
                  letterSpacing: 0.06,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Entries list
            Expanded(
              child: ref
                  .watch(journalProvider)
                  .when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "Couldn't load journal - is the backend running?",
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.inkMuted),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    data: (entries) {
                      if (entries.isEmpty) {
                        return _EmptyJournal();
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 96),
                        itemCount: entries.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) => _JournalEntryTile(
                          entry: entries[i],
                          onDelete: () async {
                            await ExpenseApi.deleteJournalEntry(
                              entries[i]['id'] as String,
                            );
                            ref.invalidate(journalProvider);
                          },
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  void _openJournalForm(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          _JournalBottomSheet(onSaved: () => ref.invalidate(journalProvider)),
    );
  }
}

// Journal bottom sheet
class _JournalBottomSheet extends StatelessWidget {
  final VoidCallback onSaved;
  const _JournalBottomSheet({required this.onSaved});

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
          children: [
            // Handle
            Center(
              child: Container(
                width: 20,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: AppColors.warmLinen,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            JournalForm(
              onSubmit: (content, moodTag) async {
                await ExpenseApi.addJournalEntry(
                  content: content,
                  moodTag: moodTag,
                );
                onSaved();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Entry tile
class _JournalEntryTile extends StatefulWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onDelete;

  const _JournalEntryTile({required this.entry, required this.onDelete});

  @override
  State<_JournalEntryTile> createState() => _JournalEntryTileState();
}

class _JournalEntryTileState extends State<_JournalEntryTile> {
  bool _expanded = false;

  String _formatDate(String isoDate) {
    final dt = DateTime.parse(isoDate).toLocal();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun,'
          'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.entry;
    final moodTag = e['mood_tag'] as String?;
    final juniperResponse = e['juniper_response'] as String?;
    final ceilingTriggered = e['ceiling_triggered'] as String?;
    final content = e['content'] as String? ?? '';
    final createdAt = e['created_at'] as String? ?? '';

    return Dismissible(
      key: Key(e['id'] as String),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.amber,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => widget.onDelete(),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.sand,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.warmLinen),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Top row (date / mood / chevron)
              Row(
                children: [
                  Text(
                    _formatDate(createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (moodTag != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.peachLight,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(
                        color: AppColors.peach.withValues(alpha: .4),
                      ),
                    ),
                    child: Text(
                      moodTag,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.sageDark,
                      ),
                    ),
                  ),
                const Spacer(),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0, 
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Content preview
            Text(
              _expanded ? content : (
                content.length > 80 ? '${content.substring(0, 80)}...' 
                : content
              ),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.deepMoss,
                height: 1.5,
              ),
            ),

            // Expanded section
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(), 
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Divider(color: AppColors.warmLinen, height: 1),
                  const SizedBox(height: 12),

                  // Juniper response
                  if (juniperResponse != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: ceilingTriggered != null ? AppColors.peachLight : AppColors.sageMist,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ceilingTriggered != null ? AppColors.peach.withValues(alpha: .4) : AppColors.sage.withValues(alpha: .3),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            ceilingTriggered != null ? Icons.favorite_outline : Icons.eco_rounded,
                            size: 14,
                            color: AppColors.sageDark,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              juniperResponse,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.deepMoss,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Resources redirect hint (todo)
                ],
              ), )
            ],
          )
        )
      ))
  }
}
