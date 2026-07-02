import 'package:flutter/material.dart';

/// Track That Money
/// lib/ui/dashboard/widgets/bottom_nav.dart

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (i) {
        /// wire bottom nav to other screens (todo)
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Data'),
        NavigationDestination(icon: Icon(Icons.savings), label: 'Piggybank'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
