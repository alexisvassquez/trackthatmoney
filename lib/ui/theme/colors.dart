import 'package:flutter/material.dart';

/// Track That Money
/// lib/ui/theme/colors.dart
///
/// Brand palette - NO RED ANYWHERE :)

class AppColors {
  // ----- Light theme -----
  // Core brand
  static const moneyGreen      = Color(0xFF479761);
  static const piggyBankPink   = Color(0xFFFFA3C5);
  static const softGold        = Color(0xFFCEBC81);
  static const neutralGrey     = Color(0xFF9E9E9E);
  static const amber           = Color(0xFFFFB74D);

  // Blues
  static const calmBlue        = Color(0xFF4F7CAC);  // calm, trustworthy
  static const deepNavy        = Color(0xFF1F3B4D);  // for text/icons on light mode

  // Browns (wallet leather vibes)
  static const leatherBrown    = Color(0xFF6D4C41);
  static const cocoaBrown      = Color(0xFF8D6E63);
  static const sand            = Color(0xFFEDE3D1);  // light leather lining

  // Greens (shades + tints)
  static const forestGreen     = Color(0xFF2E7D32);  // deep accent color
  static const leafGreen       = Color(0xFF66BB6A);  // mid accent
  static const mintGreen       = Color(0xFFA5D6A7);  // light accent for calm, encouragement, and trustworthiness
  static const mistGreen       = Color(0xFFE6F3EA);  // very light background

  // Greys (UI)
  static const ink             = Color(0xFF1E1E1E);
  static const graphite        = Color(0xFF444444);
  static const cloud           = Color(0xFFF7F7F8);

  // Semantic tokens (use in widgets)
  static const brandPrimary    = moneyGreen;
  static const brandSecondary  = piggyBankPink;
  static const success         = mintGreen;
  static const caution         = amber;    // no red for errors or negative balances
  static const info            = calmBlue;

  // Opacities
  static Color o(Color c, int a) => c.withAlpha(a);    // ex; o(moneyGreen, 32)

  // ----- Dark theme -----
  // Dark mode foundation
  static const darkBg          = Color(0xFF0F1412);    // deep, slightly green-black
  static const darkSurface     = Color(0xFF151B18);    // lifted surface
  static const darkCard        = Color(0xFF1B2320);    // card / container
  static const darkOutline     = Color(0xFF2A3530);    // subtle borders

  // Slightly softened pink for dark mode (keeps piggy vibe, less neon)
  static const piggyBankPinkDark = Color(0xFFE98FAF);

  // ----- ColorSchemes -----
  static final ColorScheme lightScheme =
    ColorScheme.fromSeed(seedColor: moneyGreen, brightness: Brightness.light)
        .copyWith(
      primary: moneyGreen,
      secondary: piggyBankPink,
      tertiary: softGold,

      background: mistGreen,
      surface: cloud,

      // Semantic (NO RED)
      error: amber,
      onError: ink,

      // Helpful tuning
      outline: neutralGrey.withOpacity(0.45),
      surfaceTint: moneyGreen,
    );

  static final ColorScheme darkScheme =
    ColorScheme.fromSeed(seedColor: moneyGreen, brightness: Brightness.dark)
        .copyWith(
      primary: leafGreen,             // pops on dark
      secondary: piggyBankPinkDark,   // less intense than full pink
      tertiary: softGold,             // gold accents remain warm

      background: darkBg,
      surface: darkSurface,

      // Semantic (NO RED)
      error: amber,
      onError: Colors.black,

      outline: darkOutline,
      surfaceTint: leafGreen,

      // Helps text/icons feel less "glarey"
      onSurface: const Color(0xFFE9F1EC),
      onBackground: const Color(0xFFE9F1EC),
    );
}
