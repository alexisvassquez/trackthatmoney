import 'package:flutter/material.dart';
import '../lib/ui/theme/colors.dart';
import '../widgets/dashboard_screen.dart';

/// Track That Money
/// lib/ui/dashboard/widgets/bottom_nav.dart

class _BottomBar extends StatelessWidget {
  const _BottomBar();
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (i) {
        /// TODO: wire bottom nav to other screens -> future
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
