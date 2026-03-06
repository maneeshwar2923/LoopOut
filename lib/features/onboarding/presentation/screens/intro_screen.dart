import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/loop_colors.dart';
import '../../../../core/theme/loop_spacing.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Activity-focused, non-dating language
  static const List<_IntroSlide> _slides = [
    _IntroSlide(
      icon: Icons.explore_rounded,
      title: 'EXPLORE\nLOCAL LOOPS',
      description: 'Discover activities happening around you—from morning yoga to photography walks to late-night board games.',
    ),
    _IntroSlide(
      icon: Icons.groups_rounded,
      title: 'JOIN\nYOUR CREW',
      description: 'Skip the awkward intros. Join a group that matches your interests and show up ready to have fun.',
    ),
    _IntroSlide(
      icon: Icons.add_circle_outline_rounded,
      title: 'HOST\nYOUR OWN',
      description: 'Got an idea? Create a loop and invite others to join. Build your community one activity at a time.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _goToNextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: 500.ms,
        curve: Curves.easeOutCubic,
      );
    } else {
      context.go(AppRoutes.phoneLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: LoopColors.surfaceIvory50,
      body: Stack(
        children: [
          // Soft gradient background
          Positioned(
            top: -150,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: LoopColors.surfaceGreen50.withValues(alpha: 0.5),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(LoopSpacing.space16),
                    child: TextButton(
                      onPressed: () => context.go(AppRoutes.phoneLogin),
                      child: Text(
                        'Skip',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: LoopColors.textTertiary,
                        ),
                      ),
                    ),
                  ),
                ),

                // Page content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: _onPageChanged,
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      return _IntroSlideWidget(
                        slide: _slides[index],
                        isActive: _currentPage == index,
                      );
                    },
                  ),
                ),

                // Bottom section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: LoopSpacing.space32,
                    vertical: LoopSpacing.space48,
                  ),
                  child: Column(
                    children: [
                      // Page indicator dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _slides.length,
                          (index) => AnimatedContainer(
                            duration: 300.ms,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: _currentPage == index
                                  ? LoopColors.primaryBlue900
                                  : LoopColors.surfaceBlue100,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: LoopSpacing.space32),

                      // Continue button
                      SizedBox(
                        width: double.infinity,
                        height: LoopSpacing.buttonHeight,
                        child: FilledButton(
                          onPressed: _goToNextPage,
                          child: Text(
                            isLastPage ? 'GET STARTED' : 'CONTINUE',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroSlide {
  final IconData icon;
  final String title;
  final String description;

  const _IntroSlide({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class _IntroSlideWidget extends StatelessWidget {
  final _IntroSlide slide;
  final bool isActive;

  const _IntroSlideWidget({required this.slide, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: LoopSpacing.space32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container with warm styling
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: LoopColors.surfaceBlue100,
              borderRadius: BorderRadius.circular(LoopSpacing.radiusXl),
            ),
            child: Center(
              child: Icon(
                slide.icon,
                size: 56,
                color: LoopColors.primaryBlue900,
              ),
            ),
          ).animate(target: isActive ? 1 : 0)
           .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1), curve: Curves.easeOutBack, duration: 500.ms),
           
          const SizedBox(height: LoopSpacing.space48),

          // Title
          Text(
            slide.title,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.15,
              letterSpacing: -0.5,
              color: LoopColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ).animate(target: isActive ? 1 : 0)
           .fadeIn(delay: 150.ms)
           .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
           
          const SizedBox(height: LoopSpacing.space16),

          // Description
          Text(
            slide.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: LoopColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ).animate(target: isActive ? 1 : 0)
           .fadeIn(delay: 300.ms)
           .slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }
}

