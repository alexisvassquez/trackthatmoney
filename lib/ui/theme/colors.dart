// track_that_money
// lib/ui/theme/colors.dart

import 'package:flutter/material.dart';

/// Brand palette - NO RED ANYWHERE :)
class AppColors {
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
}
