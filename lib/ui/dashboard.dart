/// track_that_money
/// lib/ui/dashboard.dart

import 'package:flutter/material.dart';
import '../models/user.dart';

class DashboardPage extends StatelessWidget {
  final User user;

  const DashboardPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(title: Text('Profile')),
            ListTile(title: Text('Export Data')),
            ListTile(title: Text('Settings')),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Track That Money 💸',
                      style: TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.w600,
                      ), 
                    ),
                    SizedBox(height: 2),  // subtle spacing
                    Text(
                      'An Expense Tracking App To Know Why You\'re Broke',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.black87,  // slightly toned down
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting + Mood
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Greetings, ${user.name}! 👋',
                  style: const TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Mood': 🤑 motivated",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Affirmation
            const Card(
              child: Padding(
                padding: EdgeInsets.all(14.0),
                child: Text(
                  "💫 Celebrate tiny wins; they pave the way for big change.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Top Expenses',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            // Recent Expenses List
            Expanded(
              child: ListView(
                children: const [
                  ListTile(title: Text('Groceries - \$42.67')),
                  ListTile(title: Text('Bus Pass - \$5.00')),
                  ListTile(title: Text('Spotify - \$11.99')),
                  ListTile(title: Text('Google Fi - \$55.36')),
                  ListTile(title: Text('Work Clothes - \$13.98')),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Tigger Juniper2.0 tip modal
        },
        child: const Icon(Icons.psychology_alt),
        tooltip: 'Ask Juniper2.0 👀',
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          // TODO: Handle nav routing
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Data'),
          BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Piggybank'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
