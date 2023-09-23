import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/models/user_data.dart';

class FriendsHelper {
  static Future<void> addFriend(String otherId) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;

    if (_auth.currentUser == null) {
      return;
    }

    String userId = _auth.currentUser!.uid;

    _firestore.collection('friends').doc(userId).set({otherId: true}, SetOptions(merge: true));
    _firestore.collection('friends').doc(otherId).set({userId: true}, SetOptions(merge: true));
  }

  static Future<void> removeFriend(String otherId) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;

    if (_auth.currentUser == null) {
      return;
    }

    String userId = _auth.currentUser!.uid;

    _firestore.collection('friends').doc(userId).set({otherId: false}, SetOptions(merge: true));
    _firestore.collection('friends').doc(otherId).set({userId: false}, SetOptions(merge: true));
  }

  static Future<bool> isFriend(String otherId) async {
    final _firestore = FirebaseFirestore.instance;
    final _auth = FirebaseAuth.instance;

    if (_auth.currentUser == null) {
      return false;
    }

    String userId = _auth.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> snap = await _firestore.collection('friends').doc(userId).get();

    if (!snap.exists) {
      return false;
    }

    if (!snap.data()!.containsKey(otherId)) {
      return false;
    }

    return snap.get(otherId);

  }

  // static Future<List<UserData>> filterFriends(List<UserData> users, {FriendFilterType filterType = FriendFilterType.exclude}) async {
  //
  //   List<UserData> notFriendUsers = [];
  //
  //   for (UserData user in users) {
  //     bool friend = await isFriend(user.id);
  //     bool addFriend = (TERNARY OPERATOR!)
  //
  //   }
  //
  // }

}
