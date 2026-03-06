import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Activity card widget
class ActivityCard extends StatelessWidget {
  final String id;
  final String title;
  final String category;
  final String? imageUrl;
  final String hostName;
  final String? hostPhotoUrl;
  final String locationName;
  final DateTime dateTime;
  final int participantCount;
  final int capacity;
  final double? price;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    this.imageUrl,
    required this.hostName,
    this.hostPhotoUrl,
    required this.locationName,
    required this.dateTime,
    required this.participantCount,
    required this.capacity,
    this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => context.push('/activity/$id'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image with Gradient Overlay
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                   imageUrl != null
                      ? Image.network(imageUrl!, fit: BoxFit.cover)
                      : Container(color: colorScheme.primary.withValues(alpha: 0.1)),
                   
                   // Gradient Scrim for text readability
                   Positioned.fill(
                     child: Container(
                       decoration: BoxDecoration(
                         gradient: LinearGradient(
                           begin: Alignment.topCenter,
                           end: Alignment.bottomCenter,
                           colors: [
                             Colors.transparent,
                             Colors.black.withValues(alpha: 0.6),
                           ],
                         ),
                       ),
                     ),
                   ),

                   // Category Badge
                   Positioned(
                     top: 16,
                     left: 16,
                     child: Container(
                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                       decoration: BoxDecoration(
                         color: colorScheme.primary,
                         borderRadius: BorderRadius.circular(12),
                       ),
                       child: Text(
                         category.toUpperCase(),
                         style: theme.textTheme.labelSmall?.copyWith(
                           color: Colors.white,
                           fontWeight: FontWeight.w900,
                           letterSpacing: 1,
                         ),
                       ),
                     ),
                   ),

                   // Slots Indicator
                   Positioned(
                     bottom: 16,
                     left: 16,
                     child: Row(
                       children: [
                         const Icon(Icons.people, size: 14, color: Colors.white70),
                         const SizedBox(width: 4),
                         Text(
                           '$participantCount/$capacity JOINED',
                           style: theme.textTheme.labelSmall?.copyWith(
                             color: Colors.white70,
                             fontWeight: FontWeight.bold,
                             letterSpacing: 0.5,
                           ),
                         ),
                       ],
                     ),
                   ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                       Icon(Icons.location_on_rounded, size: 14, color: colorScheme.primary),
                       const SizedBox(width: 4),
                       Expanded(
                         child: Text(
                           locationName.toUpperCase(),
                           style: theme.textTheme.labelSmall?.copyWith(
                             color: colorScheme.onSurface.withValues(alpha: 0.5),
                             letterSpacing: 1,
                             fontWeight: FontWeight.bold,
                           ),
                           maxLines: 1,
                           overflow: TextOverflow.ellipsis,
                         ),
                       ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  Container(height: 1, color: colorScheme.onSurface.withValues(alpha: 0.05)),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                        backgroundImage: hostPhotoUrl != null ? NetworkImage(hostPhotoUrl!) : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hostName,
                              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _formatDateTime(dateTime),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface.withValues(alpha: 0.4),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        price == null || price! <= 0 ? 'FREE' : '₹${price!.toStringAsFixed(0)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Center(
      child: Icon(
        _getCategoryIcon(category),
        size: 48,
        color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.5),
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
      case 'food':
        return Icons.restaurant;
      case 'travel':
        return Icons.flight;
      case 'fitness':
        return Icons.fitness_center;
      default:
        return Icons.event;
    }
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final activityDate = DateTime(dt.year, dt.month, dt.day);

    String dateStr;
    if (activityDate == today) {
      dateStr = 'Today';
    } else if (activityDate == tomorrow) {
      dateStr = 'Tomorrow';
    } else {
      dateStr = '${dt.day}/${dt.month}/${dt.year}';
    }

    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');

    return '$dateStr at $hour:$minute $period';
  }
}

/// Compact activity card for horizontal lists
class ActivityCardCompact extends StatelessWidget {
  final String id;
  final String title;
  final String category;
  final String? imageUrl;
  final DateTime dateTime;
  final VoidCallback? onTap;

  const ActivityCardCompact({
    super.key,
    required this.id,
    required this.title,
    required this.category,
    this.imageUrl,
    required this.dateTime,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8E8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => context.push('/activity/$id'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  imageUrl != null
                      ? Image.network(imageUrl!, fit: BoxFit.cover)
                      : Container(color: colorScheme.primary.withOpacity(0.1)),
                  
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDateTime(dateTime).toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final activityDate = DateTime(dt.year, dt.month, dt.day);

    if (activityDate == today) return 'Today';
    if (activityDate == tomorrow) return 'Tomorrow';
    return '${dt.day}/${dt.month}';
  }
}
