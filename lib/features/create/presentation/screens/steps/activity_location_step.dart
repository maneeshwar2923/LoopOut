import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../shared/constants/app_constants.dart';
import '../../../../../core/theme/loop_colors.dart';
import '../../../../../core/theme/loop_map_style.dart';
import '../../../../../core/services/places_service.dart';
import '../../../providers/create_activity_provider.dart';

class ActivityLocationStep extends ConsumerStatefulWidget {
  const ActivityLocationStep({super.key});

  @override
  ConsumerState<ActivityLocationStep> createState() => _ActivityLocationStepState();
}

class _ActivityLocationStepState extends ConsumerState<ActivityLocationStep> {
  GoogleMapController? _mapController;
  late TextEditingController _locationController;
  Set<Marker> _markers = {};
  bool _hasLocationPermission = false;
  bool _isCheckingPermission = true;
  
  // Autocomplete state
  List<PlacePrediction> _predictions = [];
  bool _isSearching = false;
  bool _showSuggestions = false;
  Timer? _debounceTimer;
  
  // Current map center for location bias
  LatLng _mapCenter = const LatLng(AppConstants.bangaloreLatitude, AppConstants.bangaloreLongitude);
  
  @override
  void initState() {
    super.initState();
    final state = ref.read(createActivityNotifierProvider);
    _locationController = TextEditingController(text: state.locationName);
    if (state.location != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('selected'),
          position: LatLng(state.location!.latitude, state.location!.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
      _mapCenter = LatLng(state.location!.latitude, state.location!.longitude);
    }
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      setState(() {
        _hasLocationPermission = permission == LocationPermission.always || 
                                  permission == LocationPermission.whileInUse;
        _isCheckingPermission = false;
      });
    } catch (e) {
      setState(() {
        _hasLocationPermission = false;
        _isCheckingPermission = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    
    if (query.length < 2) {
      setState(() {
        _predictions = [];
        _showSuggestions = false;
      });
      return;
    }
    
    _debounceTimer = Timer(const Duration(milliseconds: 400), () async {
      setState(() => _isSearching = true);
      
      final results = await PlacesService.autocomplete(
        query,
        latitude: _mapCenter.latitude,
        longitude: _mapCenter.longitude,
      );
      
      if (mounted) {
        setState(() {
          _predictions = results;
          _showSuggestions = results.isNotEmpty;
          _isSearching = false;
        });
      }
    });
  }

  Future<void> _onPredictionSelected(PlacePrediction prediction) async {
    setState(() {
      _showSuggestions = false;
      _isSearching = true;
    });
    
    final details = await PlacesService.getPlaceDetails(prediction.placeId);
    
    if (details != null && mounted) {
      final notifier = ref.read(createActivityNotifierProvider.notifier);
      
      _locationController.text = prediction.mainText;
      
      final pos = LatLng(details.location.latitude, details.location.longitude);
      
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('selected'),
            position: pos,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
          ),
        };
        _mapCenter = pos;
        _isSearching = false;
      });
      
      notifier.setLocation(details.location, prediction.mainText);
      
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(pos, 16));
    } else {
      setState(() => _isSearching = false);
    }
  }

  Future<void> _onMapTap(LatLng pos) async {
    // Update marker immediately for responsiveness
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected'),
          position: pos,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      };
      _mapCenter = pos;
    });
    
    final notifier = ref.read(createActivityNotifierProvider.notifier);
    
    // Reverse geocode to get address
    final result = await PlacesService.reverseGeocode(pos.latitude, pos.longitude);
    
    if (result != null && mounted) {
      _locationController.text = result.formattedAddress;
      notifier.setLocation(result.location, result.formattedAddress);
    } else {
      // Fallback if reverse geocode fails
      notifier.setLocation(
        GeoPoint(pos.latitude, pos.longitude),
        'Selected Location',
      );
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'Where is it\nhappening?',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.1, end: 0),
              
              const SizedBox(height: 24),
              
              // Search field with autocomplete
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SEARCH LOCATION',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: LoopColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _locationController,
                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: 'Search for a place...',
                          hintStyle: TextStyle(color: LoopColors.textTertiary),
                          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                          suffixIcon: _isSearching 
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                              )
                            : _locationController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _locationController.clear();
                                    setState(() {
                                      _predictions = [];
                                      _showSuggestions = false;
                                    });
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: LoopColors.surfaceBlue100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: colorScheme.primary, width: 2),
                          ),
                        ),
                        onChanged: _onSearchChanged,
                        onTap: () {
                          if (_predictions.isNotEmpty) {
                            setState(() => _showSuggestions = true);
                          }
                        },
                      ),
                    ],
                  ),
                  
                  // Suggestions dropdown
                  if (_showSuggestions && _predictions.isNotEmpty)
                    Positioned(
                      top: 80,
                      left: 0,
                      right: 0,
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: LoopColors.borderSubtle),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _predictions.length,
                            itemBuilder: (context, index) {
                              final prediction = _predictions[index];
                              return ListTile(
                                leading: Icon(Icons.place, color: colorScheme.primary),
                                title: Text(
                                  prediction.mainText,
                                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  prediction.secondaryText,
                                  style: theme.textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () => _onPredictionSelected(prediction),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ).animate().fadeIn(delay: 200.ms),
              
              const SizedBox(height: 8),
              Text(
                'Or tap on the map to select a location',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: LoopColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        
        // Map
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: LoopColors.borderSubtle),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: _isCheckingPermission
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _mapCenter,
                      zoom: 14,
                    ),
                    markers: _markers,
                    onMapCreated: (controller) {
                      _mapController = controller;
                      _mapController?.setMapStyle(LoopMapStyle.lightStyle);
                    },
                    onCameraMove: (position) {
                      _mapCenter = position.target;
                    },
                    myLocationEnabled: _hasLocationPermission,
                    myLocationButtonEnabled: _hasLocationPermission,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    onTap: _onMapTap,
                  ),
          ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
        ),
      ],
    );
  }
}
