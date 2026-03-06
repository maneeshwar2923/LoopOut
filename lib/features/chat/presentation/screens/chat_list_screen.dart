import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../shared/widgets/app_shell.dart';
import '../../../../core/repositories/activity_repository.dart';

/// Chat list screen showing user's joined activities
class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final joinedActivitiesAsync = ref.watch(joinedActivitiesProvider);

    return MainScaffold(
      currentIndex: 3,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'MESSAGES',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0),
        ),
        body: joinedActivitiesAsync.when(
          data: (activities) {
            if (activities.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.chat_bubble_outline_rounded, size: 64, color: colorScheme.onSurface.withValues(alpha: 0.1)),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'SILENCE IS GOLDEN',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                        color: colorScheme.onSurface.withValues(alpha: 0.2),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Join an event to start your first chat',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn();
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              itemCount: activities.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final activity = activities[index];
                return Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(Icons.groups_rounded, color: colorScheme.primary),
                    ),
                    title: Text(
                      activity.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'GROUP CHAT',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.3),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                           '${activity.dateTime.day}/${activity.dateTime.month}',
                           style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.3)),
                        ),
                        const SizedBox(height: 4),
                        Icon(Icons.chevron_right, size: 16, color: colorScheme.onSurface.withValues(alpha: 0.1)),
                      ],
                    ),
                    onTap: () => context.push('/chat-detail/${activity.id}', extra: activity.title),
                  ),
                ).animate().fadeIn(delay: (index * 100).ms).slideY(begin: 0.1, end: 0);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
