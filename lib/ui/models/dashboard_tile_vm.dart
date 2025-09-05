import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/model_mapping.dart';
import '../models/expense_tile_vm.dart';
import '../lib/ui/dashboard/data/mock_data_expenses.dart';

/// Track That Money
/// lib/ui/models/dashboard_tile_vm.dart
/// UI Dashboard View Model

final List<ExpenseTileVM> top5ExpenseTiles =
  top5DomainExpenses.map(mapExpenseToTileVM).toList(growable: false);
