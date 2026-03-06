import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// LoopOut Material 3 Theme
class AppTheme {
  AppTheme._();

  // Brand colors (Quantum Glow)
  static const Color _primaryColor = Color(0xFF6366F1); // Indigo Primary
  static const Color _accentColor = Color(0xFFA5B4FC); // Glow Highlight
  static const Color _successColor = Color(0xFF2DD4BF); // Electric Teal (Freshness)
  static const Color _errorColor = Color(0xFFFB7185); // Soft Rose Error

  // Neutral colors (Dark focused)
  static const Color _backgroundDark = Color(0xFF0A0A0B); // Pure Depth
  static const Color _surfaceDark = Color(0xFF18181B); // Soft Surface
  static const Color _surfaceLight = Color(0xFFFAFAFA);
  static const Color _textHigh = Color(0xFFFAFAFA);
  static const Color _textDim = Color(0xFFA1A1AA);

  /// Light theme
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      surface: _surfaceLight,
      brightness: Brightness.light,
    );
    return _buildTheme(colorScheme);
  }

  /// Dark theme
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryColor,
      primary: _primaryColor,
      secondary: _accentColor,
      surface: _backgroundDark,
      onSurface: _textHigh,
      surfaceVariant: _surfaceDark,
      brightness: Brightness.dark,
    );
    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? _backgroundDark : colorScheme.surface,

      // Typography
      textTheme: _buildTextTheme(isDark),

      // AppBar - Minimalist
      appBarTheme: AppBarTheme(
        centerTitle: false, // Modern bold left-aligned titles often look better
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: colorScheme.onSurface,
        ),
      ),

      // Cards - Floating Depth
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? _surfaceDark : colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // Softer corners
          side: isDark 
            ? BorderSide(color: Colors.white.withOpacity(0.05), width: 1)
            : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Buttons - Premium & Bold
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 64), // Taller for premium feel
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          backgroundColor: colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
          ),
        ),
      ),

      // Input fields - Subtle Glassmorphism
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: isDark ? Colors.white.withOpacity(0.1) : colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 72,
        backgroundColor: isDark ? _backgroundDark : colorScheme.surface,
        indicatorColor: colorScheme.primary.withOpacity(0.1),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
          }
          return const TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
        }),
      ),

      // Page transitions
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _buildTextTheme(bool isDark) {
    final baseColor = isDark ? _textHigh : Colors.black87;
    
    // Using Inter as a premium geometric alternative to SF Pro
    final baseTextTheme = GoogleFonts.interTextTheme();

    return baseTextTheme.copyWith(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w900, // Extrabold for futuristic display
        letterSpacing: -1.5,
        color: baseColor,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.0,
        color: baseColor,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: baseColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: baseColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: baseColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: baseColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: baseColor,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: baseColor,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        height: 1.5,
        color: baseColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
        height: 1.4,
        color: baseColor,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: _textDim,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: baseColor,
      ),
    );
  }

  // Success color for use throughout the app
  static Color get successColor => _successColor;
}
