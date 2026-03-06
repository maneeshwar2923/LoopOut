import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'loop_colors.dart';
import 'loop_typography.dart';
import 'loop_spacing.dart';

/// LoopOut Theme
/// Main theme configuration combining all design tokens
class LoopTheme {
  LoopTheme._();

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME
  // ═══════════════════════════════════════════════════════════════════════════

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: LoopColors.lightColorScheme,
    textTheme: LoopTypography.textTheme,
    fontFamily: LoopTypography.fontFamily,

    // ─────────────────────────────────────────────────────────────────────────
    // SCAFFOLD
    // ─────────────────────────────────────────────────────────────────────────
    scaffoldBackgroundColor: LoopColors.surfaceIvory50,

    // ─────────────────────────────────────────────────────────────────────────
    // APP BAR
    // ─────────────────────────────────────────────────────────────────────────
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      centerTitle: false,
      titleTextStyle: LoopTypography.displaySmall,
      iconTheme: const IconThemeData(
        color: LoopColors.textPrimary,
        size: LoopSpacing.glyphMd,
      ),
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // BUTTONS
    // ─────────────────────────────────────────────────────────────────────────
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: LoopColors.primaryBlue900,
        foregroundColor: LoopColors.textInverse,
        minimumSize: const Size.fromHeight(LoopSpacing.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: LoopSpacing.space24,
          vertical: LoopSpacing.space16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LoopSpacing.radiusSm),
        ),
        textStyle: LoopTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: LoopColors.primaryBlue900,
        minimumSize: const Size.fromHeight(LoopSpacing.buttonHeight),
        padding: const EdgeInsets.symmetric(
          horizontal: LoopSpacing.space24,
          vertical: LoopSpacing.space16,
        ),
        side: const BorderSide(
          color: LoopColors.primaryBlue900,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(LoopSpacing.radiusSm),
        ),
        textStyle: LoopTypography.labelLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: LoopColors.textSecondary,
        minimumSize: const Size.fromHeight(LoopSpacing.buttonHeightSmall),
        padding: const EdgeInsets.symmetric(
          horizontal: LoopSpacing.space16,
          vertical: LoopSpacing.space8,
        ),
        textStyle: LoopTypography.labelMedium,
      ),
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // ICON BUTTON
    // ─────────────────────────────────────────────────────────────────────────
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: LoopColors.textSecondary,
        minimumSize: const Size(
          LoopSpacing.iconButtonSize,
          LoopSpacing.iconButtonSize,
        ),
      ),
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // INPUT FIELDS
    // ─────────────────────────────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: LoopColors.surfaceIvory50,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: LoopSpacing.space16,
        vertical: LoopSpacing.space16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(LoopSpacing.radiusSm),
        borderSide: const BorderSide(color: LoopColors.borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(LoopSpacing.radiusSm),
        borderSide: const BorderSide(color: LoopColors.borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(LoopSpacing.radiusSm),
        borderSide: const BorderSide(
          color: LoopColors.borderFocus,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(LoopSpacing.radiusSm),
        borderSide: const BorderSide(color: LoopColors.error),
      ),
      labelStyle: LoopTypography.bodyMedium.copyWith(
        color: LoopColors.textSecondary,
      ),
      hintStyle: LoopTypography.bodyMedium.copyWith(
        color: LoopColors.textTertiary,
      ),
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // CARDS
    // ─────────────────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LoopSpacing.radiusMd),
        side: const BorderSide(color: LoopColors.borderSubtle),
      ),
      margin: EdgeInsets.zero,
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // CHIPS
    // ─────────────────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      backgroundColor: LoopColors.surfaceBlue100,
      selectedColor: LoopColors.primaryBlue700,
      labelStyle: LoopTypography.titleMedium,
      padding: const EdgeInsets.symmetric(
        horizontal: LoopSpacing.space12,
        vertical: LoopSpacing.space8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LoopSpacing.radiusFull),
      ),
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // BOTTOM SHEET
    // ─────────────────────────────────────────────────────────────────────────
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(LoopSpacing.radiusXl),
        ),
      ),
      showDragHandle: true,
      dragHandleColor: LoopColors.borderSubtle,
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // DIALOG
    // ─────────────────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LoopSpacing.radiusXl),
      ),
      titleTextStyle: LoopTypography.headlineSmall,
      contentTextStyle: LoopTypography.bodyMedium,
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // NAVIGATION BAR (Bottom)
    // ─────────────────────────────────────────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      elevation: 0,
      height: LoopSpacing.bottomNavHeight,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      indicatorColor: LoopColors.primaryBlue900.withValues(alpha: 0.1),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LoopSpacing.radiusMd),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return LoopTypography.labelSmall.copyWith(
            color: LoopColors.primaryBlue900,
            fontWeight: FontWeight.w600,
          );
        }
        return LoopTypography.labelSmall.copyWith(
          color: LoopColors.textTertiary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: LoopColors.primaryBlue900,
            size: LoopSpacing.glyphMd,
          );
        }
        return const IconThemeData(
          color: LoopColors.textTertiary,
          size: LoopSpacing.glyphMd,
        );
      }),
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // FLOATING ACTION BUTTON
    // ─────────────────────────────────────────────────────────────────────────
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: LoopColors.primaryBlue900,
      foregroundColor: LoopColors.textInverse,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // SNACKBAR
    // ─────────────────────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: LoopColors.textPrimary,
      contentTextStyle: LoopTypography.bodyMedium.copyWith(
        color: LoopColors.textInverse,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(LoopSpacing.radiusSm),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // DIVIDER
    // ─────────────────────────────────────────────────────────────────────────
    dividerTheme: DividerThemeData(
      color: LoopColors.borderSubtle,
      thickness: 1,
      space: LoopSpacing.space24,
    ),

    // ─────────────────────────────────────────────────────────────────────────
    // PAGE TRANSITIONS
    // ─────────────────────────────────────────────────────────────────────────
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
