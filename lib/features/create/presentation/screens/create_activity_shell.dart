import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/create_activity_provider.dart';
import 'steps/activity_info_step.dart';
import 'steps/activity_location_step.dart';
import 'steps/activity_datetime_step.dart';
import 'steps/activity_limits_step.dart';
import 'steps/activity_review_step.dart';

/// Shell for multi-step create activity wizard
class CreateActivityShell extends ConsumerStatefulWidget {
  const CreateActivityShell({super.key});

  @override
  ConsumerState<CreateActivityShell> createState() => _CreateActivityShellState();
}

class _CreateActivityShellState extends ConsumerState<CreateActivityShell> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    final state = ref.read(createActivityNotifierProvider);
    bool isValid = false;
    String? errorMessage;

    switch (_currentStep) {
      case 0: 
        isValid = state.isStep1Valid;
        if (!isValid) errorMessage = 'Please enter a title and select a category';
        break;
      case 1: 
        isValid = state.isStep2Valid;
        if (!isValid) errorMessage = 'Please select a location';
        break;
      case 2: 
        isValid = state.isStep3Valid;
        if (!isValid) errorMessage = 'Please select a future date and time';
        break;
      case 3: 
        isValid = state.isStep4Valid;
        if (!isValid) errorMessage = 'Capacity must be at least 2';
        break;
      default: isValid = true;
    }

    if (!isValid) {
      if (errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), behavior: SnackBarBehavior.floating),
        );
      }
      return;
    }

    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop(); // Exit if on first step
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(createActivityNotifierProvider);
    final notifier = ref.read(createActivityNotifierProvider.notifier);

    // Listen for errors and show snackbar
    ref.listen<CreateActivityState>(createActivityNotifierProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, size: 24),
          onPressed: () => context.pop(),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              'CREATE EVENT',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_totalSteps, (index) {
                final isActive = index == _currentStep;
                final isDone = index < _currentStep;
                return Container(
                  width: isActive ? 24 : 8,
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isActive ? colorScheme.primary : (isDone ? colorScheme.primary.withValues(alpha: 0.3) : colorScheme.onSurface.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ).animate(target: isActive ? 1 : 0).scaleX(begin: 1.0, end: 1.2);
              }),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
               onPressed: state.isLoading ? null : () async {
                   if (_currentStep == _totalSteps - 1) {
                       final success = await notifier.createActivity();
                       if (success && context.mounted) {
                           context.pop();
                           ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('Activity published! 🎉'), behavior: SnackBarBehavior.floating),
                           );
                       }
                   } else {
                       _nextPage();
                   }
               }, 
               child: state.isLoading 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(
                      _currentStep == _totalSteps - 1 ? 'PUBLISH' : 'NEXT',
                      style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, color: colorScheme.primary),
                    ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) => setState(() => _currentStep = index),
        children: const [
          ActivityInfoStep(),
          ActivityLocationStep(),
          ActivityDateTimeStep(),
          ActivityLimitsStep(),
          ActivityReviewStep(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Primary Next/Publish Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: state.isLoading ? null : () async {
                    if (_currentStep == _totalSteps - 1) {
                      final success = await notifier.createActivity();
                      if (success && context.mounted) {
                        context.pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Activity published! 🎉'), behavior: SnackBarBehavior.floating),
                        );
                      }
                    } else {
                      _nextPage();
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: state.isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(
                          _currentStep == _totalSteps - 1 ? 'PUBLISH ACTIVITY' : 'NEXT',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 1),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              // Back button (only shown after first step)
              if (_currentStep > 0)
                TextButton(
                  onPressed: _previousPage,
                  child: Text(
                    'Go Back',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
