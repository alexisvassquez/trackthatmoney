/// track_that_money
/// lib/main.dart

import 'package:flutter/material.dart';
import 'models/user.dart';
import 'ui/dashboard.dart';

void main() {  
  runApp(const TrackThatMoneyApp());
}

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
