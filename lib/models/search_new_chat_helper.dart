
import 'package:flutter/material.dart';
import 'package:nightview/models/user_data.dart';

class SearchNewChatHelper extends ChangeNotifier {

  List<UserData> _friends = [];
  List<UserData> _filteredFriends = [];

  List<UserData> get friends => _friends;
  List<UserData> get filteredFriends => _filteredFriends;

  void setFriends(List<UserData> friends) {
    _friends = friends;
    _filteredFriends = friends;
    notifyListeners();
  }

  void updateSearch(String searchStr) {

    _filteredFriends = _friends.where((user) => '${user.firstName.trim()} ${user.lastName.trim()}'.toLowerCase().contains(searchStr.toLowerCase())).toList();
    notifyListeners();

  }

}