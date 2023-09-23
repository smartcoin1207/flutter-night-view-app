

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nightview/models/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class SearchFriendsHelper extends ChangeNotifier {

  DateTime? _lastUpdate;
  String? _searchString;

  String? get searchString => _searchString;

  set searchString(String? value) {
    _searchString = value;
    notifyListeners();
  }

  void updateSearch(BuildContext context, String value) {

    _lastUpdate = DateTime.now();

    Future.delayed(Duration(seconds: 2), () {
      DateTime now = DateTime.now();
      Duration diff = now.difference(_lastUpdate!);
      if (diff > Duration(seconds: 2)) {
        searchString = value;
        _getUsers(context, value).forEach((user) {
          print('${user.firstName} ${user.lastName}');
        });
      }
    });

  }

  List<UserData> _getUsers(BuildContext context, String searchStr) {
    List<UserData> users = [];
    Map<String, UserData> allUsers = Provider.of<GlobalProvider>(context, listen: false).userDataHelper.userData;

    for (UserData user in allUsers.values) {
      String fullName = '${user.firstName.trim()} ${user.lastName.trim()}'.toLowerCase();
      if (fullName.contains(searchStr.toLowerCase().trim())) {
        users.add(user);
      }
    }

    return users;
  }

}