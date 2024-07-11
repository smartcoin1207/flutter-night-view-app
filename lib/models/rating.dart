import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final String userId;
  final String clubId;
  final int rating;
  final Timestamp timestamp;

  Rating({required this.userId, required this.clubId, required this.rating, required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'clubId': clubId,
      'rating': rating,
      'timestamp': timestamp,
    };
  }

}