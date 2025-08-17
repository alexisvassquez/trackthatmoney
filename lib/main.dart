/// track_that_money
/// lib/main.dart

import 'package:flutter/material.dart';
import 'models/user.dart';
import 'ui/dashboard.dart';

void main() {  
  runApp(const TrackThatMoneyApp());
}

final colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: const Color(0xFF479761),         // money green
  onPrimary: Colors.white,
  secondary:  const Color(0xFFF48FB1),      // piggy bank pink
  onSecondary: Colors.white,
  tertiary: const Color(0xFFCEBC81),        // soft gold
  onTertiary: Colors.black,
  surface: const Color(0xFFFAFAFA),         // light background
  onSurface: Colors.black87,
  background: const Color(0xFFF5F5F5),      // neutral grey background
  onBackground: Colors.black,
  error: const Color(0xFFFFB74D),           // amber, no red
  onError: Colors.black,
);

class TrackThatMoneyApp extends StatelessWidget {
  const TrackThatMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User(name: 'Lexy');    // Changeable later to user name

    return MaterialApp(
      title: 'Track That Money',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: DashboardPage(user: user),
    );
  }
}
