import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'nightview_channel',
    'nightview_notifications',
    description: 'Used for nightview notifications.',
    importance: Importance.defaultImportance,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> backgroundHandler(RemoteMessage msg) async {
    print('title: ${msg.notification?.title}');
    print('body: ${msg.notification?.body}');
    print('payload: ${msg.data}');
  }

  void handleMessage(RemoteMessage? msg) {
    if (msg == null) return;

    // navigatorKey.currentState?.value(9){
    // }

    return;
  }

  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/logo_icon',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future<void> initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/logo_icon');
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        if (notificationResponse.payload != null) {
          final message = RemoteMessage.fromMap(jsonDecode(notificationResponse.payload!));
          handleMessage(message);
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }


  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    await initPushNotification();
    await initLocalNotifications();
  }
}
