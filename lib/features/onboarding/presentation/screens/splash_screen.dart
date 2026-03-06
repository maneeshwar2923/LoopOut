import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/providers/core_providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/loop_colors.dart';
import '../../../../core/theme/loop_spacing.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    // Branded experience delay
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    final authState = ref.read(authStateChangesProvider);

    authState.when(
      data: (user) async {
        if (user != null) {
          final isOnboardingDone = await ref.read(isOnboardingCompleteProvider.future);
          if (mounted) {
            context.go(isOnboardingDone ? AppRoutes.home : AppRoutes.locationPermission);
          }
        } else {
          if (mounted) context.go(AppRoutes.intro);
        }
      },
      loading: () => Future.delayed(const Duration(milliseconds: 500), _navigateAfterDelay),
      error: (_, __) {
        if (mounted) context.go(AppRoutes.intro);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: LoopColors.surfaceIvory50,
      body: Stack(
        children: [
          // Soft background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    LoopColors.surfaceGreen50.withValues(alpha: 0.4),
                    LoopColors.surfaceIvory50,
                  ],
                ),
              ),
            ),
          ),

          // Gentle pulsing ring
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: LoopColors.surfaceBlue100.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true))
             .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 2.seconds)
             .fade(begin: 0.6, end: 0),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo container with warm styling
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: LoopColors.primaryBlue900,
                    borderRadius: BorderRadius.circular(LoopSpacing.radiusXl),
                    boxShadow: [
                      BoxShadow(
                        color: LoopColors.primaryBlue900.withValues(alpha: 0.25),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    // Loop symbol - representing connection
                    child: Icon(
                      Icons.all_inclusive_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                ).animate()
                 .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), duration: 800.ms, curve: Curves.easeOutBack),
                
                const SizedBox(height: LoopSpacing.space48),
                
                // App Name
                Text(
                  'LOOP',
                  style: theme.textTheme.displayLarge?.copyWith(
                    letterSpacing: 8,
                    fontWeight: FontWeight.w700,
                    color: LoopColors.textPrimary,
                  ),
                ).animate()
                 .fadeIn(delay: 400.ms, duration: 600.ms)
                 .slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: LoopSpacing.space8),
                
                // Tagline - warm, activity-focused
                Text(
                  'get out. meet up. loop in.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    letterSpacing: 1,
                    color: LoopColors.textSecondary,
                  ),
                ).animate()
                 .fadeIn(delay: 800.ms, duration: 800.ms),
              ],
            ),
          ),
          
          // Bottom loading dots
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: LoopColors.primaryBlue700,
                      shape: BoxShape.circle,
                    ),
                  ).animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                   .fadeIn(delay: (1200 + index * 150).ms)
                   .then(delay: (index * 200).ms)
                   .scale(begin: const Offset(1, 1), end: const Offset(1.3, 1.3), duration: 400.ms)
                   .then()
                   .scale(begin: const Offset(1.3, 1.3), end: const Offset(1, 1), duration: 400.ms);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

