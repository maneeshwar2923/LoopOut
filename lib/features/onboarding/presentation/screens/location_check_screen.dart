import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/loop_colors.dart';
import '../../../../shared/constants/app_constants.dart';

/// Location check screen - verifies user is in Bangalore
class LocationCheckScreen extends StatefulWidget {
  const LocationCheckScreen({super.key});

  @override
  State<LocationCheckScreen> createState() => _LocationCheckScreenState();
}

class _LocationCheckScreenState extends State<LocationCheckScreen> {
  bool _isLoading = true;
  bool _isInBangalore = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _isInBangalore = false;
          _errorMessage = 'Location services are disabled';
        });
        return;
      }

      // Check permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _isInBangalore = false;
            _errorMessage = 'Location permission denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _isInBangalore = false;
          _errorMessage = 'Location permission permanently denied';
        });
        return;
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low, // Low accuracy is faster and uses less battery
          timeLimit: Duration(seconds: 10),
        ),
      );

      // Calculate distance to Bangalore center
      final distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        AppConstants.bangaloreLatitude,
        AppConstants.bangaloreLongitude,
      );

      final distanceInKm = distanceInMeters / 1000;
      final isInBangalore = distanceInKm <= AppConstants.bangaloreRadiusKm;

      setState(() {
        _isLoading = false;
        _isInBangalore = isInBangalore;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isInBangalore = false;
        _errorMessage = 'Could not determine location';
      });
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);

    if (mounted) {
      context.go(AppRoutes.home);
    }
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
              const Spacer(flex: 2),

              if (_isLoading) ...[
                // Loading state
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  'Checking your location...',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ] else if (_isInBangalore) ...[
                // In Bangalore - success
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: LoopColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    size: 60,
                    color: LoopColors.success,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'You\'re in Bangalore!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Great! You have full access to all activities and events in your area.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                // Not in Bangalore
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_city_outlined,
                    size: 60,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Coming Soon to Your City!',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'LoopOut is currently available only in Bangalore. We\'re expanding soon!',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],

              const Spacer(flex: 3),

              // Action buttons
              if (!_isLoading) ...[
                if (_isInBangalore) ...[
                  FilledButton(
                    onPressed: _completeOnboarding,
                    child: const Text('Let\'s Go!'),
                  ),
                ] else ...[
                  // Notify me button
                  FilledButton(
                    onPressed: () {
                      // TODO: Add to waitlist
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('We\'ll notify you when we launch in your city!'),
                        ),
                      );
                    },
                    child: const Text('Notify Me When Available'),
                  ),
                  const SizedBox(height: 12),
                  // Continue anyway (soft check)
                  OutlinedButton(
                    onPressed: _completeOnboarding,
                    child: const Text('Continue Anyway'),
                  ),
                ],
                const SizedBox(height: 12),
                // Retry location check
                if (!_isInBangalore)
                  TextButton(
                    onPressed: _checkLocation,
                    child: const Text('Check Location Again'),
                  ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
