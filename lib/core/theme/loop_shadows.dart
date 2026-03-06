import 'package:flutter/material.dart';

/// LoopOut Shadow/Elevation System
/// Soft, warm shadows for depth
class LoopShadows {
  LoopShadows._();

  // ═══════════════════════════════════════════════════════════════════════════
  // ELEVATION LEVELS
  // ═══════════════════════════════════════════════════════════════════════════

  /// No shadow - flat elements
  static const List<BoxShadow> elevation0 = [];

  /// Elevation 1 - Cards at rest
  /// 0 1px 3px rgba(0,0,0,0.08)
  static const List<BoxShadow> elevation1 = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 3,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  /// Elevation 2 - Cards on hover/press
  /// 0 4px 8px rgba(0,0,0,0.12)
  static const List<BoxShadow> elevation2 = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 8,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Elevation 3 - Bottom sheets, modals
  /// 0 8px 24px rgba(0,0,0,0.16)
  static const List<BoxShadow> elevation3 = [
    BoxShadow(
      color: Color(0x29000000),
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Elevation 4 - FAB, tooltips
  /// 0 12px 32px rgba(0,0,0,0.20)
  static const List<BoxShadow> elevation4 = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 32,
      offset: Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  // ═══════════════════════════════════════════════════════════════════════════
  // SPECIAL SHADOWS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Bottom navigation shadow (upward)
  static const List<BoxShadow> bottomNav = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12,
      offset: Offset(0, -4),
      spreadRadius: 0,
    ),
  ];

  /// Primary button shadow (colored)
  static List<BoxShadow> primaryButton(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Soft glow for active states
  static List<BoxShadow> glow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.2),
      blurRadius: 20,
      offset: Offset.zero,
      spreadRadius: 4,
    ),
  ];
}
