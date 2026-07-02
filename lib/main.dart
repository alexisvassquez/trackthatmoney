import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/app.dart';

// Track That Money
// main.dart
// TrackThatMoneyApp lives in app.dart

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TrackThatMoneyApp()));
}
