import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:maps_toolkit/maps_toolkit.dart' as mt;
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/models/user_data.dart';

class LocationHelper {
  LocationPermission _permission = LocationPermission.unableToDetermine;
  LocationAccuracyStatus _accuracy = LocationAccuracyStatus.unknown;
  bool _serviceEnabled = false;
  GeneralAsyncCallback<loc.LocationData> onPositionUpdate;
  loc.Location locationService = loc.Location();

  LocationHelper({required this.onPositionUpdate});

  Future<bool> get serviceEnabled async {
    _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    return _serviceEnabled;
  }

  Future<bool> get hasPermissionWhileInUse async {
    _permission = await Geolocator.checkPermission();
    return (_permission == LocationPermission.whileInUse) ||
        (_permission == LocationPermission.always);
  }

  Future<bool> get hasPermissionAlways async {
    _permission = await Geolocator.checkPermission();
    return _permission == LocationPermission.always;
  }

  Future<bool> get hasPermissionPrecise async {
    _accuracy = await Geolocator.getLocationAccuracy();
    return _accuracy == LocationAccuracyStatus.precise;
  }

  Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<void> activateBackgroundLocation() async {
    bool enabled = await locationService.isBackgroundModeEnabled();

    if (!enabled) {
      await locationService.enableBackgroundMode();
    }
  }

  Future<void> startLocationService() async {
    DateTime lastUpdate = DateTime.now();
    List<loc.LocationData> recentLocations = [];

    locationService.onLocationChanged.listen((loc.LocationData location) {

      recentLocations.add(location);

      DateTime fiveMinutesAgo = DateTime.now().subtract(Duration(minutes: 5));

      if (fiveMinutesAgo.isAfter(lastUpdate)) {
        loc.LocationData avgLocation = getAverageLocation(locations: recentLocations);
        recentLocations = [];
        lastUpdate = DateTime.now();
        onPositionUpdate(avgLocation);
      }
    });
  }

  Future<loc.LocationData> getBackgroundLocation() async {
    loc.LocationData location = await locationService.getLocation();
    return location;
  }

  Future<void> requestLocationPermission() async {
    _permission = await Geolocator.checkPermission();

    if (_permission == LocationPermission.always ||
        _permission == LocationPermission.whileInUse) {
      return;
    }

    _permission = await Geolocator.requestPermission();
  }

  Future<void> openAppSettings() async {
    Geolocator.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    Geolocator.openLocationSettings();
  }

  bool userInClub({required UserData userData, required ClubData clubData}) {
    final userPoint =
        mt.LatLng(userData.lastPositionLat, userData.lastPositionLon);

    List<mt.LatLng> clubCorners = [];

    for (GeoPoint corner in clubData.corners) {
      clubCorners.add(mt.LatLng(corner.latitude, corner.longitude));
    }

    return mt.PolygonUtil.containsLocation(userPoint, clubCorners, true);
  }

  loc.LocationData getAverageLocation({required List<loc.LocationData> locations}) {

    double sumLat = 0;
    double sumLon = 0;

    for (loc.LocationData location in locations) {
      sumLat += location.latitude ?? 0;
      sumLon += location.longitude ?? 0;
    }

    double avgLat = sumLat / locations.length;
    double avgLon = sumLon / locations.length;

    loc.LocationData avgLocation = loc.LocationData.fromMap({
      'latitude': avgLat,
      'longitude': avgLon,
    });

    print(locations.length);
    print(avgLocation.latitude);
    print(avgLocation.longitude);

    return avgLocation;

  }
}
