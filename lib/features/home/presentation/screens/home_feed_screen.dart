import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/repositories/activity_repository.dart';
import '../../../../core/models/activity_model.dart';
import '../../../../shared/widgets/app_shell.dart';
import '../widgets/activity_card.dart';
import '../widgets/category_chips.dart';

/// Home feed screen - main discover page
class HomeFeedScreen extends ConsumerStatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  ConsumerState<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends ConsumerState<HomeFeedScreen> {
  final _searchController = TextEditingController();
  bool _isMapView = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filters = ref.watch(activityFiltersStateProvider);
    final trendingAsync = ref.watch(trendingActivitiesProvider);
    final filteredAsync = ref.watch(filteredActivitiesProvider);

    return MainScaffold(
      currentIndex: 0,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Minimalist Header
          SliverAppBar(
            floating: true,
            pinned: false,
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXPLORE LOOPS',
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "What's your next adventure?",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.tune, size: 20),
                ),
                onPressed: () => _showFilters(context),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // Search Bar Overlay
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () => context.push('/search'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB9D9DC), // surface-blue-100
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: colorScheme.primary, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'Search activities...',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          _isMapView ? Icons.format_list_bulleted : Icons.map_outlined,
                          size: 20,
                        ),
                        onPressed: () {
                           setState(() => _isMapView = !_isMapView);
                           if (_isMapView) context.push('/map');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Category chips
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CategoryChips(
                selectedCategory: filters.category,
                onCategorySelected: (category) {
                  ref.read(activityFiltersStateProvider.notifier).setCategory(category);
                },
              ),
            ),
          ),

          // The Pulse (Trending)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                     decoration: BoxDecoration(
                       color: colorScheme.primary.withValues(alpha: 0.1),
                       borderRadius: BorderRadius.circular(8),
                     ),
                     child: Text(
                     'HAPPENING SOON',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                     ),
                   ),
                   const SizedBox(width: 8),
                   Expanded(
                     child: Container(height: 1, color: colorScheme.onSurface.withValues(alpha: 0.05)),
                   ),
                ],
              ),
            ),
          ),

          // Trending carousel
          SliverToBoxAdapter(
            child: SizedBox(
              height: 240,
              child: trendingAsync.when(
                data: (activities) {
                  if (activities.isEmpty) return const SizedBox.shrink();
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: activities.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return ActivityCardCompact(
                        id: activity.id,
                        title: activity.title,
                        category: activity.category,
                        imageUrl: activity.imageUrl,
                        dateTime: activity.dateTime,
                      ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.2, end: 0);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
          ),

          // All activities header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              child: Text(
                'UPCOMING NEAR YOU',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),

          // Activity list
          filteredAsync.when(
            data: (activities) {
              if (activities.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('No activities found', style: theme.textTheme.titleMedium),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                sliver: SliverList.separated(
                  itemCount: activities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return ActivityCard(
                      id: activity.id,
                      title: activity.title,
                      category: activity.category,
                      imageUrl: activity.imageUrl,
                      hostName: activity.hostName ?? 'Unknown',
                      hostPhotoUrl: activity.hostPhotoUrl,
                      locationName: activity.locationName,
                      dateTime: activity.dateTime,
                      participantCount: activity.participants.length,
                      capacity: activity.capacity,
                      price: activity.price,
                    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
                  },
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const FiltersBottomSheet(),
    );
  }
}

/// Filters bottom sheet
class FiltersBottomSheet extends ConsumerWidget {
  const FiltersBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final filters = ref.watch(activityFiltersStateProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filters',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(activityFiltersStateProvider.notifier)
                          .clearFilters();
                    },
                    child: const Text('Clear all'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Time filter
              Text(
                'When',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _buildTimeChip(
                    context,
                    ref,
                    'All',
                    null,
                    filters.fromDate == null,
                  ),
                  _buildTimeChip(
                    context,
                    ref,
                    'Today',
                    'today',
                    _isTimeFilterActive(filters, 'today'),
                  ),
                  _buildTimeChip(
                    context,
                    ref,
                    'Weekend',
                    'weekend',
                    _isTimeFilterActive(filters, 'weekend'),
                  ),
                  _buildTimeChip(
                    context,
                    ref,
                    'This Week',
                    'week',
                    _isTimeFilterActive(filters, 'week'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Category filter
              Text(
                'Category',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              CategoryChips(
                selectedCategory: filters.category,
                onCategorySelected: (category) {
                  ref
                      .read(activityFiltersStateProvider.notifier)
                      .setCategory(category);
                },
              ),
              const SizedBox(height: 32),

              // Apply button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Show Results'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeChip(
    BuildContext context,
    WidgetRef ref,
    String label,
    String? filter,
    bool isSelected,
  ) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(activityFiltersStateProvider.notifier).setTimeFilter(filter ?? 'all');
        if (filter == null) {
          ref.read(activityFiltersStateProvider.notifier).setDateRange(null, null);
        }
      },
    );
  }

  bool _isTimeFilterActive(ActivityFilters filters, String filter) {
    if (filters.fromDate == null) return false;
    // Simplified check
    return true;
  }
}
