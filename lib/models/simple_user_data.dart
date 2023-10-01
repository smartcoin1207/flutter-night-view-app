
import 'package:flutter/material.dart';

class SimpleUserData {

  final String firstName;
  final String lastName;
  late final String fullName;
  late final ImageProvider profilePicture;

  SimpleUserData({required this.firstName, required this.lastName, required String? profilePictureUrl}) {
    fullName = '${firstName.trim()} ${lastName.trim()}';

    if (profilePictureUrl == null) {
      profilePicture = AssetImage('images/user_pb.jpg');
    } else {
      profilePicture = NetworkImage(profilePictureUrl);
    }

  }

  static SimpleUserData empty() => SimpleUserData(firstName: '', lastName: '', profilePictureUrl: null);

}