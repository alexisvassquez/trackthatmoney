import 'package:flutter/material.dart';
import '..lib/ui/theme/colors.dart';

/// Track That Money
/// lib/ui/dashboard/dashboard_screen.dart

class DashboardPage extends StatelessWidget {
  final DashboardData data;
  const DashboardPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              sliver: SliverToBoxAdapter(
                child: _HeaderRow(
                  userName: data.userName,
                  mood: data.mood,
                  affirmation: data.affirmation,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              sliver: SliverToBoxAdapter(
                child: _InsightsGrid(insights: data.insights),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'My Top Expenses',
                  actionLabel: 'View all',
                  onAction: data.onViewAllExpenses,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 96),
              sliver: SliverList.separated(
                itemCount: data.topExpenses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) => _ExpenseTile(expense: data.topExpenses[i]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: data.onOpenChatbot,
        icon: const Icon(Icons.psychology_alt),
        label: const Text('Ask Juniper2.0 👀'),
      ),
      bottomNavigationBar: const _BottomBar(
        currentIndex: 0,
        onTap: (index) {  // TODO: Handle nav routing },
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
