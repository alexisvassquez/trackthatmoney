import 'package:flutter/material.dart';

/// Track That Money
/// lib/ui/theme/colors.dart
/// Brand palette
/// "Warm & Hopeful" — NO RED ANYWHERE :)
/// No red for a fintech app is a design choice by the
/// developer.
/// Warm, non-punitive tones
/// Richer palette (Nov 2026): deeper, more saturated core tones,
/// forest-green text, softer off-white background.

class AppColors {
  AppColors._(); // non-instantiable

  // ----- Core brand -----
  static const sage = Color(0xFF5E9A6A); // primary — growth, calm, safety
  static const peach = Color(0xFFE9946F); // warmth, self-kindness, reward
  static const honeyGold = Color(0xFFC99A2E); // achievement, celebration
  static const seafoam = Color(0xFF5A9E8E); // reflection, calm, flow

  // ----- Neutrals & backgrounds -----
  static const cream = Color(0xFFF6F0E6); // app background — soft off-white
  static const sand = Color(0xFFE5D4B3); // card surfaces
  static const warmLinen = Color(0xFFE8DFC8); // borders, dividers
  static const deepMoss = Color(0xFF243B2B); // primary text — forest green

  // ----- Supporting tones -----
  static const sageDark = Color(
    0xFF3D6A49,
  ); // buttons, pressed states, deep accents
  static const sageLight = Color(
    0xFFB8D9BC,
  ); // light accents, success backgrounds
  static const sageMist = Color(0xFFEBF4EC); // very light surface tint
  static const peachLight = Color(0xFFFADDD3); // soft peach backgrounds
  static const amber = Color(0xFFE8A020); // caution — warm, not punitive
  static const goldLight = Color(0xFFF5E9C8); // piggybank progress bar
  static const card = Color(0xFFEDE4CC); // piggybank progress tile

  // ----- Text -----
  static const inkWarm = deepMoss; // alias for clarity
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

  // ---- Mood accent colors ----
  // TODO: richer pass + collision fixes with the shared mood list
  // (tired = stressed, grateful = hopeful, overwhelmed = frustrated; tired uses caution amber)
  // Each mood has a light background tint & border/text color
  static const calmTint = Color(0xFFF0F8F2);
  static const calmAccent = Color(0xFF7AAE82); // sage

  static const stressedTint = Color(0xFFFDF6EC);
  static const stressedAccent = Color(0xFFE8A020); // amber

  static const hopefulTint = Color(0xFFEEF7F5);
  static const hopefulAccent = Color(0xFF7EB5A6); // seafoam

  static const frustratedTint = Color(0xFFF7F0EC);
  static const frustratedAccent = Color(0xFFC4846A); // terracotta

  static const proudTint = Color(0xFFF5F0FA);
  static const proudAccent = Color(0xFF9B8EC4); // lavender

  static const anxiousTint = Color(0xFFEDF0F7);
  static const anxiousAccent = Color(0xFF7B8EC4); // muted periwinkle

  static const tiredTint = Color(0xFFFDF6EC);
  static const tiredAccent = Color(0xFFE8A020); // amber

  static const gratefulTint = Color(0xFFEEF7F5);
  static const gratefulAccent = Color(0xFF7EB5A6); // seafoam

  static const excitedTint = Color(0xFFF0EBF8);
  static const excitedAccent = Color(0xFF7B4DB8); // deep purple

  static const overwhelmedTint = Color(0xFFF7F0EC);
  static const overwhelmedAccent = Color(0xFFC4846A); // terracotta

  static const celebratoryTint = Color(0xFFF5E9C8);
  static const celebratoryAccent = Color(0xFFD4A843); // gold

  // Returns [tint, accent] for a given mood tag.
  // Tint = background color, accent = border/icon color
  static List<Color> moodColors(String? mood) {
    switch (mood?.toLowerCase()) {
      case 'calm':
        return [calmTint, calmAccent];
      case 'stressed':
        return [stressedTint, stressedAccent];
      case 'hopeful':
        return [hopefulTint, hopefulAccent];
      case 'frustrated':
        return [frustratedTint, frustratedAccent];
      case 'proud':
        return [proudTint, proudAccent];
      case 'anxious':
        return [anxiousTint, anxiousAccent];
      case 'tired':
        return [tiredTint, tiredAccent];
      case 'grateful':
        return [gratefulTint, gratefulAccent];
      case 'excited':
        return [excitedTint, excitedAccent];
      case 'overwhelmed':
        return [overwhelmedTint, overwhelmedAccent];
      case 'celebratory':
        return [celebratoryTint, celebratoryAccent];
      case 'planned':
        return [calmTint, calmAccent];
      case 'joy':
        return [excitedTint, excitedAccent];
      default:
        return [sand, warmLinen];
    }
  }

  // ----- ColorScheme -----
  static final ColorScheme lightScheme =
      ColorScheme.fromSeed(
        seedColor: sage,
        brightness: Brightness.light,
      ).copyWith(
        primary: sage,
        onPrimary: deepMoss,
        primaryContainer: sageMist,

        secondary: peach,
        onSecondary: deepMoss,
        secondaryContainer: peachLight,

        tertiary: honeyGold,
        onTertiary: deepMoss,

        surface: cream,
        onSurface: deepMoss,
        surfaceContainerHighest: sand,

        error: amber,
        onError: deepMoss,

        outline: warmLinen,
        outlineVariant: warmLinen.withValues(alpha: .6),
        surfaceTint: sage,
      );
}
