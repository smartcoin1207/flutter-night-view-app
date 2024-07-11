import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nightview/constants/enums.dart';

class FirestoreUpdater {
  Future<void> updateFirestoreData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Fetch all documents from the 'clubs' collection
    CollectionReference clubsRef = firestore.collection('clubs');
    QuerySnapshot querySnapshot = await clubsRef.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      try {
        // Get current data
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Ensure all required attributes are present
        data.putIfAbsent('mainOfferImg', () => null);
        data.putIfAbsent('ageRestriction', () => 0);
        data.putIfAbsent('totalPossibleAmountOfVisitors', () => 0);
        data.putIfAbsent('visitors', () => 0);
        data.putIfAbsent('rating', () => 0);
        data.putIfAbsent('openingHours', () => {});
        data.putIfAbsent('favorites', () => []);
        data.putIfAbsent('corners', () => []);
        data.putIfAbsent('offerType', () => 'none');
        data.putIfAbsent('age_of_visitors', () => '');
        data.putIfAbsent('first_time_visitors', () => 0);
        data.putIfAbsent('regular_visitors', () => 0);
        data.putIfAbsent('returning_visitors', () => 0);
        data.putIfAbsent('peak_hours', () => '');

        //NEEDS:
        //LOGO
        //LAT
        //LON
        //NAME

        // RATING INSIDE EACH CLUB

        // Remove the unwanted attribute
        if (data.containsKey('peak_hour')) {
          data.remove('peak_hour');
        }

        // Update the document with the new data
        await doc.reference.set(data);
      } catch (e) {
        print('Error processing document ${doc.id}: $e');
      }
    }

    print('Firestore data update complete.');
  }
}
