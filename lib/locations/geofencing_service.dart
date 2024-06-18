import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart' as loc;
import 'package:nightview/locations/geofence_corner.dart';
import 'package:nightview/locations/geofence_center.dart';
import 'package:nightview/locations/geofence.dart';

class GeofencingService {
  static const fetchBackground = "fetchBackground";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<Geofence> geofences = [];

  GeofencingService() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initNotifications();
  }

  void _initNotifications() {
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      if (task == fetchBackground) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        await _loadGeofencesIfNeeded();
        _checkGeofence(position);
      }
      return Future.value(true);
    });
  }

  void initializeWorkManager() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  void registerPeriodicTask() {
    Workmanager().registerPeriodicTask(
      "1",
      fetchBackground,
      frequency: const Duration(minutes: 20),
    );
  }

  Future<void> _loadGeofencesIfNeeded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? lastUpdate = prefs.getInt('last_geofence_update');
    int now = DateTime.now().millisecondsSinceEpoch;

    // Check if 24 hours have passed since the last update
    if (lastUpdate == null || now - lastUpdate > 86400000) {
      await _loadGeofencesFromDatabase();
      prefs.setInt('last_geofence_update', now);
    }
  }

  Future<void> _loadGeofencesFromDatabase() async {
    geofences.clear();
    CollectionReference clubData = FirebaseFirestore.instance.collection('club_data');
    QuerySnapshot querySnapshot = await clubData.get();
    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      List corners = data['corners'];
      if (corners != null && corners.length >= 4) {
        geofences.add(Geofence(
          corners: corners.map((corner) => GeofenceCorner.fromMap(corner)).toList(),
          center: _calculateCenter(corners),
        ));
      }
    }
  }

  GeofenceCenter _calculateCenter(List corners) {
    double latSum = 0;
    double lonSum = 0;
    for (var corner in corners) {
      latSum += corner['latitude'];
      lonSum += corner['longitude'];
    }
    return GeofenceCenter(
      latitude: latSum / corners.length,
      longitude: lonSum / corners.length,
    );
  }

  void _checkGeofence(Position position) {
    for (var geofence in geofences) {
      double distance = Geolocator.distanceBetween(
          position.latitude, position.longitude,
          geofence.center.latitude, geofence.center.longitude);

      if (distance <= geofence.radius) {
        _showNotification("Du er ankommet på klubben", "Hav en skøn aften!");
      } else {
        _showNotification("Du har forladt klubben", "Kom sikkert hjem.");
      }
    }
  }

  Future<void> _showNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name, your channel description',
        importance: Importance.max, priority: Priority.high, showWhen: false);
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics, payload: 'item id 2');
  }


}