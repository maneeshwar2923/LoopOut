import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../providers/create_activity_provider.dart';

class ActivityDateTimeStep extends ConsumerWidget {
  const ActivityDateTimeStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(createActivityNotifierProvider);
    final notifier = ref.read(createActivityNotifierProvider.notifier);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'When is\nthe excitement?',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w900,
              height: 1.1,
              letterSpacing: -1,
            ),
          ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.1, end: 0),
          
          const SizedBox(height: 48),

          _buildPickerCard(
            context,
            title: 'DATE',
            value: state.dateTime == null 
              ? 'NOT SET' 
              : '${state.dateTime!.day}/${state.dateTime!.month}/${state.dateTime!.year}',
            icon: Icons.calendar_today_rounded,
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: state.dateTime ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                final time = state.dateTime != null 
                  ? TimeOfDay.fromDateTime(state.dateTime!)
                  : const TimeOfDay(hour: 12, minute: 0);
                notifier.setDateTime(DateTime(date.year, date.month, date.day, time.hour, time.minute));
              }
            },
            delay: 200.ms,
          ),

          const SizedBox(height: 24),

          _buildPickerCard(
            context,
            title: 'TIME',
            value: state.dateTime == null 
              ? 'NOT SET' 
              : TimeOfDay.fromDateTime(state.dateTime!).format(context),
            icon: Icons.access_time_rounded,
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: state.dateTime != null 
                  ? TimeOfDay.fromDateTime(state.dateTime!)
                  : TimeOfDay.now(),
              );
              if (time != null) {
                final date = state.dateTime ?? DateTime.now();
                notifier.setDateTime(DateTime(date.year, date.month, date.day, time.hour, time.minute));
              }
            },
            delay: 400.ms,
          ),

          if (state.dateTime != null && state.dateTime!.isBefore(DateTime.now()))
             Padding(
               padding: const EdgeInsets.only(top: 32),
               child: Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: colorScheme.error.withValues(alpha: 0.1),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Row(
                   children: [
                     Icon(Icons.warning_amber_rounded, color: colorScheme.error, size: 20),
                     const SizedBox(width: 12),
                     Text(
                       'Time is in the past',
                       style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.error, fontWeight: FontWeight.bold),
                     ),
                   ],
                 ),
               ),
             ).animate().shake(),
        ],
      ),
    );
  }

  Widget _buildPickerCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
    required Duration delay,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSet = value != 'NOT SET';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSet ? colorScheme.primary.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05),
            width: isSet ? 2 : 1,
          ),
          boxShadow: isSet ? [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ] : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSet ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: isSet ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.3), size: 20),
            ),
            const SizedBox(width: 20),
            Expanded(
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
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: isSet ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurface.withValues(alpha: 0.1)),
          ],
        ),
      ).animate().fadeIn(delay: delay).slideY(begin: 0.1, end: 0),
    );
  }
}
