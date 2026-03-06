import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/repositories/activity_repository.dart';
import '../../../../core/models/activity_model.dart';
import '../../../../shared/constants/app_constants.dart';
import '../../../../shared/widgets/app_shell.dart';

/// Map view screen showing activities on a map
class MapViewScreen extends ConsumerStatefulWidget {
  const MapViewScreen({super.key});

  @override
  ConsumerState<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends ConsumerState<MapViewScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  ActivityModel? _selectedActivity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activitiesAsync = ref.watch(filteredActivitiesProvider);

    return MainScaffold(
      currentIndex: 0,
      child: Stack(
        children: [
          // Map
          RepaintBoundary(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(
                  AppConstants.bangaloreLatitude,
                  AppConstants.bangaloreLongitude,
                ),
                zoom: 12,
              ),
              markers: _markers,
              onMapCreated: (controller) {
                _mapController = controller;
                _mapController?.setMapStyle(_mapStyle);
                _loadMarkers();
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
            ),
          ),

          // Top bar (Glassmorphic Search)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            child: Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                ),
                const SizedBox(width: 12),

                // Search bar
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: colorScheme.primary, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Search areas...',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),

          // Side Controls
          Positioned(
            right: 20,
            bottom: 120,
            child: Column(
              children: [
                _buildMapAction(
                  icon: Icons.my_location,
                  onTap: _goToCurrentLocation,
                ),
                const SizedBox(height: 12),
                _buildMapAction(
                  icon: Icons.tune,
                  onTap: () => _showFilters(context),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.2, end: 0),

          // List Toggle
          Positioned(
            left: 20,
            bottom: 120,
            child: GestureDetector(
              onTap: () => context.go('/home'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.format_list_bulleted, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'LIST',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2, end: 0),

          // Selected activity card
          if (_selectedActivity != null)
            Positioned(
              left: 20,
              right: 20,
              bottom: 120,
              child: _buildActivityCard(_selectedActivity!),
            ).animate().slideY(begin: 1, end: 0, curve: Curves.easeOutQuart),
        ],
      ),
    );
  }

  Widget _buildMapAction({required IconData icon, required VoidCallback onTap}) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        ),
        child: Icon(icon, size: 22, color: colorScheme.primary),
      ),
    );
  }

  static const String _mapStyle = '''
[
  { "elementType": "geometry", "stylers": [{ "color": "#0A0A0B" }] },
  { "elementType": "labels.text.fill", "stylers": [{ "color": "#A1A1AA" }] },
  { "elementType": "labels.text.stroke", "stylers": [{ "color": "#18181B" }] },
  { "featureType": "water", "elementType": "geometry", "stylers": [{ "color": "#000000" }] },
  { "featureType": "road", "elementType": "geometry", "stylers": [{ "color": "#18181B" }] },
  { "featureType": "poi", "stylers": [{ "visibility": "off" }] }
]
''';

  void _loadMarkers() {
    final activitiesAsync = ref.read(filteredActivitiesProvider);
    activitiesAsync.whenData((activities) {
      final markers = activities.map((activity) {
        return Marker(
          markerId: MarkerId(activity.id),
          position: LatLng(
            activity.location.latitude,
            activity.location.longitude,
          ),
          onTap: () {
            setState(() => _selectedActivity = activity);
          },
        );
      }).toSet();

      setState(() => _markers = markers);
    });
  }

  Widget _buildActivityCard(ActivityModel activity) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 40,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: activity.imageUrl != null
                      ? Image.network(activity.imageUrl!, fit: BoxFit.cover)
                      : Container(color: colorScheme.primary.withValues(alpha: 0.1)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activity.title,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.locationName,
                      style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${activity.participants.length}/${activity.capacity} JOINED',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => setState(() => _selectedActivity = null),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.push('/activity/${activity.id}'),
              child: const Text('VIEW DETAILS'),
            ),
          ),
        ],
      ),
    );
  }

  void _goToCurrentLocation() async {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        const LatLng(
          AppConstants.bangaloreLatitude,
          AppConstants.bangaloreLongitude,
        ),
        15,
      ),
    );
  }

  void _showFilters(BuildContext context) {
     // Implementation remains similar but with updated styling
  }
}
