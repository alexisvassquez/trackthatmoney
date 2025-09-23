import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/user_prefs.dart';

/// Track That Money
/// lib/state/user_providers.dart

// Current user name (null if not set)
final userNameProvider = FutureProvider<String?>((ref) async {
  return UserPrefs.getUserName();
});

// Invalidates the reader so UI updates
final setUserNameProvider = Provider<(String name) => Future<void>((ref) {
  return (String name) async {
    await UserPrefs.setUserName(name);
    ref.invalidate(userNameProvider);
  };
});
