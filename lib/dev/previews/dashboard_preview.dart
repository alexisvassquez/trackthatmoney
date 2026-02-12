import 'package:flutter/material.dart';
import '../preview_shell.dart';
import 'package:track_that_money/ui/dashboard/screens/dashboard_screen.dart';
import 'package:track_that_money/ui/theme/colors.dart';

/// Track That Money
/// lib/dev/preview/dashboard_preview.dart
///
/// Small dev entrypoint to help render DashboardScreen
/// Shrinks dependency surface area (I have a lot of debugging to do)
/// Makes compiling difficult

void main() {
  runApp(
    const PreviewShell(
      title: 'DashboardScreen',
      child: DashboardScreen(),
    ),
  );
}
