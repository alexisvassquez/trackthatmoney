import 'package:uuid/uuid.dart';

class JournalEntry {
    final String id;
    final DateTime timestamp;
    final String content;
    final String? moodTag;    // "anxious", "hopeful", etc.
    final String? categoryReference;   // link to budget category
    final List<JournalEntry> _entries = [];

    JournalEntry({
        String? id,
        required this.date,
        required this.content,
        this.moodTag,
        this.categoryReference,
    }) : id = id ?? const Uuid().v4(),
         timestamp = DateTime.now();
}

    // Convert to JSON for storage
    Map<String, dynamic> toJson() {
        return {
            'id': id,
            'date': date.toIso8601String(),
            'content': content,
            'moodTag': moodTag,
            'categoryReference': categoryReference,
        };
    }

    // Factory constructor for reading from JSON
    factory JournalEntry.fromJson(Map<String, dynamic> json) {
        return JournalEntry(
            id: json['id'],
            date: DateTime.parse(json['date']),
            content: json['content'],
            moodTag: json['moodTag'],
            categoryReference: json['categoryReference'],
        );
    }
}
