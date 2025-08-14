import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MyLocation extends StatefulWidget {
  const MyLocation({super.key});

  @override
  State<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  String statusMessage = "Getting your location...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    try {
      setState(() {
        statusMessage = "Checking location services...";
        isLoading = true;
      });

      // Check if location services are enabled first
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('📍 Location services enabled: $serviceEnabled');
      
      if (!serviceEnabled) {
        setState(() {
          statusMessage = "Location services are disabled. Opening settings...";
        });
        
        // Try to open location settings
        bool opened = await Geolocator.openLocationSettings();
        print('📍 Opened location settings: $opened');
        
        // Wait a moment and check again
        await Future.delayed(const Duration(seconds: 2));
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        
        if (!serviceEnabled) {
          _handleError("Please enable location services in your device settings and try again.");
          return;
        }
      }

      setState(() {
        statusMessage = "Requesting location permission...";
      });

      // Request location permission using Geolocator
      LocationPermission permission = await Geolocator.checkPermission();
      print('📍 Current permission status: $permission');
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print('📍 Permission after request: $permission');
        
        if (permission == LocationPermission.denied) {
          _handleError("Location permission is required to find nearby matches. Please allow location access.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _handleError("Location permission is permanently denied. Please enable it in your device settings.");
        _showPermissionDialog();
        return;
      }

      if (permission == LocationPermission.whileInUse || 
          permission == LocationPermission.always) {
        await _getCurrentLocation();
      } else {
        _handleError("Location permission is required to continue.");
      }

    } catch (e) {
      print('📍 Permission request error: $e');
      _handleError("Failed to request location permission: ${e.toString()}");
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _handleError("Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _handleError("Location permissions are denied.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _handleError("Location permissions are permanently denied.");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get detailed address info
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude, 
        position.longitude
      );
      
      String address = await _convertLocationToAddress(
        position.latitude, 
        position.longitude
      );
      
      // Extract city and country separately
      String city = 'Unknown City';
      String country = 'Unknown Country';
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        city = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? 'Unknown City';
        country = place.country ?? 'Unknown Country';
      }

      // Return Position data instead of LatLng
      Navigator.pop(context, {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': address,
        'city': city,
        'country': country,
        'ipAddress': '', // Not available from GPS
      });
    } catch (e) {
      _handleError("Failed to get location: $e");
    }
  }

  Future<String> _convertLocationToAddress(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        
        List<String> addressParts = [];
        
        if (place.street?.isNotEmpty == true) addressParts.add(place.street!);
        if (place.locality?.isNotEmpty == true) addressParts.add(place.locality!);
        if (place.administrativeArea?.isNotEmpty == true) addressParts.add(place.administrativeArea!);
        if (place.country?.isNotEmpty == true) addressParts.add(place.country!);
        
        String fullAddress = addressParts.isNotEmpty ? addressParts.join(', ') : 'Unknown location';
        print('📍 Converted address: $fullAddress');
        return fullAddress;
      }
    } catch (e) {
      print("📍 Error converting location: $e");
    }
    return "Unknown location";
  }

  void _handleError(String message) {
    setState(() {
      statusMessage = message;
      isLoading = false;
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'This app needs location permission to find nearby matches. Please enable location access in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Close the location screen too
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await Geolocator.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B46C1),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading) ...[
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  const SizedBox(height: 24),
                ],
                Icon(
                  isLoading ? Icons.location_searching : Icons.location_off,
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(height: 24),
                Text(
                  statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!isLoading) ...[
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _requestLocationPermission();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6B46C1),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Try Again',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: const Text(
                      'Skip for Now',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}