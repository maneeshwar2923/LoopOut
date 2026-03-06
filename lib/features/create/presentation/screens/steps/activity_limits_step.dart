import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/create_activity_provider.dart';

class ActivityLimitsStep extends ConsumerWidget {
  const ActivityLimitsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(createActivityNotifierProvider);
    final notifier = ref.read(createActivityNotifierProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Participant Limits',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),

          // Capacity Slider
          Text(
            'Capacity: ${state.capacity} people',
            style: theme.textTheme.titleMedium,
          ),
          Slider(
            value: state.capacity.toDouble(),
            min: 2,
            max: 50,
            divisions: 48,
            label: state.capacity.toString(),
            onChanged: (val) => notifier.setCapacity(val.toInt()),
          ),
          Text(
            'Includes you (the host)',
            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          
          const Divider(height: 48),

          // Price Toggle
          SwitchListTile(
            title: const Text('This is a paid activity'),
            value: !state.isFree,
            onChanged: (val) => notifier.setIsFree(!val),
          ),

          if (!state.isFree) ...[
             const SizedBox(height: 16),
             TextField(
               keyboardType: TextInputType.number,
               decoration: const InputDecoration(
                 labelText: 'Price per person',
                 prefixText: '₹ ',
                 border: OutlineInputBorder(),
               ),
               onChanged: (val) {
                 final price = double.tryParse(val) ?? 0;
                 notifier.setPrice(price);
               },
             ),
          ],
        ],
      ),
    );
  }
}
