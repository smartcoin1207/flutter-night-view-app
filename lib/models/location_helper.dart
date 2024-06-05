import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:maps_toolkit/maps_toolkit.dart' as mt;
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/models/location_data.dart';
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
    return (_permission == LocationPermission.whileInUse) || (_permission == LocationPermission.always);
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
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  Future<void> activateBackgroundLocation() async {
    bool enabled = await locationService.isBackgroundModeEnabled();

    if (!enabled) {
      await locationService.enableBackgroundMode();
    }
  }

  Future<void> startBackgroundLocationService() async {
    DateTime lastUpdate = DateTime.now();

    locationService.onLocationChanged.listen((loc.LocationData location) {
      DateTime threshold = DateTime.now().subtract(Duration(minutes: 10));
      // DateTime threshold = DateTime.now().subtract(Duration(seconds: 20));

      if (threshold.isAfter(lastUpdate)) {
        lastUpdate = DateTime.now();
        onPositionUpdate(location);
      }
    });
  }


  Future<void> startLocationService() async {

    Timer.periodic(const Duration(minutes: 10), (timer) async {
      try {
        loc.LocationData location = await locationService.getLocation();
        onPositionUpdate(location);
        print("Tried to upload");
      } catch (e) {
        print('Could not get location');
      }
    });
  }

  Future<loc.LocationData> getBackgroundLocation() async {
    loc.LocationData location = await locationService.getLocation();
    return location;
  }

  Future<void> requestLocationPermission() async {
    _permission = await Geolocator.checkPermission();

    if (_permission == LocationPermission.always || _permission == LocationPermission.whileInUse) {
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
    final userPoint = mt.LatLng(userData.lastPositionLat, userData.lastPositionLon);

    List<mt.LatLng> clubCorners = [];

    for (GeoPoint corner in clubData.corners) {
      clubCorners.add(mt.LatLng(corner.latitude, corner.longitude));
    }

    return mt.PolygonUtil.containsLocation(userPoint, clubCorners, true);
  }

  bool locationInClub({required loc.LocationData location, required ClubData clubData}) {
    if (location.latitude == null || location.longitude == null) {
      print('Position is null');
      return false;
    }

    final locationPoint = mt.LatLng(location.latitude!, location.longitude!);

    List<mt.LatLng> clubCorners = [];

    for (GeoPoint corner in clubData.corners) {
      clubCorners.add(mt.LatLng(corner.latitude, corner.longitude));
    }

    return mt.PolygonUtil.containsLocation(locationPoint, clubCorners, true);
  }

  Future<LocationData?> getLastPositionOfUser(String userId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snap =
          await firestore.collection('location_data').where('user_id', isEqualTo: userId).where('latest', isEqualTo: true).limit(1).get();
      QueryDocumentSnapshot<Map<String, dynamic>> doc = snap.docs.first;
      return LocationData(
        userId: doc.get('user_id'),
        clubId: doc.get('club_id'),
        private: doc.get('private'),
        timestamp: doc.get('timestamp'),
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> uploadLocationData(LocationData locationData) async {
    final firestore = FirebaseFirestore.instance;

    await _cancelLatestLocationData(locationData.userId);

    try {
      await firestore.collection('location_data').add({
        'user_id': locationData.userId,
        'club_id': locationData.clubId,
        'private': locationData.private,
        'timestamp': locationData.timestamp,
        'latest': true,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _cancelLatestLocationData(String userId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snap =
          await firestore.collection('location_data').where('user_id', isEqualTo: userId).where('latest', isEqualTo: true).get();
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snap.docs) {
        await firestore.collection('location_data').doc(doc.id).set({'latest': false}, SetOptions(merge: true));
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // loc.LocationData getAverageLocation({required List<loc.LocationData> locations}) {
  //
  //   double sumLat = 0;
  //   double sumLon = 0;
  //
  //   for (loc.LocationData location in locations) {
  //     sumLat += location.latitude ?? 0;
  //     sumLon += location.longitude ?? 0;
  //   }
  //
  //   double avgLat = sumLat / locations.length;
  //   double avgLon = sumLon / locations.length;
  //
  //   loc.LocationData avgLocation = loc.LocationData.fromMap({
  //     'latitude': avgLat,
  //     'longitude': avgLon,
  //   });
  //
  //   print(locations.length);
  //   print(avgLocation.latitude);
  //   print(avgLocation.longitude);
  //
  //   return avgLocation;
  //
  // }

  Future<void> deleteDataAssociatedTo(String userId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snap = await firestore.collection('location_data').where('user_id', isEqualTo: userId).get();
      for (DocumentSnapshot doc in snap.docs) {
        doc.reference.delete();
      }
    } catch (e) {
      print(e);
    }
  }
}