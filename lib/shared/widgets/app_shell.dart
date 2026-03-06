import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/loop_colors.dart';

/// App shell with warm, premium bottom navigation
/// Matches design_system_phase3.md spec F.3/F.4
class AppShell extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const AppShell({
    super.key, 
    required this.child,
    required this.currentPath,
  });

  int get _currentIndex {
    if (currentPath.startsWith('/home')) return 0;
    if (currentPath.startsWith('/map')) return 1;
    if (currentPath.startsWith('/chat')) return 2;
    if (currentPath.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      extendBody: true,
      
      // Premium Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Explore
                _NavItem(
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore,
                  label: 'Explore',
                  isSelected: _currentIndex == 0,
                  onTap: () => context.go('/home'),
                ),
                // Map
                _NavItem(
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map,
                  label: 'Map',
                  isSelected: _currentIndex == 1,
                  onTap: () => context.go('/map'),
                ),
                // Center FAB space
                const SizedBox(width: 64),
                // Chats
                _NavItem(
                  icon: Icons.chat_bubble_outline,
                  activeIcon: Icons.chat_bubble,
                  label: 'Chats',
                  isSelected: _currentIndex == 2,
                  onTap: () => context.go('/chat'),
                ),
                // Profile
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: 'You',
                  isSelected: _currentIndex == 3,
                  onTap: () => context.go('/profile'),
                ),
              ],
            ),
          ),
        ),
      ),
      
      // Center Create FAB
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: LoopColors.primaryBlue900.withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => context.push('/create'),
          backgroundColor: LoopColors.primaryBlue900,
          foregroundColor: Colors.white,
          elevation: 0,
          highlightElevation: 0,
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

/// Individual navigation item
class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 24,
              color: isSelected ? LoopColors.primaryBlue900 : LoopColors.textTertiary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? LoopColors.primaryBlue900 : LoopColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple scaffold wrapper (for screens that don't need navigation)
class MainScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const MainScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Just return the child - navigation is handled by ShellRoute
    return child;
  }
}
