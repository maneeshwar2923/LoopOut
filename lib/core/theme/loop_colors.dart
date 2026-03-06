import 'package:flutter/material.dart';

/// LoopOut Color System
/// Based on the warm, human, minimal design palette
class LoopColors {
  LoopColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIMARY PALETTE
  // ═══════════════════════════════════════════════════════════════════════════

  /// Bice Blue - High-energy CTAs, primary buttons
  static const Color primaryBlue900 = Color(0xFF036DA4);
  
  /// Air Superiority Blue - Active states, links, selections
  static const Color primaryBlue700 = Color(0xFF5EA3C0);
  
  /// Light Blue - Card highlights, chip backgrounds
  static const Color surfaceBlue100 = Color(0xFFB9D9DC);
  
  /// Honeydew Green - Secondary surfaces, success contexts
  static const Color surfaceGreen50 = Color(0xFFDBEBE2);
  
  /// Ivory - Primary background, cards
  static const Color surfaceIvory50 = Color(0xFFFDFCE8);

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Headlines, body text
  static const Color textPrimary = Color(0xFF1A1A1A);
  
  /// Descriptions, metadata
  static const Color textSecondary = Color(0xFF5C5C5C);
  
  /// Timestamps, hints
  static const Color textTertiary = Color(0xFF9E9E9E);
  
  /// Text on primary buttons
  static const Color textInverse = Color(0xFFFFFFFF);

  // ═══════════════════════════════════════════════════════════════════════════
  // BORDER COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Card borders, dividers
  static const Color borderSubtle = Color(0xFFE8E8E8);
  
  /// Focus rings
  static const Color borderFocus = Color(0xFF036DA4);

  // ═══════════════════════════════════════════════════════════════════════════
  // SEMANTIC COLORS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Error states
  static const Color error = Color(0xFFD32F2F);
  
  /// Success states
  static const Color success = Color(0xFF2E7D32);
  
  /// Warning states
  static const Color warning = Color(0xFFF9A825);

  // ═══════════════════════════════════════════════════════════════════════════
  // OPACITY LEVELS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Modal backdrops
  static const double opacityOverlay = 0.6;
  
  /// Disabled elements
  static const double opacityDisabled = 0.38;
  
  /// Hover states
  static const double opacityHover = 0.08;
  
  /// Pressed states
  static const double opacityPressed = 0.12;
  
  /// Focus rings
  static const double opacityFocus = 0.12;

  // ═══════════════════════════════════════════════════════════════════════════
  // COLOR SCHEME (for ThemeData)
  // ═══════════════════════════════════════════════════════════════════════════

  static ColorScheme get lightColorScheme => const ColorScheme(
    brightness: Brightness.light,
    // Primary colors
    primary: primaryBlue900,
    onPrimary: textInverse,
    primaryContainer: surfaceBlue100,
    onPrimaryContainer: primaryBlue900,
    // Secondary colors
    secondary: primaryBlue700,
    onSecondary: textInverse,
    secondaryContainer: surfaceGreen50,
    onSecondaryContainer: textPrimary,
    // Tertiary colors
    tertiary: surfaceGreen50,
    onTertiary: textPrimary,
    tertiaryContainer: surfaceGreen50,
    onTertiaryContainer: success,
    // Error colors
    error: error,
    onError: textInverse,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    // Background / Surface
    surface: surfaceIvory50,
    onSurface: textPrimary,
    surfaceContainerHighest: Color(0xFFFFFFFF),
    onSurfaceVariant: textSecondary,
    // Outline
    outline: borderSubtle,
    outlineVariant: borderSubtle,
    // Shadows
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    // Inverse
    inverseSurface: textPrimary,
    onInverseSurface: textInverse,
    inversePrimary: primaryBlue700,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get overlay color for hover states
  static Color getHoverOverlay(Color base) {
    return base.withValues(alpha: opacityHover);
  }

  /// Get overlay color for pressed states
  static Color getPressedOverlay(Color base) {
    return base.withValues(alpha: opacityPressed);
  }

  /// Get disabled version of a color
  static Color getDisabled(Color base) {
    return base.withValues(alpha: opacityDisabled);
  }
}
