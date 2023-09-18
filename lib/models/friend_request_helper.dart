import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/models/friend_request.dart';

class FriendRequestHelper {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  FriendRequestHelper();

  static Future<List<FriendRequest>> getPendingFriendRequests() async {
    final currentUserId = _auth.currentUser!.uid;

    List<FriendRequest> requests = [];
    List<QueryDocumentSnapshot> documents = [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('friend_requests')
          .where('to', isEqualTo: currentUserId)
          .where('status',
              isEqualTo: _enumToString(FriendRequestStatus.pending))
          .orderBy('timestamp')
          .get();
      documents = snapshot.docs;
    } catch (e) {
      print(e);
    }

    for (QueryDocumentSnapshot doc in documents) {
      requests.add(
        FriendRequest(
          requestId: doc.id,
          fromId: doc.get('from'),
        ),
      );
    }

    return requests;
  }

  static Future<bool> pendingFriendRequests() async {
    final currentUserId = _auth.currentUser!.uid;

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('friend_requests')
          .where('to', isEqualTo: currentUserId)
          .where('status',
          isEqualTo: _enumToString(FriendRequestStatus.pending))
          .get();
      return snapshot.docs.length > 0;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> acceptFriendRequest(String requestId) async {

    await _firestore.collection('friend_requests').doc(requestId).update({'status': _enumToString(FriendRequestStatus.accepted)});

  }

  static Future<void> rejectFriendRequest(String requestId) async {

    await _firestore.collection('friend_requests').doc(requestId).update({'status': _enumToString(FriendRequestStatus.rejected)});

  }

  static Future<void> deleteDataAssociatedTo(String userId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('friend_requests').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> request in snapshot.docs) {
      String requestId = request.id;

      String fromId = request.get('from').toString();
      String toId = request.get('to').toString();

      if (fromId == userId || toId == userId) {
        _firestore.collection('friend_requests').doc(requestId).delete();
      }

    }
  }

  static String _enumToString(FriendRequestStatus status) {
    switch (status) {
      case FriendRequestStatus.pending:
        return 'FriendRequestStatus.pending';
      case FriendRequestStatus.accepted:
        return 'FriendRequestStatus.accepted';
      case FriendRequestStatus.rejected:
        return 'FriendRequestStatus.rejected';
    }
  }

  static FriendRequestStatus _stringToEnum(String status) {
    switch (status) {
      case 'FriendRequestStatus.pending':
        return FriendRequestStatus.pending;
      case 'FriendRequestStatus.accepted':
        return FriendRequestStatus.accepted;
      case 'FriendRequestStatus.rejected':
        return FriendRequestStatus.rejected;
      default:
        return FriendRequestStatus.rejected;
    }
  }
}
