import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:math';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationService() {
    // Initialize timezone data
    tz.initializeTimeZones();
    _initializeNotifications();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> requestPermission() async {
    if (await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    ) ??
        false) {
      print('iOS Notification permission granted.');
    }

    if (await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    ) ??
        false) {
      print('macOS Notification permission granted.');
    }
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'nightview_channel',
      'nightview_notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show( // What is this TODO
      0,
      'Hello',
      'Would you like to continue?',
      platformChannelSpecifics,
      payload: 'custom_payload',
    );
  }

  Future<void> scheduleNotification({required int id, required String title, required String body, required DateTime scheduledDate}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'nightview_channel',
      'nightview_notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // To trigger daily at the same time
    );
  }

  void scheduleWeeklyNotifications() {
    List<String> messages = [
      "Er du klar til at erobre dansegulvet i nat?",
      "Har du planer om at tage på eventyr i byen i aften?",
      "Skal vi ud og lave ballade i nat?",
      "Bliver det en af de vilde aftener i byen i aften?",
      "Er det en af de aftener, hvor vi slår os løs?",
      "Skal vi ud og vise vores bedste moves i aften?",
      "Er du på vej ud for at gøre byen usikker i nat?",
      "Jeg kender en rigtig god bartender. Skal vi tage ud og få ham til at lave nogle specielle drinks til os?",
      "Vil du være min date i aften og lade mig vise dig hvordan man har det sjovt?",
      "Hvad siger du til at vi spilder ungdommen lidt i aften og ser hvor det bringer os hen?",
      "Er du klar til at lyse dansegulvet op i aften?",
      "Har du planer om at skabe minder i byen i nat?",
      "Er det en af de aftener, hvor vi giver den max gas?",
      "Skal vi ud og gøre natten vild og uforglemmelig?",
      "Er du parat til at indtage byen med stil?",
      "Bliver det en nat med masser af latter og dans?",
      "Er du klar til at erobre byen og have det sjovt?",
      "Skal vi ud og gøre natten til vores egen fest?",
      "Er det en af de aftener, hvor vi slipper alle hæmninger?",
      "Har du tænkt dig at tage på natteeventyr med os i aften?",
      "Er det i aften, vi gør gaderne usikre?",
      "Skal vi ud og skabe feststemning i nat?",
      "Er du klar til at gøre natten til noget særligt?",
      "Bliver det en af de aftener, hvor vi lever livet fuldt ud?",
      "Skal vi ud og feste som aldrig før i nat?",
      "Er du klar til at indtage nattelivet med os?",
      "Har du tænkt dig at gøre natten vild og uforglemmelig?",
      "Er du klar til at gøre dansegulvet til din scene i aften?",
      "Skal vi ud og få byen til at lyse op i nat?",
      "Er det i aften, vi går amok på dansegulvet?",
      "Har du tænkt dig at være festens midtpunkt i nat?",
      "Er du parat til en nat fyldt med grin og gode vibes?",
      "Er du klar til at tage byen med storm i aften?",
      "Er du klar til at skabe vilde minder i nat?",
      "Er du parat til at gøre natten til en fest uden lige?",
      "Skal vi ud og fyre den af på dansegulvet?",
      "Er du klar til at gøre byen usikker med os i nat?",
      "Har du planer om at tage på eventyr i nattelivet?",
      "Skal vi ud og erobre nattelivet i aften?",
      "Skal vi ud og lege rockstjerner i nat?",
      "Er du klar til at danse, som om vi har to venstre fødder?",
      "Er det i aften, vi laver nogle episke Snapchat-historier?",
      "Er du klar til at være byens skøreste festabe i nat?",
      "Skal vi ud og lave nogle legendariske fejltrin på dansegulvet?",
      "Skal vi ud og se, hvor mange nye venner vi kan få i nat?",
      "Er du klar til at tage en tur i festligaen i nat?",
      "Ud i aften?",
      "Skal vi?",
      "Ud og fyre den af?",
      "Druk?",
      "Skal vi ud?",
      "Klubben?",
      "Er du klar til at skabe ravage i byen i aften?",
      "Skal vi ud og skabe lidt festlig uro i byen?",
      "Skal vi ud og ryste byen op?",
      "Er det tid til at lave noget ballade i nat?",
      "Bliver du en del af nattelivet i dag?",
      "Har du planer om at gå ud i aften?",
      "Er du klar til en bytur i dag?",
    ];

    final rng = Random();
    for (int i = 0; i < 3; i++) { // Thursday, Friday, Saturday
      for (int j = 0; j < 10; j++) { // For 10 different messages
        final int weekday = i + 4; // 4=Thursday, 5=Friday, 6=Saturday
        final DateTime now = DateTime.now();
        final DateTime scheduledDate = DateTime(now.year, now.month, now.day, 15).add(Duration(days: (weekday - now.weekday) % 7));

        scheduleNotification(
          id: i * 10 + j,
          title: 'Event Reminder',
          body: messages[rng.nextInt(messages.length)],
          scheduledDate: scheduledDate,
        );
      }
    }
  }

}