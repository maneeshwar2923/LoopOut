import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../../../core/repositories/activity_repository.dart';
import '../../../../core/theme/loop_colors.dart';
import '../../../../core/providers/core_providers.dart';

/// Activity detail screen showing full activity info
class ActivityDetailScreen extends ConsumerWidget {
  final String activityId;

  const ActivityDetailScreen({super.key, required this.activityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentUser = ref.watch(currentUserProvider);

    // Watch activity stream for real-time updates
    final activityAsync = ref.watch(
      StreamProvider((ref) {
        final repo = ref.watch(activityRepositoryProvider);
        return repo.watchActivity(activityId);
      }),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: activityAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: colorScheme.error),
              const SizedBox(height: 16),
              Text('Activity not found', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
        data: (activity) {
          if (activity == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 48, color: colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('Activity not found', style: theme.textTheme.titleLarge),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final isHost = currentUser?.uid == activity.hostId;
          final hasJoined = activity.participants.contains(currentUser?.uid);
          final isFull = activity.isFull;
          final spotsLeft = activity.availableSpots;

          return CustomScrollView(
            slivers: [
              // Hero header
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: colorScheme.primary,
                leading: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back, color: Colors.black87),
                  ),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          colorScheme.primary,
                          colorScheme.primary.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getCategoryIcon(activity.category),
                        size: 64,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: LoopColors.surfaceBlue100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          activity.category.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                            color: colorScheme.primary,
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms),

                      const SizedBox(height: 16),

                      // Title
                      Text(
                        activity.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.05, end: 0),

                      const SizedBox(height: 24),

                      // Info cards
                      _buildInfoCard(
                        context,
                        icon: Icons.calendar_today,
                        label: 'DATE & TIME',
                        value: DateFormat('EEE, MMM d • h:mm a').format(activity.dateTime),
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: 12),

                      _buildInfoCard(
                        context,
                        icon: Icons.location_on,
                        label: 'LOCATION',
                        value: activity.locationName,
                      ).animate().fadeIn(delay: 300.ms),

                      const SizedBox(height: 12),

                      _buildInfoCard(
                        context,
                        icon: Icons.people,
                        label: 'CAPACITY',
                        value: '${activity.participants.length}/${activity.capacity} joined',
                        trailing: spotsLeft > 0
                            ? Text(
                                '$spotsLeft spots left',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: LoopColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : Text(
                                'FULL',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.error,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ).animate().fadeIn(delay: 400.ms),

                      if (!activity.isFree) ...[
                        const SizedBox(height: 12),
                        _buildInfoCard(
                          context,
                          icon: Icons.payments,
                          label: 'PRICE',
                          value: '₹${activity.price.toStringAsFixed(0)}',
                        ).animate().fadeIn(delay: 500.ms),
                      ],

                      const SizedBox(height: 24),

                      // Description
                      Text(
                        'ABOUT',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: LoopColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        activity.description.isNotEmpty
                            ? activity.description
                            : 'No description provided.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: LoopColors.textSecondary,
                        ),
                      ).animate().fadeIn(delay: 600.ms),

                      const SizedBox(height: 32),

                      // Host info
                      Text(
                        'HOSTED BY',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: LoopColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: LoopColors.surfaceBlue100,
                            child: Text(
                              (activity.hostName ?? 'U')[0].toUpperCase(),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  activity.hostName ?? 'Unknown Host',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (isHost)
                                  Text(
                                    'You are the host',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.primary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 700.ms),

                      const SizedBox(height: 100), // Space for bottom button
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: activityAsync.whenOrNull(
        data: (activity) {
          if (activity == null) return null;

          final isHost = currentUser?.uid == activity.hostId;
          final hasJoined = activity.participants.contains(currentUser?.uid);
          final isFull = activity.isFull;

          return SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: isHost
                  ? OutlinedButton(
                      onPressed: () {
                        // TODO: Edit activity
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('EDIT ACTIVITY'),
                    )
                  : hasJoined
                      ? OutlinedButton(
                          onPressed: () async {
                            final repo = ref.read(activityRepositoryProvider);
                            await repo.leaveActivity(activity.id, currentUser!.uid);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Left activity')),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            foregroundColor: colorScheme.error,
                            side: BorderSide(color: colorScheme.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('LEAVE ACTIVITY'),
                        )
                      : FilledButton(
                          onPressed: isFull
                              ? null
                              : () async {
                                  final repo = ref.read(activityRepositoryProvider);
                                  await repo.joinActivity(activity.id, currentUser!.uid);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Joined activity! 🎉')),
                                    );
                                  }
                                },
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(isFull ? 'ACTIVITY FULL' : 'JOIN ACTIVITY'),
                        ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Widget? trailing,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: LoopColors.surfaceBlue100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    color: LoopColors.textTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Icons.sports_basketball;
      case 'music':
        return Icons.music_note;
      case 'arts':
        return Icons.palette;
      case 'tech':
        return Icons.computer;
      case 'food':
        return Icons.restaurant;
      case 'social':
        return Icons.groups;
      case 'outdoors':
        return Icons.park;
      case 'gaming':
        return Icons.sports_esports;
      default:
        return Icons.event;
    }
  }
}
