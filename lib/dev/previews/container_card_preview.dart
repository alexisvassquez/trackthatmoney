import 'package:flutter/material.dart';
import '../preview_shell.dart';
import '../../ui/dashboard/widgets/container_card.dart';

/// Track That Money
/// lib/dev/previews/container_card_preview.dart

void main() {
  runApp(
    const PreviewShell(
      title: 'ContainerCard Preview',
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ContainerCard(
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ContainerCard'),
              SizedBox(height: 8),
              Text('If you can read this, the goblins have lost.'),
            ],
          ),
        ),
      ),
    ),
  );
}
