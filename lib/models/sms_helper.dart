

import 'package:url_launcher/url_launcher.dart';

class SMSHelper {

  static Future<bool> launchSMS({required String phoneNumber, required String message}) async {

    final uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {
        'body': message,
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    } else {
      return false;
    }

  }

}