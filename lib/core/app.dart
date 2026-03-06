import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';
import 'theme/loop_theme.dart';

/// Main application widget
class LoopOutApp extends ConsumerWidget {
  const LoopOutApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'LoopOut',
      debugShowCheckedModeBanner: false,

      // Theme - Using new LoopTheme design system
      theme: LoopTheme.light,
      themeMode: ThemeMode.light,

      // Router
      routerConfig: router,
    );
  }
}

