import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Track That Money
// main.dart
// TrackThatMoneyApp lives in app.dart

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TrackThatMoneyApp()));
}
