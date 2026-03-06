import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/router/app_router.dart';
import '../../../../shared/constants/app_constants.dart';

/// Types of permissions we request
enum PermissionType { location, notification }

/// Permission request screen - reusable for location and notifications
class PermissionsScreen extends StatefulWidget {
  final PermissionType type;

  const PermissionsScreen({
    super.key,
    required this.type,
  });

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _isLoading = false;

  String get _title {
    switch (widget.type) {
      case PermissionType.location:
        return 'Enable Location';
      case PermissionType.notification:
        return 'Stay Updated';
    }
  }

  String get _description {
    switch (widget.type) {
      case PermissionType.location:
        return 'We need your location to show activities and events happening near you in Bangalore';
      case PermissionType.notification:
        return 'Get notified when someone joins your activity or sends you a message';
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case PermissionType.location:
        return Icons.location_on_outlined;
      case PermissionType.notification:
        return Icons.notifications_outlined;
    }
  }

  Future<void> _requestPermission() async {
    setState(() => _isLoading = true);

    try {
      PermissionStatus status;

      switch (widget.type) {
        case PermissionType.location:
          status = await Permission.location.request();
          await _savePermissionAsked(AppConstants.keyLocationPermissionAsked);
          break;
        case PermissionType.notification:
          status = await Permission.notification.request();
          await _savePermissionAsked(
              AppConstants.keyNotificationPermissionAsked);
          break;
      }

      if (mounted) {
        if (status.isGranted || status.isLimited) {
          _navigateNext();
        } else if (status.isPermanentlyDenied) {
          _showSettingsDialog();
        } else {
          _navigateNext();
        }
      }
    } catch (e) {
      if (mounted) {
        _navigateNext();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _savePermissionAsked(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  void _skip() {
    _navigateNext();
  }

  void _navigateNext() {
    switch (widget.type) {
      case PermissionType.location:
        context.go(AppRoutes.notificationPermission);
        break;
      case PermissionType.notification:
        context.go(AppRoutes.interests);
        break;
    }
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(
          'Please enable ${widget.type == PermissionType.location ? 'location' : 'notifications'} in your device settings to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateNext();
            },
            child: const Text('Skip'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _skip,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Icon
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primary.withValues(alpha: 0.1),
                      colorScheme.secondary.withValues(alpha: 0.1),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _icon,
                  size: 80,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 48),

              // Title
              Text(
                _title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                _description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 3),

              // Enable button
              FilledButton(
                onPressed: _isLoading ? null : _requestPermission,
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Enable'),
              ),
              const SizedBox(height: 12),

              // Skip button below
              TextButton(
                onPressed: _skip,
                child: const Text('Maybe Later'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
