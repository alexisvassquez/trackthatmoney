// lib/ui/journal/journal_screen.dart

import 'package:flutter/material.dart';
import '../../models/journal_entry.dart';
import 'journal_form.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({Key? key}) : super(key: key);
  
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final List<JournalEntry> _entries = [];
  
  void _addJournalEntry(String content, String? moodTag, [String? category]) {
    final newEntry = JournalEntry(
      content: content,
      moodTag: moodTag,
      categoryReference: category,
    );
    
    setState(() {
      _entries.insert(0, newEntry);   // recent entries show at the top
      });
    }
    
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Journal')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              JournalForm(onSubmit: _addJournalEntry),
              const SizedBox(height: 16),
              Expanded(
                child: _entries.isEmpty
                ? const Center(child: Text("No journal entries yet."))
                : ListView.builder(
                  itemCount: _entries.length,
                  itemBuilder: (context, index) {
                    final entry = _entries[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(entry.content),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (entry.moodTag != null)
                            Text('Mood: ${entry.moodTag}'),
                            if (entry.categoryReference != null)
                            Text('Category: ${entry.categoryReference}'),
                            Text(
                              'Date: ${entry.timestamp.toLocal().toIso8601String()}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            ],
                          ),
                        ),
                      );
                      },
                    ),
                    