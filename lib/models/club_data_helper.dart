import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/models/location_helper.dart';

class ClubDataHelper {
  final _firestore = FirebaseFirestore.instance;
  final _storageRef = FirebaseStorage.instance.ref();

  Map<String, ClubData> clubData = {};

  ClubDataHelper({Callback<Map<String, ClubData>>? onReceive}) {
    _firestore.collection('club_data').snapshots().listen((snap) {
      clubData.clear();

      List<Future<void>> futures = snap.docs.map((club) => _processClub(club))
          .toList();
      Future.wait(futures).then((value) {
        if (onReceive != null) {
          onReceive(clubData);
        }
      });
    });
  }

  Future<void> _processClub(
      QueryDocumentSnapshot<Map<String, dynamic>> club) async {
    try {
      final data = club.data();
      clubData[club.id] = ClubData(
          id: club.id,
          name: data['name'],
          logo: await _storageRef.child('club_logos/${data['logo']}')
              .getDownloadURL(),
          lat: data['lat'],
          lon: data['lon'],
          favorites: data['favorites'],
          corners: data['corners'],
          offerType: stringToOfferType(
              data['offer_type'] ?? 'OfferType.none') ?? OfferType.none,
          mainOfferImg: stringToOfferType(data['offer_type']) == OfferType.none
              ? null
              : await _storageRef.child('main_offers/${data['main_offer_img']}')
              .getDownloadURL());
    } catch (e) {
      print(e);
    }
  }

  void setFavoriteClub(String clubId, String userId) async {
    DocumentSnapshot<Map<String, dynamic>> clubDocument = await _firestore
        .collection('club_data').doc(clubId).get();
    List<dynamic> favoritesList = clubDocument.data()!['favorites'];

    if (favoritesList.contains(userId)) {
      return;
    }

    favoritesList.add(userId);

    _firestore.collection('club_data').doc(clubId).update({
      'favorites': favoritesList,
    });
  }

  void removeFavoriteClub(String clubId, String userId) async {
    DocumentSnapshot<Map<String, dynamic>> clubDocument = await _firestore
        .collection('club_data').doc(clubId).get();
    List<dynamic> favoritesList = clubDocument.data()!['favorites'];

    if (!favoritesList.contains(userId)) {
      return;
    }

    favoritesList.remove(userId);

    _firestore.collection('club_data').doc(clubId).update({
      'favorites': favoritesList,
    });
  }

  Future<void> updateVisitCount(String userId, String clubId) async {
    // TODO
    final clubVisitRef = _firestore.collection('club_visits').doc(
        '$userId-$clubId');
    final clubVisitDoc = await clubVisitRef.get();

    if (clubVisitDoc.exists) {
      final clubVisit = ClubVisit.fromMap(clubVisitDoc.data()!);
      clubVisit.visitCount += 1;
      await clubVisitRef.update({'visitCount': clubVisit.visitCount});
    } else {
      final clubVisit = ClubVisit(
          userId: userId, clubId: clubId, visitCount: 1);
      await clubVisitRef.set(clubVisit.toMap());
    }
  }

  Future<void> evaluateVisitors({ // TODO
    required LocationHelper locationHelper,
  }) async {
    final DateTime timeThreshold = DateTime.now().subtract(Duration(hours: 1));

    for (var entry in clubData.entries) {
      String clubId = entry.key;
      ClubData club = entry.value;

      int visitors = 0;
      int firstTimeVisitors = 0;
      int returningVisitors = 0;
      int regularVisitors = 0;
      String ageOfVisitors = "";

      for (var userEntry in userData.entries) {
        String userId = userEntry.key;
        UserData user = userEntry.value;

        if (user.lastPositionTime != null &&
            user.lastPositionTime!.isAfter(timeThreshold) &&
            locationHelper.userInClub(userData: user, clubData: club)) {
          visitors++;

          if (user.birthdayYear != null) {
            int age = DateTime
                .now()
                .year - user.birthdayYear!;
            ageOfVisitors += "$age, ";
          }

          if (user.visitCount == 1) {
            firstTimeVisitors++;
          } else if (user.visitCount > 1 && user.visitCount < 5) {
            returningVisitors++;
          } else if (user.visitCount >= 5) {
            regularVisitors++;
          }
        }
      }

      try {
        // Update the Firestore document
        await _firestore.collection('club_data').doc(clubId).update({
          'visitors': visitors,
          'firstTimeVisitors': firstTimeVisitors,
          'returningVisitors': returningVisitors,
          'regularVisitors': regularVisitors,
          'ageOfVisitors': ageOfVisitors,
        });
      } catch (e) {
        print("Failed to update club data for $clubId: $e");
      }
    }
  }


  final DateTime timeTreshhold = DateTime.now().subtract(
      Duration(hours: 1));

  clubData.forEach

  (

  (clubId, clubData) async {
  AggregateQuerySnapshot snap = await _firestore.collection(
  'location_data').where('club_id', isEqualTo: clubId).where(
  'latest', isEqualTo: true)
      .where(
  'timestamp', isGreaterThan: Timestamp.fromDate(timeTreshhold))
      .count()
      .get();
  clubData.visitors = snap.count;
  });
}

OfferType? stringToOfferType(String str) {
  switch (str) {
    case 'OfferType.none':
      return OfferType.none;
    case 'OfferType.alwaysActive':
      return OfferType.alwaysActive;
    case 'OfferType.redeemable':
      return OfferType.redeemable;
    default:
      return null;
  }
}

Future<void> deleteDataAssociatedTo(String userId) async {
  QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
      .collection('club_data').get();

  for (QueryDocumentSnapshot<Map<String, dynamic>> club in snapshot.docs) {
    final String clubId = club.id;
    final favoritesData = club.get('favorites');

    if (!favoritesData.contains(userId)) {
      continue;
    }

    favoritesData.remove(userId);

    _firestore.collection('club_data').doc(clubId).update({
      'favorites': favoritesData,
    });
  }
}
}
