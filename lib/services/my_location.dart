import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart'; // For placemarkFromCoordinates
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MyLocation extends StatefulWidget {
  const MyLocation({super.key});

  @override
  State<MyLocation> createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  String statusMessage = "Getting your location...";
  bool isLoading = true;

  // Reference point (could be last saved location)
  final LatLng referencePoint = LatLng(-26.2041, 28.0473); // Example: Johannesburg

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<String> _convertLocationToAddress(double lat, double lon) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
      if (placemarks.isNotEmpty) {
        return "${placemarks.first.locality}, ${placemarks.first.country}";
      }
    } catch (e) {
      print("Error converting location: $e");
    }
    return "Unknown location";
  }

  String _calculateDistance(LatLng from, LatLng to) {
    final Distance distance = Distance();
    double meters = distance.as(LengthUnit.Meter, from, to);

    if (meters >= 1000) {
      return "${(meters / 1000).toStringAsFixed(2)} km";
    } else {
      return "${meters.toStringAsFixed(0)} m";
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

      LatLng coords = LatLng(position.latitude, position.longitude);
      String address = await _convertLocationToAddress(coords.latitude, coords.longitude);
      String distance = _calculateDistance(referencePoint, coords);

      Navigator.pop(context, {
        'location': coords,
        'address': address,
        'distance': distance,
      });
    } catch (e) {
      _handleError("Failed to get location: $e");
    }
  }

  void _handleError(String message) {
    setState(() {
      isLoading = false;
      statusMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(statusMessage),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(statusMessage, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        statusMessage = "Retrying...";
                      });
                      _getCurrentLocation();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
      ),
    );
  }
}
