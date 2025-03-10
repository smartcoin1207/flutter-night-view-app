import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationService {
  static Future<LatLng?> getUserLocation() async {
    try {
      // Step 1: Ensure location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('❌ Location services are disabled');
        return LatLng(55.6761, 12.5683); // Fallback to Copenhagen
      }

      // Step 2: Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      print('📌 Initial permission state: $permission');

      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        print('📌 Permission after request: $permission');

        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          print('❌ Location permission denied');
          return LatLng(55.6761, 12.5683); // Fallback
        }
      }

      // Step 3: Get location with a proper timeout
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          // No timeLimit here—handle timeout separately
        ),
      ).timeout(Duration(seconds: 5), onTimeout: () {
        print('⏳ getCurrentPosition timed out');
        throw TimeoutException('Location fetch timed out');
      });

      print('✅ Location fetched: ${position.latitude}, ${position.longitude}');
      return LatLng(position.latitude, position.longitude);

    } catch (e, stackTrace) {
      print('❌ Error fetching location (${e.runtimeType}): $e\nStackTrace: $stackTrace');
      return LatLng(55.6761, 12.5683); // Default to Copenhagen
    }
  }
}
