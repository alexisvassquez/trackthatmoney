import 'package:flutter/material.dart';
import 'package:track_that_money/ui/theme/colors.dart';

/// Track That Money
/// lib/dev/preview_shell.dart
///
/// A dedicated preview shell
/// One place to control theming and wrappers
/// Consistent environment for every widget preview

class PreviewShell extends StatefulWidget {
  final String title;
  final Widget child;

  const PreviewShell({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  State<PreviewShell> createState() => _PreviewShellState();
}

class _PreviewShellState extends State<PreviewShell> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: widget.title,
      theme: ThemeData(
        colorScheme: AppColors.lightScheme,    // from colors.dart
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: AppColors.darkScheme,
        useMaterial3: true,
      ),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: Icon(_darkMode ? Icons.dark_mode : Icons.light_mode),
              onPressed: () {
                setState(() {
                  _darkMode = !_darkMode;
                });
              },
            )
          ],
        ),
        body: SafeArea(
          child: widget.child,
        ),
      ),
    );
  }
}
