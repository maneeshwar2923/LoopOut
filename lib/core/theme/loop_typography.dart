import 'package:flutter/material.dart';
import 'loop_colors.dart';

/// LoopOut Typography System
/// SF Pro Display / Inter with warm, readable scales
class LoopTypography {
  LoopTypography._();

  // ═══════════════════════════════════════════════════════════════════════════
  // FONT FAMILY
  // ═══════════════════════════════════════════════════════════════════════════

  /// Primary font family - Inter as cross-platform fallback for SF Pro
  static const String fontFamily = 'Inter';

  // ═══════════════════════════════════════════════════════════════════════════
  // DISPLAY STYLES (Large headers, splash, onboarding)
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.17, // 56px line height
    color: LoopColors.textPrimary,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.22, // 44px line height
    color: LoopColors.textPrimary,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.29, // 36px line height
    color: LoopColors.textPrimary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // HEADLINE STYLES (Section headers, card titles)
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.33, // 32px line height
    color: LoopColors.textPrimary,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4, // 28px line height
    color: LoopColors.textPrimary,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.44, // 26px line height
    color: LoopColors.textPrimary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TITLE STYLES (List items, chips)
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5, // 24px line height
    color: LoopColors.textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.57, // 22px line height
    color: LoopColors.textPrimary,
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.5, // 18px line height
    color: LoopColors.textPrimary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // BODY STYLES (Primary content)
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    height: 1.5, // 24px line height
    color: LoopColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    height: 1.57, // 22px line height
    color: LoopColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    height: 1.5, // 18px line height
    color: LoopColors.textSecondary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // LABEL STYLES (Buttons, metadata, timestamps)
  // ═══════════════════════════════════════════════════════════════════════════

  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.43, // 20px line height
    color: LoopColors.textPrimary,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.33, // 16px line height
    color: LoopColors.textPrimary,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    height: 1.4, // 14px line height
    color: LoopColors.textTertiary,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // TEXT THEME (for ThemeData)
  // ═══════════════════════════════════════════════════════════════════════════

  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
