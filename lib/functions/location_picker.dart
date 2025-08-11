import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationData {
  final double latitude;
  final double longitude;
  final String address;
  final String city;
  final String country;
  final String? ipAddress;
  final DateTime timestamp;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.country,
    this.ipAddress,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'city': city,
      'country': country,
      'ipAddress': ipAddress,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      country: map['country'] ?? '',
      ipAddress: map['ipAddress'],
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class LocationService {
  static const String _ipApiUrl = 'http://ip-api.com/json/';

  /// Check if location permission is granted
  static Future<bool> _hasLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }

  /// Get user's current location using GPS
  static Future<LocationData?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      // Check permissions
      bool hasPermission = await _hasLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permissions are denied.');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );

      // Get address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;
      String address = '${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}';
      
      // Get IP address
      String? ipAddress = await _getIPAddress();

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address.trim().replaceAll(RegExp(r'^,\s*'), ''),
        city: place.locality ?? place.administrativeArea ?? '',
        country: place.country ?? '',
        ipAddress: ipAddress,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      print('Error getting current location: $e');
      
      // Fallback to IP-based location
      return await _getLocationFromIP();
    }
  }

  /// Get location from IP address as fallback
  static Future<LocationData?> _getLocationFromIP() async {
    try {
      final response = await http.get(Uri.parse(_ipApiUrl)).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'success') {
          return LocationData(
            latitude: data['lat']?.toDouble() ?? 0.0,
            longitude: data['lon']?.toDouble() ?? 0.0,
            address: '${data['city'] ?? ''}, ${data['regionName'] ?? ''}, ${data['country'] ?? ''}',
            city: data['city'] ?? '',
            country: data['country'] ?? '',
            ipAddress: data['query'],
            timestamp: DateTime.now(),
          );
        }
      }
    } catch (e) {
      print('Error getting IP location: $e');
    }
    return null;
  }

  /// Get current IP address
  static Future<String?> _getIPAddress() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org')).timeout(
        const Duration(seconds: 5),
      );
      if (response.statusCode == 200) {
        return response.body.trim();
      }
    } catch (e) {
      print('Error getting IP address: $e');
    }
    return null;
  }

  /// Calculate distance between two points in kilometers
  static double calculateDistance(
    double lat1, double lon1, 
    double lat2, double lon2
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2) / 1000;
  }

  /// Check if user has moved significantly (more than 1km)
  static bool hasUserMoved(LocationData? oldLocation, LocationData newLocation) {
    if (oldLocation == null) return true;
    
    double distance = calculateDistance(
      oldLocation.latitude, oldLocation.longitude,
      newLocation.latitude, newLocation.longitude,
    );
    
    return distance > 1.0; // Consider moved if more than 1km
  }

  /// Open location settings
  static Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  /// Open app settings
  static Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }
}