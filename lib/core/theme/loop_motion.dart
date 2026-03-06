import 'package:flutter/material.dart';

/// LoopOut Motion System
/// Spring physics and timing for natural animations
class LoopMotion {
  LoopMotion._();

  // ═══════════════════════════════════════════════════════════════════════════
  // DURATION TOKENS
  // ═══════════════════════════════════════════════════════════════════════════

  /// 100ms - Micro-interactions, color changes
  static const Duration instant = Duration(milliseconds: 100);

  /// 200ms - Button states, tooltips
  static const Duration fast = Duration(milliseconds: 200);

  /// 300ms - Card transitions, modals
  static const Duration normal = Duration(milliseconds: 300);

  /// 500ms - Page transitions, complex animations
  static const Duration slow = Duration(milliseconds: 500);

  /// 800ms - Hero animations, celebration moments
  static const Duration emphasis = Duration(milliseconds: 800);

  // ═══════════════════════════════════════════════════════════════════════════
  // EASING CURVES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Elements entering
  static const Curve easeOut = Curves.easeOutCubic;

  /// Elements exiting
  static const Curve easeIn = Curves.easeInCubic;

  /// Moving elements
  static const Curve easeInOut = Curves.easeInOutCubic;

  /// Natural spring physics
  static const Curve spring = Curves.elasticOut;

  /// Playful bounce
  static const Curve bounce = Curves.bounceOut;

  /// Smooth deceleration
  static const Curve decelerate = Curves.decelerate;

  // ═══════════════════════════════════════════════════════════════════════════
  // STAGGER DELAYS
  // ═══════════════════════════════════════════════════════════════════════════

  /// 30ms - Chips, tags (fast cascade)
  static const Duration staggerChips = Duration(milliseconds: 30);

  /// 50ms - List items (balanced cascade)
  static const Duration staggerList = Duration(milliseconds: 50);

  /// 100ms - Cards (noticeable cascade)
  static const Duration staggerCards = Duration(milliseconds: 100);

  /// Maximum items to animate (rest appear instantly)
  static const int staggerMaxItems = 10;

  // ═══════════════════════════════════════════════════════════════════════════
  // SPRING CONFIGURATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Standard spring for UI elements
  static SpringDescription get standardSpring => const SpringDescription(
    mass: 1,
    stiffness: 300,
    damping: 20,
  );

  /// Bouncy spring for playful elements
  static SpringDescription get bouncySpring => const SpringDescription(
    mass: 1,
    stiffness: 400,
    damping: 15,
  );

  /// Gentle spring for subtle animations
  static SpringDescription get gentleSpring => const SpringDescription(
    mass: 1,
    stiffness: 200,
    damping: 25,
  );
}
