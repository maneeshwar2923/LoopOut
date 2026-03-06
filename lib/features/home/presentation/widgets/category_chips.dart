import 'package:flutter/material.dart';

import '../../../../shared/constants/app_constants.dart';

/// Category filter chips widget
class CategoryChips extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategoryChips({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: AppConstants.interestCategories.length + 1, // +1 for "All"
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildChip(
              context,
              label: 'All',
              icon: Icons.apps,
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
            );
          }

          final category = AppConstants.interestCategories[index - 1];
          return _buildChip(
            context,
            label: category,
            icon: _getCategoryIcon(category),
            isSelected: selectedCategory == category,
            onTap: () => onCategorySelected(category),
          );
        },
      ),
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
              ? colorScheme.primary.withValues(alpha: 0.5) 
              : Colors.white.withValues(alpha: 0.05),
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              spreadRadius: 2,
            )
          ] : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 8),
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                fontSize: 10,
                color: isSelected ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'sports':
        return Icons.sports_soccer;
      case 'gaming':
        return Icons.sports_esports;
      case 'music':
        return Icons.music_note;
      case 'art':
        return Icons.palette;
      case 'tech':
        return Icons.computer;
      case 'food & drinks':
        return Icons.restaurant;
      case 'outdoors':
        return Icons.terrain;
      case 'fitness':
        return Icons.fitness_center;
      case 'networking':
        return Icons.handshake;
      case 'movies':
        return Icons.movie;
      case 'books':
        return Icons.book;
      case 'photography':
        return Icons.camera_alt;
      default:
        return Icons.category;
    }
  }
}

/// Time filter chips widget
class TimeFilterChips extends StatelessWidget {
  final String? selectedFilter;
  final ValueChanged<String?> onFilterSelected;

  const TimeFilterChips({
    super.key,
    this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'Today', 'Weekend', 'This Week'];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = (filter == 'All' && selectedFilter == null) ||
              selectedFilter == filter.toLowerCase();

          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (_) {
              if (filter == 'All') {
                onFilterSelected(null);
              } else {
                onFilterSelected(filter.toLowerCase());
              }
            },
          );
        },
      ),
    );
  }
}
