import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dashboard/screens/dashboard_screen.dart';
import 'theme/theme.dart';
import 'journal/journal_screen.dart';

/// Track That Money
/// lib/ui/app.dart

class TrackThatMoneyApp extends StatelessWidget {
  const TrackThatMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const DashboardScreen()),
        GoRoute(path: '/journal', builder: (_, _) => const JournalScreen()),
      ],
    );

    return MaterialApp.router(
      title: 'Track That Money',
      routerConfig: router,
      theme: buildAppTheme(),
    );
  }
}
