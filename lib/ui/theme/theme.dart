import 'package:flutter/material.dart';
import 'colors.dart';

/// Track That Money
/// lib/ui/theme/theme.dart
/// App theme, fed data from branding palette

ThemeData buildAppTheme() {
  final scheme = AppColors.lightScheme;

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.cream,

    // Typography
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w800,
        color: AppColors.deepMoss,
        letterSpacing: -0.5,
      ),
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.deepMoss,
        letterSpacing: -0.2,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w700,
        color: AppColors.deepMoss,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.deepMoss,
      ),
      bodyLarge: TextStyle(color: AppColors.deepMoss, height: 1.5),
      bodyMedium: TextStyle(color: AppColors.inkMuted, height: 1.4),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.deepMoss,
      ),
    ),

    // Cards
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.sand,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.warmLinen, width: 1),
      ),
      surfaceTintColor: Colors.transparent,
    ),

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.cream,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: AppColors.deepMoss,
      titleTextStyle: TextStyle(
        color: AppColors.deepMoss,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    // Bottom navigation
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.cream,
      indicatorColor: AppColors.sageMist,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: AppColors.sage);
        }
        return IconThemeData(color: AppColors.inkMuted);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            color: AppColors.sage,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          );
        }
        return TextStyle(
          color: AppColors.inkMuted, 
          fontSize: 12,
        );
      }),
    ),

    // Chips
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.sand,
      selectedColor: AppColors.sageMist,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppColors.deepMoss,
      ),
      side: BorderSide(color: AppColors.warmLinen),
      shape: StadiumBorder(),
    ),

    // Input fields
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.sand,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.warmLinen),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.warmLinen),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.sage, width: 2),
      ),
      labelStyle: TextStyle(color: AppColors.inkMuted),
      hintStyle: TextStyle(color: AppColors.inkMuted),
    ),

    // Elevated buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.sage,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),

    // Text buttons
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.sage,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Dividers
    dividerTheme: DividerThemeData(
      color: AppColors.warmLinen,
      thickness: 1,
    ),
  );
}
