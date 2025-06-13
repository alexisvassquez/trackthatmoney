import 'package:flutter_test/flutter_test.dart';
import 'package:uuid/uuid.dart';
import 'package:track_that_money/models/journal_entry.dart';
import 'dart:convert';

void main() {
    group('JournalEntry Mood + Savings Input', () {
        test('Valid mood tag and savings entry', () {
            final entry = JournalEntry(
                moodTag: 'motivated',
                categoryReference: 'Career',
                timestamp: DateTime.utc(2025, 6, 13, 12, 0),
                savingsAmount: 15.75,
            );

            expect(entry.moodTag, 'motivated');
            expect(entry.categoryReference, 'Career');
            expect(entry.timestamp.toIso8601String(), '2025-06-13T12:00:00.000Z')'
            expect(entry.savingsAmount, 15.75);
            expect(entry.id, isNotNull);
            expect(entry.id.length, greaterThanOrEqualTo(36));
        });

        test('Serializes and deserializes correctly', () {
            final entry = JournalEntry(
                id: const Uuid().v4(),
                moodTag: 'grateful',
                categoryReference: 'Groceries',
                timestamp: DateTime.parse('2025-06-13T14:30:00.000Z'),
                savingsAmount: 7.00,
            );

            final json = entry.toJson();
            final fromJson = JournalEntry.fromJson(json);

            expect(fromJson.id, entry.id);
            expect(fromJson.moodTag, 'grateful');
            expect(fromJson.categoryReference, 'Groceries');
            expect(fromJson.timestamp, DateTime.parse('2025-06-13T14:30:00.000Z'));
            expect(fromJson.savingsAmount, 7.00);
        });

        test('Auto-generates UUID if none is provided', () {
            final entry = JournalEntry(
                moodTag: 'focused',
                categoryReference: 'Housing',
                timestamp: DateTime.now(),
                savingsAmount: 20.00,
            );

        expect(entry.id, isNotEmpty);
        expect(entry.id.length, greaterThanOrEqualTo(36));
        expect(entry.moodTag, isNotEmpty);
    });
)
