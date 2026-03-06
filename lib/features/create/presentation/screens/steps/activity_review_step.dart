import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../providers/create_activity_provider.dart';

class ActivityReviewStep extends ConsumerWidget {
  const ActivityReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(createActivityNotifierProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check the vibe\nbefore you post',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1,
            ),
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0),
          
          const SizedBox(height: 48),

          _buildSection(
            context,
            title: 'INFO',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.title.isNotEmpty ? state.title : 'NO TITLE',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.category.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                if (state.description.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    state.description,
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ],
              ],
            ),
            delay: 200.ms,
          ),

          _buildSection(
            context,
            title: 'WHERE & WHEN',
            content: Column(
              children: [
                _buildReviewRow(
                  context,
                  icon: Icons.location_on_rounded,
                  text: state.locationName.isNotEmpty ? state.locationName : 'NO LOCATION',
                ),
                const SizedBox(height: 16),
                _buildReviewRow(
                  context,
                  icon: Icons.calendar_today_rounded,
                  text: state.dateTime == null 
                     ? 'NO DATE'
                     : '${state.dateTime!.day}/${state.dateTime!.month}/${state.dateTime!.year} @ ${TimeOfDay.fromDateTime(state.dateTime!).format(context)}',
                ),
              ],
            ),
            delay: 400.ms,
          ),

          _buildSection(
            context,
            title: 'DETAILS',
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                       'CAPACITY',
                       style: theme.textTheme.labelSmall?.copyWith(
                         fontWeight: FontWeight.w900,
                         letterSpacing: 1,
                         color: colorScheme.onSurface.withValues(alpha: 0.3),
                       ),
                     ),
                     const SizedBox(height: 4),
                     Text(
                       '${state.capacity} PEOPLE',
                       style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                     ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                     Text(
                       'ADMISSION',
                       style: theme.textTheme.labelSmall?.copyWith(
                         fontWeight: FontWeight.w900,
                         letterSpacing: 1,
                         color: colorScheme.onSurface.withValues(alpha: 0.3),
                       ),
                     ),
                     const SizedBox(height: 4),
                     Text(
                       state.isFree ? 'FREE' : '₹${state.price.toStringAsFixed(0)}',
                       style: theme.textTheme.titleMedium?.copyWith(
                         color: state.isFree ? colorScheme.primary : colorScheme.onSurface,
                         fontWeight: FontWeight.w900,
                       ),
                     ),
                  ],
                ),
              ],
            ),
            delay: 600.ms,
          ),
          
          if (state.error != null)
             Container(
               margin: const EdgeInsets.only(top: 24),
               padding: const EdgeInsets.all(16),
               decoration: BoxDecoration(
                 color: colorScheme.error.withValues(alpha: 0.1),
                 borderRadius: BorderRadius.circular(16),
                 border: Border.all(color: colorScheme.error.withValues(alpha: 0.2)),
               ),
               child: Row(
                 children: [
                   Icon(Icons.error_outline_rounded, color: colorScheme.error, size: 20),
                   const SizedBox(width: 12),
                   Expanded(
                     child: Text(
                       state.error!,
                       style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.error, fontWeight: FontWeight.bold),
                     ),
                   ),
                 ],
               ),
             ).animate().shake(),
             
          const SizedBox(height: 48),
          Center(
             child: Text(
               'Ready to go live?',
               style: theme.textTheme.labelLarge?.copyWith(
                 color: colorScheme.onSurface.withValues(alpha: 0.2),
                 fontWeight: FontWeight.w900,
                 letterSpacing: 1,
               ),
             ),
          ).animate().fadeIn(delay: 800.ms),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildReviewRow(BuildContext context, {required IconData icon, required String text}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context, {required String title, required Widget content, required Duration delay}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
             title,
             style: theme.textTheme.labelSmall?.copyWith(
               fontWeight: FontWeight.w900,
               letterSpacing: 2,
               color: colorScheme.onSurface.withValues(alpha: 0.3),
             ),
           ),
           const SizedBox(height: 12),
           Container( 
             width: double.infinity,
             padding: const EdgeInsets.all(24),
             decoration: BoxDecoration(
               color: colorScheme.surfaceContainerHighest,
               borderRadius: BorderRadius.circular(24),
               border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
             ),
             child: content,
           ),
        ],
      ),
    ).animate().fadeIn(delay: delay).slideY(begin: 0.1, end: 0);
  }
}
