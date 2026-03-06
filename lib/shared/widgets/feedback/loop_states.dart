import 'package:flutter/material.dart';
import '../../../core/theme/loop_colors.dart';
import '../../../core/theme/loop_spacing.dart';

/// Empty state widget with actionable CTA
/// 
/// Shows icon, title, description, and optional action button
class LoopEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const LoopEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(LoopSpacing.space32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: LoopColors.surfaceGreen50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: LoopSpacing.glyphXl,
              color: LoopColors.textTertiary,
            ),
          ),
          
          const SizedBox(height: LoopSpacing.space24),
          
          // Title
          Text(
            title.toUpperCase(),
            style: theme.textTheme.headlineMedium?.copyWith(
              color: LoopColors.textSecondary,
              letterSpacing: 1,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: LoopSpacing.space12),
          
          // Description
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: LoopColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
          
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: LoopSpacing.space24),
            
            // Action button
            FilledButton(
              onPressed: onAction,
              child: Text(actionLabel!.toUpperCase()),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error state widget with retry option
class LoopErrorState extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onRetry;

  const LoopErrorState({
    super.key,
    this.title = 'Something went wrong',
    this.description = 'We couldn\'t load this content. Please try again.',
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return LoopEmptyState(
      icon: Icons.cloud_off_rounded,
      title: title,
      description: description,
      actionLabel: onRetry != null ? 'Try Again' : null,
      onAction: onRetry,
    );
  }
}

/// Loading state widget
class LoopLoadingState extends StatelessWidget {
  final String? message;

  const LoopLoadingState({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 3,
            color: LoopColors.primaryBlue700,
          ),
          if (message != null) ...[
            const SizedBox(height: LoopSpacing.space16),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: LoopColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
