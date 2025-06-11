// lib/models/income.dart

import 'package:uuid/uuid.dart';

class IncomeEntry {
    final String id;
    final String source; // e.g., "Job", "Freelance", "Gift"
    final double amount;
    final DateTime receivedDate;
    final List<String> tags;

    static const _uuid = Uuid();

    IncomeEntry({
        String? id,
        required this.source,
        required this.amount,
        required this.receivedDate,
        this.tags = const [],
    }) : id = id ?? _uuid.v4();

    Map<String, dynamic> toJson() => {
            'id': id,
            'source': source,
            'amount': amount,
            'receivedDate': receivedDate.toIso8601String(),
            'tags': tags,
        };

    factory IncomeEntry.fromJson(Map<String, dynamic> json) => IncomeEntry(
            id: json['id'],
            source: json['source'],
            amount: json['amount'],
            receivedDate: DateTime.parse(json['receivedDate']),
            tags: List<String>.from(json['tags']),
        );
}
