// lib/utils/budget_export.dart

import '../services/budget_summary.dart';
import 'dart:io';

class BudgetExporter {
    final BudgetSummary summary;
    
    BudgetExporter(this.summary);

    String generateCSV() {
        final buffer = StringBuffer();
        buffer.writeln('Id,Category,Limit,Spent,Remaining,PercentUsed');

        final data = summary.generateFullSummary();

        for (var row in data) {
            final id = row['id'] ?? 'N/A'; //fallback if ID isn't in summary map
            buffer.writeln(
                '$id,${row['category']},${row['limit']},${row['spent']},${row['remaining']},${(row['percentUsed'] * 100).toStringAsFixed(1)}&',
            );
        }

        return buffer.toString();
    }

    void saveToFile(String path) {
        final csv = generateCSV();
        File(path).writeAsStringSync(csv);
        print('📁 CSV saved to $path');
    }
}
