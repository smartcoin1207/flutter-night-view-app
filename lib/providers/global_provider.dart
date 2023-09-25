import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/models/club_data_helper.dart';
import 'package:nightview/models/friend_request_helper.dart';
import 'package:nightview/models/location_helper.dart';
import 'package:nightview/models/main_offer_redemptions_helper.dart';
import 'package:nightview/models/user_data.dart';
import 'package:nightview/models/user_data_helper.dart';

class GlobalProvider extends ChangeNotifier {
  GlobalProvider() {
    clubDataHelper = ClubDataHelper(
      onReceive: (data) {
        notifyListeners();
      },
    );
    userDataHelper = UserDataHelper(
      onReceive: (data) {
        userDataHelper
            .evaluatePartyCount(
          userData: data ?? {},
        )
            .then((count) {
          _partyCount = count;
          notifyListeners();
        });
      },
    );
    locationHelper = LocationHelper(
      onPositionUpdate: (location) async {

        if (userDataHelper.isLoggedIn()) {

          double? lat = location?.latitude;
          double? lon = location?.longitude;

          if (lat == null || lon == null) {
            return;
          }

          await updatePositionAndEvaluateVisitors(lat: lat, lon: lon);

        }

      },
    );
  }

  late ClubDataHelper clubDataHelper;
  late UserDataHelper userDataHelper;
  late LocationHelper locationHelper;

  MainOfferRedemptionsHelper mainOfferRedemptionsHelper =
      MainOfferRedemptionsHelper();
  AppinioSwiperController cardController = AppinioSwiperController();
  MapController nightMapController = MapController();

  ClubData? _chosenClub;
  bool _chosenClubFavoriteLocal = false;
  PartyStatus _partyStatusLocal = PartyStatus.unsure;
  PermissionState _permissionState = PermissionState.noPermissions;
  int _partyCount = 0;
  bool _locationOptOut = false;
  bool _biographyChanged = false;
  bool _friendRequestsLoaded = false;
  bool _pendingFriendRequests = false;
  List<UserData> _friends = [];

  ClubData get chosenClub => _chosenClub!;
  bool get chosenClubFavoriteLocal => _chosenClubFavoriteLocal;
  PartyStatus get partyStatusLocal => _partyStatusLocal;
  PermissionState get permissionState => _permissionState;
  int get partyCount => _partyCount;
  bool get locationOptOut => _locationOptOut;
  bool get biographyChanged => _biographyChanged;
  bool get friendRequestsLoaded => _friendRequestsLoaded;
  bool get pendingFriendRequests => _pendingFriendRequests;
  List<UserData> get friends => _friends;

  bool get chosenClubFavorite {
    String userId = userDataHelper.currentUserId;
    String clubId = chosenClub.id;
    List<dynamic> favoritesList;

    try {
      favoritesList = clubDataHelper.clubData[clubId]!.favorites;
    } catch (e) {
      print(e);
      return false;
    }

    return favoritesList.contains(userId);
  }

  Color get partyStatusColor {
    switch (_partyStatusLocal) {
      case PartyStatus.unsure:
        return Colors.grey;
      case PartyStatus.yes:
        return primaryColor;
      case PartyStatus.no:
        return Colors.redAccent;
    }
  }

  void setChosenClub(ClubData newValue) {
    _chosenClub = newValue;
    notifyListeners();
  }

  void setChosenClubFavoriteLocal(bool newValue) {
    _chosenClubFavoriteLocal = newValue;
    notifyListeners();
  }

  void setPartyStatusLocal(PartyStatus status) {
    _partyStatusLocal = status;
    notifyListeners();
  }

  void setPermissionState(PermissionState newValue) {
    _permissionState = newValue;
    notifyListeners();
  }

  void setLocationOptOut(bool optOut) {
    _locationOptOut = optOut;
    notifyListeners();
  }

  void setBiographyChanged(bool newValue) {
    _biographyChanged = newValue;
    notifyListeners();
  }

  void setFriendRequestsLoaded(bool newValue) {
    _friendRequestsLoaded = newValue;
    notifyListeners();
  }

  void setPendingFriendRequests(bool newValue) {
    _pendingFriendRequests = newValue;
    notifyListeners();
  }

  void setFriends(List<UserData> friends) {
    _friends = friends;
    notifyListeners();
  }

  Future<void> updatePositionAndEvaluateVisitors({required double lat, required double lon}) async {

    await userDataHelper.setCurrentUsersLastPosition(
      lat: lat,
      lon: lon,
    );
    clubDataHelper.evaluateVisitors(
      userData: userDataHelper.userData,
      locationHelper: locationHelper,
    );

  }

  Future<bool> deleteAllUserData() async {

    String userIdToDelete = userDataHelper.currentUserId;

    try {
      await userDataHelper.deleteDataAssociatedTo(userIdToDelete);
      await clubDataHelper.deleteDataAssociatedTo(userIdToDelete);
      await mainOfferRedemptionsHelper.deleteDataAssociatedTo(userIdToDelete);
      await userDataHelper.deleteCurrentUser();
      await FriendRequestHelper.deleteDataAssociatedTo(userIdToDelete);
    } catch (e) {
      print(e);
      return false;
    }
    return true;

  }

}
