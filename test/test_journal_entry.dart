import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

// JournalEntry model test functon

void main() {
    final entry = JournalEntry(
        date: DateTime.now(),
        content: "Feeling optimistic after reviewing my financial progress.",
        moodTag: "hopeful",
        categoryReference: "Savings",
    );

    // Serialize to JSON
    final jsonStr = jsonEncode(entry.toJson());
    print("Serialized JSON:\n$jsonStr");

    // Deserialize from JSON
    final decoded = jsonDecode(jsonStr);
    final newEntry = JournalEntry.fromJson(decoded);
    print(\nDeserialized Entry:");
    print("ID: ${newEntry.id}");
    print("Date: ${newEntry.id}");
    print("Content: ${newEntry.content}");
    print("Mood Tag: ${newEntry.moodTag}");
    print("Category: ${newEntry.categoryReference}");
}

