// track_that_money
// lib/ui/theme/theme.dart

import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.brandPrimary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.brandPrimary,
    secondary: AppColors.brandSecondary,
    tertiary: AppColors.softGold,
    surface: AppColors.cloud,
    background: AppColors.mistGreen,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.ink,
    onBackground: AppColors.ink,
    error: AppColors.caution,    // Use amber instead of red for "error-like" UI (non-destructive)
    onError: AppColors.ink,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.background,
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.w700, letterSpacing: -0.2),
      titleMedium:  TextStyle(fontWeight: FontWeight.w600),
      bodyMedium:   TextStyle(height: 1.25),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      surfaceTintColor: Colors.transparent,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.ink,
    ),
    chipTheme: ChipThemeData(
      shape: StadiumBorder(side: BorderSide(color: AppColors.neutralGrey.withOpacity(.3))),
      backgroundColor: Colors.white,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  );
}
