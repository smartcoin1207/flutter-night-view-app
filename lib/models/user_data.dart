import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/values.dart';

class UserData {
  final String id;
  final String firstName;
  final String lastName;
  final String mail;
  final String phone;
  final int birthdayDay;
  final int birthdayMonth;
  final int birthdayYear;
  final double lastPositionLat;
  final double lastPositionLon;
  final DateTime lastPositionTime;
  final PartyStatus partyStatus;
  final DateTime partyStatusTime;

  UserData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mail,
    required this.phone,
    required this.birthdayDay,
    required this.birthdayMonth,
    required this.birthdayYear,
    required this.lastPositionLat,
    required this.lastPositionLon,
    required this.lastPositionTime,
    required this.partyStatus,
    required this.partyStatusTime,
  });

  bool answeredStatusToday() {

    DateTime now = DateTime.now();
    DateTime threshold = DateTime(now.year, now.month, now.day, kNewDayHour);

    if (now.hour < kNewDayHour) {
      threshold = threshold.subtract(Duration(days: 1));
    }

    return partyStatusTime.isAfter(threshold);

  }

}
