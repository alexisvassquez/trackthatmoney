import 'package:flutter/material.dart';
import '../models/user.dart';
import '../ui/theme/colors.dart';

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
      body: Column(
        children: [
          SizedBox(height: 8),
     
          // Greeting + Mood
          Expanded(
            child: WalletFrame(
              child: ListView(
                children: [
                  Text('Hi, ${user.name}! 👋',
                  style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text('Create change through code.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.black54)),
                ],
              ),
            ),
            const Text(
              "Mood': 🤑 motivated",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 8),

        // Affirmation tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
          color: AppColors.softGold.withOpacity(.25),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.softGold.withOpacity(.5)),
        ),
        child: Text(
          "💫 Celebrate tiny wins; they pave the way for big change.",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ),
    ),

    // Recent Expenses List
    const Text(
      'Top Expenses',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    ),
    SizedBox(height: 8),
    Expanded(
      child: WalletFrame(
      child: ListView(
      children: [
        ListTile(title: Text('Groceries - \$42.67')),
        ListTile(title: Text('Bus Pass - \$5.00')),
        ListTile(title: Text('Spotify - \$11.99')),
        ListTile(title: Text('Google Fi - \$55.36')),
        ListTile(title: Text('Work Clothes - \$13.98')),
      ],
    ),
  ),
),
],
),
floatingActionButton: FloatingActionButton(
  onPressed: () { // TODO: Tigger Juniper2.0 tip modal },
  child: const Icon(Icons.psychology_alt),
  tooltip: 'Ask Juniper2.0 👀',
),
bottomNavigationBar: BottomNavigationBar(
  currentIndex: 0,
  onTap: (index) { // TODO: Handle nav routing },
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Data'),
    BottomNavigationBarItem(icon: Icon(Icons.savings), label: 'Piggybank'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
  ],
),
),

/// Wallet outer frame (leather + stitching)
class WalletFrame extends StatelessWidget {
  final Widget child;
  const WalletFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFFFAF6EC), Color(0xFFF1E7D3)],    // sand/leather tones
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.leatherBrown.withOpacity(.25), width: 1.2),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, 14)),
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 1)),
        ],
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.leatherBrown.withOpacity(.18), width: 1),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: _StitchOverlay(color: AppColors.leatherBrown.withOpacity(.25))),
            // top "slot" bar
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.leatherBrown.withOpacity(.06),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18), topRight: Radius.circular(18)),
                ),
              ),
            ),
            Padding(padding: const EdgeInsets.all(16), child: child),
          ],
        ),
      ),
    );
  }
}

class _StitchOverlay extends StatelessWidget {
  final Color color;
  const _StitchOverlay({required this.color});

  @override
  Widget build(BuildContext context) => CustomPaint(painter: _StitchPainter(color));
}

class _StitchPainter extends CustomPainter {
  final Color color;
  _StitchPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dash = 6.0, gap = 6.0;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(6, 6, size.width - 12, size.height - 12), const Radius.circular(14));
    final path = Path()..addRRect(rect);
    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        final seg = m.extractPath(d, d + dash);
        canvas.drawPath(seg, paint);
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Sections
class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;
  const _Section({required this.title, required this.child, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const Spacer(),
        if (trailing != null) trailing!,
      ]),
      SizedBox(height: 10),
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 10, offset: const Offset(0, 6))]
        ),
        child: Padding(padding: const EdgeInsets.all(10), child: child),
      ),
    ]);
  }
}

class _TopStatsRow extends StatelessWidget {
  const _TopStatsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _StatCard(
          title: 'Expenses This Week',
          value: '\$80.75',
          subtitle: 'Mon-Sun',
          icon: Icons.trending_down_rounded,
          bgFrom: AppColors.leafGreen, bgTo: Colors.white,
        )),
        SizedBox(width: 12),
        Expanded(child: _StatCard(
          title: 'Subscriptions',
          value: '\$47.33',
          subtitle: 'Fatigue: caution',
          icon: Icons.repeat_rounded,
          bgFrom: AppColors.calmBlue, bgTo: Colors.white,
        )),
      ],
    );
  }
}

class _WalletSlot extends StatelessWidget {
  final String title, note;
  final IconData icon;
  final Color color;
  const _WalletSlot({
    required this.title, required this.icon,
    required this.color, required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: color),
              SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            ]),
            const Spacer(),
            Text(note, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _CardSlotsStrip extends StatelessWidget {
  const _CardSlotsStrip();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Cards in the wallet',
      trailing: TextButton(onPressed: () {}, child: const Text('Manage')),
      child: SizedBox(
        height: 140,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _WalletSlot(title: 'Budget', icon: Icons.account_balance_wallet_rounded,
              color: AppColors.brandPrimary, note: 'On track'),
            _WalletSlot(title: 'Bills', icon: Icons.receipt_long_rounded,
              color: AppColors.deepNavy, note: 'Due in 2w'),
            _WalletSlot(title: 'Subs', icon: Icons.movie_rounded,
              color: AppColors.calmBlue, note: '4 vendors'),
            _WalletSlot(title: 'Piggy', icon: Icons.savings_rounded,
              color: AppColors.piggyBankPink, note: '43% to goal'),
          ],
        ),
      ),
    );
  }
}

class _GoalsPocket extends StatelessWidget {
  const _GoalsPocket();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Piggy bank pocket',
      child: Wrap(
        spacing: 22, runSpacing: 16,
        children: [
          _GoalRing(percent: .42, label: 'Move to London'),
          _GoalRing(percent: .18, label: 'Emergency Fund'),
          _GoalRing(percent: .66, label: 'Charli xcx Tickets'),
        ],
      ),
    );
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();

  @override
  Widget build(BuildContext context) {
    return _Section(
      title: 'Recent activity',
      trailing: TextButton(onPressed: () {}, child: const Text('See all')),
      child: Column(
        children: [
          _ExpenseTile(title: 'Groceries', note: 'Publix', amount: 44.55, dot: AppColors.moneyGreen),
          Divider(height: 1),
          _ExpenseTile(title: 'Dining', note: 'Bolay', amount: 26.05, dot: AppColors.cocoaBrown),
          Divider(height: 1),
          _ExpenseTile(title: 'Phone', note: 'Auto-pay', amount: 56.05, dot: AppColors.softGold),
        ],
      ),
    );
  }
}

/// Bits
class _StatCard extends StatefulWidget {
  final String title, value, subtitle;
  final IconData icon;
  final Color bgFrom, bgTo;
  const _StatCard({
    required this.title, required this.value, required this.subtitle,
    required this.icon, required this.bgFrom, required this.bgTo,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.brandPrimary;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 140),
        transform: Matrix4.translationValues(0, _hovered ? -2.0 : 0, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [widget.bgFrom.withOpacity(.22), widget.bgTo]),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(_hovered ? .12 : .06),
            blurRadius: _hovered ? 18 : 10, offset: const Offset(0, 10))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                color: c.withOpacity(.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.icon, color: c),
            ),
            SizedBox(width: 12),

            Expanded(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title, 
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: 2),
          Text(
            widget.subtitle, 
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
      Text(
        widget.value, 
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(letterSpacing: -0.5),
        ),
      ],
    ),
  ),
}
}

class _GoalRing extends StatelessWidget {
  final double percent;
  final String label;
  const _GoalRing({required this.percent, required this.label});

  @override
  Widget build(BuildContext context) {
    final ring = AppColors.piggyBankPink;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Stack(alignment: Alignment.center, children: [
        SizedBox(
          width: 84, height: 84,
          child: CircularProgressIndicator(
            value: percent.clamp(0, 1),
            strokeWidth: 10,
            backgroundColor: ring.withOpacity(.18),
            valueColor: AlwaysStoppedAnimation<Color>(ring),
          ),
        ),
        Text('${(percent * 100).round()}%', style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
    SizedBox(height: 8),
    SizedBox(width: 120, child: Text(label, maxLines: 2, overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.center)),
  ]);
}
}

class _ExpenseTile extends StatelessWidget {
  final String title, note;
  final double amount;
  final Color dot;
  const _ExpenseTile({
    required this.title, required this.note, 
    required this.amount, required this.dot,
  },
),

@override
Widget build(BuildContext context) {
  return ListTile(
    leading: Container(width: 12, height: 12, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    subtitle: Text(note),
    trailing: Text('\$${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700)),
  );
}
}
