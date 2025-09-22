import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme/colors.dart';
import 'dashboard/screens/dashboard_screen.dart';
import 'journal/journal_screen.dart';

/// Track That Money
/// lib/ui/app.dart

class TrackThatMoneyApp extends StatelessWidget {
  const TrackThatMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const DashboardScreen()),
        GoRoute(path: '/journal', builder: (_, __) => const JournalScreen()),
      ],
    );

    return MaterialApp.router(
      title: 'Track That Money',
      routerConfig: _router,
      theme: buildAppTheme(),
    );
  }
}
