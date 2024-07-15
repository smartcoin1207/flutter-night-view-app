import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../locations/geofencing_service.dart';
import '../models/notification_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class Initializator {
  void initializeNeededTasks() async {
    GeofencingService geofencingService = GeofencingService();
    geofencingService.initializeWorkManager();
    geofencingService.registerPeriodicTask();

    NotificationService notificationService = NotificationService();
    notificationService;

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        // Handle notification tapped logic here
        if (notificationResponse.payload != null) {
          debugPrint('notification payload: ${notificationResponse.payload}');
          // You can navigate to specific screen here based on payload
        }
      },
    );
  }

}