import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUpdaterTanteOlga {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateFirestoreData() async {
    // Document ID for "Tante Olga"
    String clubDocumentId = 'tante_olga_0';

    // Data for "Tante Olga"
    Map<String, dynamic> data = {
      'age_of_visitors': '21',
      'age_restriction': 18,
      'corners': [
        const GeoPoint(56.4572717845962, 10.038781392248115),
        const GeoPoint(56.457158373493584, 10.038891909789806),
        const GeoPoint(56.457134694209664, 10.038817479608667),
        const GeoPoint(56.457101044675504, 10.038837778748977),
        const GeoPoint(56.4570487008965, 10.038659597406252),
        const GeoPoint(56.45712597025923, 10.038591933605217),
        const GeoPoint(56.45714840327059, 10.038652831026146),
        const GeoPoint(56.45721944105245, 10.038585167225111)
      ],
      'favorites': [
        'Edj2ex3selWyLnUV8qvDanrNH2L2'
      ],
      'first_time_visitors': 0,
      'lat': 56.457160866048945,
      'logo': 'tante_olga_0_logo.jpg',
      'lon': 10.038763348567839,
      'main_offer_img': '',
      'name': 'Tante Olga',
      'offer_type': '',
      'peak_hours': '10:00 - 10:01',
      'rating': 3,
      'regular_visitors': 0,
      'returning_visitors': 0,
      'total_possible_amount_of_visitors': 266,
      'type_of_club': 'bar',
      'visitors': 0,
      'opening_hours': {
        'monday': null,
        'tuesday': null,
        'wednesday': {'open': '21:00', 'close': '01:00'},
        'thursday': {'open': '21:00', 'close': '05:00'},
        'friday': {'open': '21:00', 'close': '05:00'},
        'saturday': {'open': '21:00', 'close': '05:00'},
        'sunday': null,
      }
    };

    try {
      // Update the document with the new data
      await firestore.collection('club_data').doc(clubDocumentId).set(data);

      // Ensure the 'ratings' collection exists
      await _ensureRatingsCollection(firestore.collection('club_data').doc(clubDocumentId), clubDocumentId);

      print('Firestore data update complete for $clubDocumentId.');
    } catch (e) {
      print('Error processing document $clubDocumentId: $e');
    }
  }

  Future<void> _ensureRatingsCollection(
      DocumentReference clubRef, String clubDocumentId) async {
    // Ensure the 'ratings' collection exists by adding a document with specified fields
    CollectionReference ratingsRef = clubRef.collection('ratings');
    QuerySnapshot ratingsSnapshot = await ratingsRef.get();

    if (ratingsSnapshot.docs.isEmpty) {
      // Add a document with specified fields to ensure the collection is created
      await ratingsRef.add({
        'club_id': clubDocumentId,
        'rating': 3,
        'timestamp': FieldValue.serverTimestamp(),
        'user_id': 'Edj2ex3selWyLnUV8qvDanrNH2L2',
      });
    }
  }
}
