import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
}
