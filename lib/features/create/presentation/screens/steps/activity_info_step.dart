import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/create_activity_provider.dart';
import '../../../../home/presentation/widgets/category_chips.dart';

class ActivityInfoStep extends ConsumerStatefulWidget {
  const ActivityInfoStep({super.key});

  @override
  ConsumerState<ActivityInfoStep> createState() => _ActivityInfoStepState();
}

class _ActivityInfoStepState extends ConsumerState<ActivityInfoStep> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createActivityNotifierProvider);
    _titleController = TextEditingController(text: state.title);
    _descController = TextEditingController(text: state.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(createActivityNotifierProvider);
    final notifier = ref.read(createActivityNotifierProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What are you planning?',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          
          Text('Title', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            onChanged: notifier.setTitle,
            decoration: const InputDecoration(
              hintText: 'e.g., Sunday Morning Football',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          Text('Category', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          CategoryChips(
            selectedCategory: state.category,
            onCategorySelected: (cat) {
              if (cat != null) notifier.setCategory(cat);
            },
          ),
          const SizedBox(height: 24),

          Text('Description', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _descController,
             onChanged: notifier.setDescription,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Describe what you\'ll be doing...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
