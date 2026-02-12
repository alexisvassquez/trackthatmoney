import 'package:flutter/material.dart';
import 'package:track_that_money/ui/theme/colors.dart';

/// Track That Money
/// lib/ui/dashboard/widgets/container_card.dart

class ContainerCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;
  final double radius;

  const ContainerCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.gradient,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.cardColor;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? surface : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(.5),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
