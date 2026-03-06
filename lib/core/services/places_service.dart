import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

/// Google Places API service for autocomplete and reverse geocoding
/// Uses HTTP API directly since we have the API key configured
class PlacesService {
  // Use the same API key configured for Google Maps
  // In production, this should be fetched from a secure source
  static const String _apiKey = 'AIzaSyCbuhvl0cecgpfRjn-h4ArSVxDkWIbidaA';
  
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api';
  
  /// Autocomplete search for places
  /// Returns list of predictions with place_id, description, and structured formatting
  static Future<List<PlacePrediction>> autocomplete(
    String input, {
    double? latitude,
    double? longitude,
    int radiusMeters = 50000, // 50km radius
  }) async {
    if (input.trim().isEmpty) return [];
    
    try {
      final params = {
        'input': input,
        'key': _apiKey,
        'components': 'country:in', // Restrict to India
        'types': 'geocode|establishment',
      };
      
      // Add location bias if provided
      if (latitude != null && longitude != null) {
        params['location'] = '$latitude,$longitude';
        params['radius'] = radiusMeters.toString();
      }
      
      final uri = Uri.parse('$_baseUrl/place/autocomplete/json').replace(queryParameters: params);
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final predictions = data['predictions'] as List<dynamic>;
          return predictions
              .map((p) => PlacePrediction.fromJson(p))
              .toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('Places autocomplete error: $e');
      return [];
    }
  }
  
  /// Get place details including lat/lng from place_id
  static Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final uri = Uri.parse('$_baseUrl/place/details/json').replace(
        queryParameters: {
          'place_id': placeId,
          'fields': 'geometry,formatted_address,name',
          'key': _apiKey,
        },
      );
      
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          return PlaceDetails.fromJson(data['result']);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Place details error: $e');
      return null;
    }
  }
  
  /// Reverse geocode a lat/lng to get address
  static Future<ReverseGeocodeResult?> reverseGeocode(double latitude, double longitude) async {
    try {
      final uri = Uri.parse('$_baseUrl/geocode/json').replace(
        queryParameters: {
          'latlng': '$latitude,$longitude',
          'key': _apiKey,
          'result_type': 'street_address|route|locality|sublocality',
        },
      );
      
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && (data['results'] as List).isNotEmpty) {
          final result = data['results'][0];
          return ReverseGeocodeResult(
            formattedAddress: result['formatted_address'] ?? '',
            placeId: result['place_id'] ?? '',
            location: GeoPoint(latitude, longitude),
          );
        }
      }
      return null;
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
      return null;
    }
  }
}

/// Place prediction from autocomplete
class PlacePrediction {
  final String placeId;
  final String description;
  final String mainText;
  final String secondaryText;
  
  const PlacePrediction({
    required this.placeId,
    required this.description,
    required this.mainText,
    required this.secondaryText,
  });
  
  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    final structuredFormatting = json['structured_formatting'] ?? {};
    return PlacePrediction(
      placeId: json['place_id'] ?? '',
      description: json['description'] ?? '',
      mainText: structuredFormatting['main_text'] ?? '',
      secondaryText: structuredFormatting['secondary_text'] ?? '',
    );
  }
}

/// Place details with coordinates
class PlaceDetails {
  final String name;
  final String formattedAddress;
  final GeoPoint location;
  
  const PlaceDetails({
    required this.name,
    required this.formattedAddress,
    required this.location,
  });
  
  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'] ?? {};
    final loc = geometry['location'] ?? {};
    return PlaceDetails(
      name: json['name'] ?? '',
      formattedAddress: json['formatted_address'] ?? '',
      location: GeoPoint(
        (loc['lat'] as num?)?.toDouble() ?? 0,
        (loc['lng'] as num?)?.toDouble() ?? 0,
      ),
    );
  }
}

/// Result from reverse geocoding
class ReverseGeocodeResult {
  final String formattedAddress;
  final String placeId;
  final GeoPoint location;
  
  const ReverseGeocodeResult({
    required this.formattedAddress,
    required this.placeId,
    required this.location,
  });
}
