import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// Track That Money
/// lib/ui/journal/journal_form.dart

class JournalForm extends StatefulWidget {
  final Function(String content, String? moodTag) onSubmit;
  const JournalForm({super.key, required this.onSubmit});

  @override
  State<JournalForm> createState() => _JournalFormState();
}

class _JournalFormState extends State<JournalForm> {
  final _controller = TextEditingController();
  String? _selectedMood;
  bool _isSubmitting = false;

  static const _moodOptions = [
    'anxious',
    'hopeful',
    'frustrated',
    'calm',
    'excited',
    'overwhelmed',
    'proud',
    'stressed',
    'grateful',
    'celebratory',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSubmitting = true);
    await widget.onSubmit(text, _selectedMood);
    _controller.clear();
    setState(() {
      _selectedMood = null;
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Prompt
        Text(
          "How are you feeling about your finances today?",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.deepMoss,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "No judgment. Just awareness.",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.inkMuted,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),

        // Text entry
        TextField(
          controller: _controller,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Write your thoughts...',
            hintStyle: TextStyle(color: AppColors.inkMuted),
            filled: true,
            fillColor: AppColors.sand,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.warmLinen),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.sage, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Mood chips
        Text(
          "How would you tag this moment?",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.deepMoss,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _moodOptions.map((mood) => ChoiceChip(
            label: Text(mood), 
            selected: _selectedMood == mood,
            onSelected: (_) => setState(
              () => _selectedMood = _selectedMood == mood ? null : mood,
            ),
            selectedColor: AppColors.peachLight,
            side: BorderSide(
              color: _selectedMood == mood ? AppColors.peach : AppColors.warmLinen,
            ),
            labelStyle: TextStyle(
              color: _selectedMood == mood ? AppColors.deepMoss : AppColors.inkMuted,
              fontWeight: _selectedMood == mood ? FontWeight.w600 : FontWeight.w400,
            ),
          )).toList(),
        ),
        const SizedBox(height: 20),

        // Submit
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _handleSubmit, 
            child: _isSubmitting ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text("Save entry")),
        ),
      ],
    );
  }
}
