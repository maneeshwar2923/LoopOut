import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/app_shell.dart';

/// Feed screen placeholder (for activity feed/social updates)
class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MainScaffold(
      currentIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feed'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.dynamic_feed,
                size: 80,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 24),
              Text(
                'Coming Soon',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Activity feed will show updates from your friends',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
