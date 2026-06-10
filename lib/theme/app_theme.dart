import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary          = Color(0xFF0F4761);
  static const Color primaryContainer = Color(0xFFCDE7FF);
  static const Color onPrimary        = Color(0xFFFFFFFF);
  static const Color secondary        = Color(0xFF00838F);
  static const Color background       = Color(0xFFF4F6F9);
  static const Color surface          = Color(0xFFFFFFFF);
  static const Color textPrimary      = Color(0xFF0D1B2A);
  static const Color textSecondary    = Color(0xFF4A5568);

  // High-contrast colours — 4FC3F7 on #000 ≈ 9.8:1 contrast (WCAG AAA).
  static const Color hcBackground    = Color(0xFF000000);
  static const Color hcSurface       = Color(0xFF1A1A1A);
  static const Color hcPrimary       = Color(0xFF4FC3F7);
  static const Color hcText          = Color(0xFFFFFFFF);
  static const Color hcTextSecondary = Color(0xFFE0E0E0);

  static ThemeData get lightTheme => _buildLight();
  static ThemeData get darkTheme  => _buildDark();

  static ThemeData _buildLight() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        surface: surface,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: onPrimary, fontSize: 20, fontWeight: FontWeight.w700,
          letterSpacing: 0.15,
        ),
        iconTheme: IconThemeData(color: onPrimary, size: 24),
      ),
      // All button themes enforce the 48 dp minimum touch-target (WCAG 2.5.5).
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 2),
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(48, 48),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCBD5E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCBD5E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53E3E), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: const TextStyle(color: textSecondary),
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surface,
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primaryContainer,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary);
          }
          return const IconThemeData(color: textSecondary);
        }),
        elevation: 8,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? primary : Colors.grey[400]),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? primary.withValues(alpha: 0.4)
                : Colors.grey[300]),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: primary,
        thumbColor: primary,
        inactiveTrackColor: Color(0xFFCBD5E0),
        trackHeight: 4,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryContainer,
        selectedColor: primary,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  static ThemeData _buildDark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: hcPrimary,
        onPrimary: hcBackground,
        secondary: Color(0xFF80DEEA),
        surface: hcSurface,
        onSurface: hcText,
        error: Color(0xFFCF6679),
      ),
      scaffoldBackgroundColor: hcBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: hcSurface,
        foregroundColor: hcText,
        elevation: 0,
        titleTextStyle: TextStyle(
            color: hcText, fontSize: 20, fontWeight: FontWeight.w700),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: hcPrimary,
          foregroundColor: hcBackground,
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: hcSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF555555)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: hcPrimary, width: 2),
        ),
        labelStyle: const TextStyle(color: hcTextSecondary),
      ),
      cardTheme: CardThemeData(
        color: hcSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: hcSurface,
        indicatorColor: hcPrimary.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? const IconThemeData(color: hcPrimary)
                : const IconThemeData(color: hcTextSecondary)),
      ),
    );
  }
}
