import 'package:flutter/material.dart';

/// Track That Money
/// lib/ui/models/dashboard_tile_vm.dart
/// Dashboard tile model for InsightsGrid

class DashboardTileVM {
  final String title;
  final String value;
  final String subtext;
  final IconData icon;

  const DashboardTileVM({
    required this.title,
    required this.value,
    required this.subtext,
    required this.icon,
  });
}
