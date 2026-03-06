import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/repositories/activity_repository.dart';
import '../widgets/activity_card.dart';

/// Search provider for search query
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Search results provider
final searchResultsProvider = FutureProvider.autoDispose((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return <dynamic>[];
  final repo = ref.watch(activityRepositoryProvider);
  return repo.searchActivities(query);
});

/// Search screen for finding activities
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus the search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final searchResults = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(searchQueryProvider.notifier).state = '';
            context.pop();
          },
        ),
        title: TextField(
          controller: _searchController,
          focusNode: _focusNode,
          decoration: const InputDecoration(
            hintText: 'Search activities, places...',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
        ),
        actions: [
          if (query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                ref.read(searchQueryProvider.notifier).state = '';
              },
            ),
        ],
      ),
      body: query.isEmpty
          ? _buildRecentSearches(theme, colorScheme)
          : searchResults.when(
              data: (results) {
                if (results.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No results found',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching for something else',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final activity = results[index];
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
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (_, __) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    const Text('Search failed'),
                    TextButton(
                      onPressed: () => ref.refresh(searchResultsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildRecentSearches(ThemeData theme, ColorScheme colorScheme) {
    // For now, show suggestions
    final suggestions = [
      'Sports',
      'Gaming night',
      'Music jam',
      'Hiking',
      'Coffee meetup',
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Popular Searches',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((s) {
            return ActionChip(
              avatar: const Icon(Icons.trending_up, size: 18),
              label: Text(s),
              onPressed: () {
                _searchController.text = s;
                ref.read(searchQueryProvider.notifier).state = s;
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Text(
          'Categories',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildCategoryTile(context, 'Sports', Icons.sports_soccer),
            _buildCategoryTile(context, 'Gaming', Icons.sports_esports),
            _buildCategoryTile(context, 'Music', Icons.music_note),
            _buildCategoryTile(context, 'Art', Icons.palette),
            _buildCategoryTile(context, 'Tech', Icons.computer),
            _buildCategoryTile(context, 'Food', Icons.restaurant),
            _buildCategoryTile(context, 'Fitness', Icons.fitness_center),
            _buildCategoryTile(context, 'Outdoors', Icons.terrain),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryTile(BuildContext context, String label, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        _searchController.text = label;
        ref.read(searchQueryProvider.notifier).state = label;
      },
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
