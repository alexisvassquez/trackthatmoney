// lib/ui/journal/journal_form.dart

import 'package:flutter/material.dart';

class JournalForm extends StatefulWidget {
    final Function(String content, String? moodTag) onSubmit;

    const JournalForm({Key? key, required this.onSubmit}) : super(key: key);

    @override
    _JournalFormState createState() => _JournalFormState();
}

class _JournalFormState extends State<JournalForm> {
    final _controller = TextEditingController();
    String? _selectedMood;

    final List<String> _moodOptions = [
        'anxious',
        'hopeful',
        'frustrated',
        'calm',
        'excited',
        'overwhelmed',
    ];

    void _handleSubmit() {
        final text = _controller.text.trim();
        if (text.isEmpty) return;

        widget.onSubmit(text, _selectedMood);
        _controller.clear();
        setState(() => _selectedMood = null);
    }

    @override
    Widget build(BuildContext context) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const Text("How are you feeling about your finances today?"),
                const Sized(height: 10),
                TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Write your journal entry...',
                    ),
                    maxLines: 4,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                    value: _selectedMood,
                    items: _moodOptions
                        .map((mood) => DropdownMenuItem(
                                value: mood,
                                child: Text(mood)
                            ))
                        .toList(),
                    onChanged: (value) {
                        setState(() => _selectedMood = value);
                    },
                    decoration: const InputDecoration(
                        labelText: 'Mood Tag',
                        border: OutlineInputBorder(),
                    ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: _handleSubmit,
                    child: const Text('Save Entry'),
                ),
            ],
        );
    }
}  
