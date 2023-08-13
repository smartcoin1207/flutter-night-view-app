import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/models/location_helper.dart';
import 'package:nightview/models/user_data.dart';

class ClubDataHelper {
  final _firestore = FirebaseFirestore.instance;
  final _storageRef = FirebaseStorage.instance.ref();

  Map<String, ClubData> clubData = {};
  ClubDataHelper({Callback<Map<String, ClubData>>? onReceive}) {
    _firestore.collection('club_data').snapshots().listen((snap) {
      clubData.clear();

      Future.forEach(snap.docs, (club) async {
        try {
          final data = club.data();
          clubData[club.id] = ClubData(
              id: club.id,
              name: data['name'],
              logo: await _storageRef
                  .child('club_logos/${data['logo']}')
                  .getDownloadURL(),
              lat: data['lat'],
              lon: data['lon'],
              visitors: data['visitors'],
              favorites: data['favorites'],
              corners: data['corners'],
              offerType:
                  stringToOfferType(data['offer_type'] ?? 'OfferType.none') ??
                      OfferType.none,
              mainOfferImg:
                  stringToOfferType(data['offer_type']) == OfferType.none
                      ? null
                      : await _storageRef
                          .child('main_offers/${data['main_offer_img']}')
                          .getDownloadURL());
        } catch (e) {
          print(e);
        }
      }).then((value) {
        if (onReceive != null) {
          onReceive(clubData);
        }
      });
    });
  }

  void setFavoriteClub(String clubId, String userId) async {
    DocumentSnapshot<Map<String, dynamic>> clubDocument =
        await _firestore.collection('club_data').doc(clubId).get();
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
    DocumentSnapshot<Map<String, dynamic>> clubDocument =
        await _firestore.collection('club_data').doc(clubId).get();
    List<dynamic> favoritesList = clubDocument.data()!['favorites'];

    if (!favoritesList.contains(userId)) {
      return;
    }

    favoritesList.remove(userId);

    _firestore.collection('club_data').doc(clubId).update({
      'favorites': favoritesList,
    });
  }

  void evaluateVisitors(
      {required Map<String, UserData> userData,
      required LocationHelper locationHelper}) async {
    clubData.forEach((id, club) {
      int visitors = 0;

      userData.forEach((id, user) {
        DateTime timeTreshhold = DateTime.now().subtract(Duration(hours: 1));

        if (user.lastPositionTime != null &&
            user.lastPositionTime.isAfter(timeTreshhold) &&
            locationHelper.userInClub(userData: user, clubData: club)) {
          visitors++;
        }
      });

      _firestore.collection('club_data').doc(club.id).update({
        'visitors': visitors,
      });
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
}
