import 'package:flutter/material.dart';

/// Track That Money
/// lib/ui/theme/colors.dart
/// Brand palette
/// "Warm & Hopeful" — NO RED ANYWHERE :)
/// No red for a fintech app is a design choice by the
/// developer.

class AppColors {
  AppColors._(); // non-instantiable

  // ----- Core brand -----
  static const sage = Color(0xFF7AAE82); // primary — growth, calm, safety
  static const peach = Color(0xFFF2A98A); // warmth, self-kindness, reward
  static const honeyGold = Color(0xFFD4A843); // achievement, celebration
  static const seafoam = Color(0xFF7EB5A6); // reflection, calm, flow

  // ----- Neutrals & backgrounds -----
  static const cream = Color(0xFFFAF6F0); // app background
  static const sand = Color(0xFFE8D9BC); // card surfaces
  static const warmLinen = Color(0xFFE8DFC8); // borders, dividers
  static const deepMoss = Color(0xFF2C3828); // primary text

  // ----- Supporting tones -----
  static const sageDark = Color(0xFF4E7A55); // pressed states, deep accents
  static const sageLight = Color(
    0xFFB8D9BC,
  ); // light accents, success backgrounds
  static const sageMist = Color(0xFFEBF4EC); // very light surface tint
  static const peachLight = Color(0xFFFADDD3); // soft peach backgrounds
  static const amber = Color(0xFFE8A020); // caution — warm, not punitive

  // ----- Text -----
  static const inkWarm = Color(
    0xFF2C3828,
  ); // same as deepMoss — alias for clarity
  static const inkMuted = Color(0xFF6B6560); // secondary text, hints

  // ----- Semantic tokens -----
  static const brandPrimary = sage;
  static const brandSecondary = peach;
  static const brandAccent = honeyGold;
  static const success = sageLight;
  static const caution = amber; // no red for errors or negative balances

  // ----- Utility -----
  /// Apply alpha to any color. e.g. o(sage, 80)
  static Color o(Color c, int a) => c.withAlpha(a);

  // ----- ColorScheme -----
  static final ColorScheme lightScheme =
      ColorScheme.fromSeed(
        seedColor: sage,
        brightness: Brightness.light,
      ).copyWith(
        primary: sage,
        onPrimary: Colors.white,
        primaryContainer: sageMist,

        secondary: peach,
        onSecondary: Colors.white,
        secondaryContainer: peachLight,

        tertiary: honeyGold,
        onTertiary: Colors.white,

        surface: cream,
        onSurface: deepMoss,
        surfaceContainerHighest: sand,

        error: amber,
        onError: Colors.white,

        outline: warmLinen,
        outlineVariant: warmLinen.withValues(alpha: .6),
        surfaceTint: sage,
      );
}
