import 'package:flutter/material.dart';
import '../lib/ui/theme/colors.dart';
import '../screens/dashboard_screen.dart';

/// Track That Money
/// lib/ui/dashboard/widgets/wallet_frame.dart

class WalletFrame extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool showStitches;
  final bool showTab;

  const WalletFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 28,
    this.showStitches = true,
    this.showTab = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                cs.primaryContainer.withOpacity(.65),
                cs.secondaryContainer.withOpacity(.45),
              ],
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: cs.outlineVariant.withOpacity(.6),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withOpacity(.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(radius - 1),
            child: CustomPaint(
              painter: showStitches
                ? _StitchesPainter(
                    color: cs.outline.withOpacity(.55),
                    radius: radius - 8,
                  )
                : null,
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
        if (showTab)
          Positioned(
            top: -12,
            right: 24,
            child: _WalletTab(),
          ),
      ],
    );
  }
}

class _WalletTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      height: 26,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(.16),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.wallet_rounded, size: 16, color: Colors.white),
    );
  }
}

class _StitchesPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double inset;
  final double dash;
  final double gap;

  _StitchesPainter({
    required this.color,
    required this.radius,
    this.inset = 10,
    this.dash = 6,
    this.gap = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(inset, inset, size.width - inset * 2, size.height - inset * 2),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + dash);
        canvas.drawPath(segment, paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StitchesPainter old) =>
      old.color != color || old.radius != radius || old.inset != inset || old.dash != dash || old.gap != gap;
}
