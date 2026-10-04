import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth/sign_in_screen.dart';
import 'dashboard/screens/dashboard_screen.dart';
import 'theme/theme.dart';
import 'journal/journal_screen.dart';
import 'piggybank/piggybank_screen.dart';

/// Track That Money
/// lib/ui/app.dart

/// Tells GoRouter to re-run its redirect whenever
/// the user signs in / out
class _AuthRefresh extends ChangeNotifier {
  late final StreamSubscription<User?> _sub;

  _AuthRefresh(Stream<User?> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// Created once, so nav state survives rebuilds
final _router = GoRouter(
  refreshListenable: _AuthRefresh(FirebaseAuth.instance.authStateChanges()),
  redirect: (context, state) {
    final signedIn = FirebaseAuth.instance.currentUser != null;
    final onSignIn = state.matchedLocation == '/sign-in';

    if (!signedIn && !onSignIn) return '/sign-in';
    if (signedIn && onSignIn) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/sign-in', builder: (_, _) => const SignInScreen()),
    GoRoute(path: '/', builder: (_, _) => const DashboardScreen()),
    GoRoute(path: '/journal', builder: (_, _) => const JournalScreen()),
    GoRoute(path: '/piggybank', builder: (_, _) => const PiggyBankScreen()),
  ],
);

class TrackThatMoneyApp extends StatelessWidget {
  const TrackThatMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Track That Money',
      routerConfig: _router,
      theme: buildAppTheme(),
    );
  }
}
