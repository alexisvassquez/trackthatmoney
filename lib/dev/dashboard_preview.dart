import 'package:flutter/material.dart';
import '../ui/dashboard/dashboard_screen.dart';

/// Track That Money
/// lib/dev/preview/dashboard_preview.dart
///
/// Small dev entrypoint to help render DashboardScreen
/// Shrinks dependency surface area (I have a lot of debugging to do)
/// Makes compiling difficult
void main() {
  runApp(const DashboardPreviewApp());
}

class DashboardPreviewApp extends StatelessWidget {
  const DashboardPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: DashboardScreen(),
        ),
      ),
    );
  }
}
