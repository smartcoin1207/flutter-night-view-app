import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreUpdater {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateFirestoreData() async {
    // Specify the document ID of the club you want to test
    String clubDocumentId = 'hornsleth_0';

    // Fetch the specific document from the 'club_data' collection
    DocumentReference clubRef = firestore.collection('club_data').doc(clubDocumentId);
    DocumentSnapshot doc = await clubRef.get();

    if (doc.exists) {
      try {
        // Get current data and ensure it's a Map<String, dynamic>
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        if (data == null) {
          print('Document data is null for $clubDocumentId.');
          return;
        }

        print('Original Data: $data'); // Debug: Print original data

        _ensureOpeningHours(data);
        _removeUnwantedAttributes(data);
        _updateFields(data);



        print('Updated Data: $data'); // Debug: Print updated data

        // Update the document with the new data
        await clubRef.set(data);

        // Ensure the 'ratings' collection exists
        await _ensureRatingsCollection(clubRef, clubDocumentId);

        print('Firestore data update complete for $clubDocumentId.');
      } catch (e) {
        print('Error processing document $clubDocumentId: $e');
      }
    } else {
      print('Document $clubDocumentId does not exist.');
    }
  }

  void _updateFields(Map<String, dynamic> data) {
    // Ensure all required attributes are present and correctly updated
    void putIfAbsent(Map<String, dynamic> map, String key, dynamic value) {
      if (map[key] == null) {
        map[key] = value;
      }
    }
    // putIfAbsent(data, 'main_offer_img', 'hornsleth_0_offer.png');
    // putIfAbsent(data, 'logo', 'hornsleth_0_logo.png');
    // putIfAbsent(data, 'lat', 0);
    // putIfAbsent(data, 'lon', 0);
    // putIfAbsent(data, 'name', 'Klub Klub');
    putIfAbsent(data, 'age_restriction', 10);
    putIfAbsent(data, 'total_possible_amount_of_visitors', 0);
    putIfAbsent(data, 'visitors', 0);
    putIfAbsent(data, 'rating', 0);
    putIfAbsent(data, 'offer_type', 'OfferType.none');
    putIfAbsent(data, 'age_of_visitors', '');
    putIfAbsent(data, 'first_time_visitors', 0);
    putIfAbsent(data, 'regular_visitors', 0);
    putIfAbsent(data, 'returning_visitors', 0);
    putIfAbsent(data, 'peak_hours', '10:00 - 11:00');
    putIfAbsent(data, 'type_of_club', 'Klub');
  }

  void _ensureOpeningHours(Map<String, dynamic> data) {
    // Ensure openingHours is a map with the correct structure
    if (data['openingHours'] == null || data['openingHours'] is! Map<String, dynamic>) {
      data['openingHours'] = {
        'monday': null, // Closed all day
        'tuesday': null, // Closed all day
        'wednesday': {'open': '21:00', 'close': '01:00'},
        'thursday': {'open': '21:00', 'close': '05:00'},
        'friday': {'open': '21:00', 'close': '05:00'},
        'saturday': {'open': '21:00', 'close': '05:00'},
        'sunday': null, // Closed all day
      };
    }
  }

  void _removeUnwantedAttributes(Map<String, dynamic> data) {
    // Remove the unwanted attribute

      data.remove('peakHour');
      data.remove('ageRestriction');
      data.remove('offerType');
      data.remove('totalPossibleAmountOfVisitors');

  }

  Future<void> _ensureRatingsCollection(DocumentReference clubRef, String clubDocumentId) async {
    // Ensure the 'ratings' collection exists by adding a document with specified fields
    CollectionReference ratingsRef = clubRef.collection('ratings');
    QuerySnapshot ratingsSnapshot = await ratingsRef.get();

    if (ratingsSnapshot.docs.isEmpty) {
      // Add a document with specified fields to ensure the collection is created
      await ratingsRef.add({
        'clubId': clubDocumentId,
        'rating': 3,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': 'Edj2ex3selWyLnUV8qvDanrNH2L2',
      });
    }
  }
}