import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/values.dart';

import 'package:nightview/models/users/user_data.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/widgets/stateless/complete_profile_screen.dart';

class UserDataHelper { // Needs refac
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Map<String, UserData> userData = {};

  UserDataHelper({Callback<Map<String, UserData>>? onReceive}) {
    _firestore.collection('user_data').snapshots().listen((snap) {
      userData.clear();

      Future.forEach(snap.docs, (user) async {
        try {
          final data = user.data();
          userData[user.id] = UserData(
            id: user.id,
            firstName: data['first_name'],
            lastName: data['last_name'],
            mail: data['mail'],
            phone: data['phone'],
            birthdayDay: data['birthdate_day'],
            birthdayMonth: data['birthdate_month'],
            birthdayYear: data['birthdate_year'],
            lastPositionLat: data['last_position_lat'] ?? 0.0,
            lastPositionLon: data['last_position_lon'] ?? 0.0,
            lastPositionTime:
                data['last_position_time']?.toDate() ?? DateTime(2000),
            partyStatus: stringToPartyStatus(
                    data['party_status'] ?? 'PartyStatus.unsure') ??
                PartyStatus.unsure,
            partyStatusTime:
                data['party_status_time']?.toDate() ?? DateTime(2000),
          );
        } catch (e) {
          print(e);
        }
      }).then((value) {
        if (onReceive != null) {
          onReceive(userData);
        }
      });
    });
  }

  String? get currentUserId => _auth.currentUser?.uid;

  UserData? get currentUserData => userData[currentUserId];

  int get userCount => userData.length;

  Future<bool> createUserWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        return false;
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> uploadUserData({
    required String firstName,
    required String lastName,
    required String mail,
    required String phone,
    required int birthdateDay,
    required int birthdateMonth,
    required int birthdateYear,
  }) async {
    try {
      await _firestore.collection('user_data').doc(currentUserId).set({
        'mail': mail,
        'phone': phone,
        'first_name': firstName,
        'last_name': lastName,
        'birthdate_day': birthdateDay,
        'birthdate_month': birthdateMonth,
        'birthdate_year': birthdateYear,
      });
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<bool> loginUser({
    required String mail,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: mail,
        password: password,
      );
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> signOutCurrentUser() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  Future<bool> setCurrentUsersLastPosition(
      {required double lat, required double lon}) async {
    try {
      await _firestore.collection('user_data').doc(currentUserId).update({
        'last_position_lat': lat,
        'last_position_lon': lon,
        'last_position_time': Timestamp.now(),
      });
    } catch (e) {
      print(e);
      return false;
    }

    return true;
  }

  Future<bool> setCurrentUsersPartyStatus({required PartyStatus status}) async {
    try {
      await _firestore.collection('user_data').doc(currentUserId).update({
        'party_status': status.toString(),
        'party_status_time': Timestamp.now(),
      });
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  PartyStatus? stringToPartyStatus(String str) {
    switch (str) {
      case 'PartyStatus.yes':
        return PartyStatus.yes;
      case 'PartyStatus.no':
        return PartyStatus.no;
      case 'PartyStatus.unsure':
        return PartyStatus.unsure;
      default:
        return null;
    }
  }

  Future<int> evaluatePartyCount(
      {required Map<String, UserData> userData}) async {
    int count = 0;

    userData.forEach((id, user) {
      if (user.answeredStatusToday() && user.partyStatus == PartyStatus.yes) {
        count++;
      }
    });

    return count;
  }

  bool doesMailExist({required String mail}) {
    bool exists = false;

    userData.forEach((id, user) {
      if (user.mail == mail) {
        exists = true;
        return;
      }
    });

    return exists;
  }

  Future<void> deleteDataAssociatedTo(String userId) async {
    await _firestore.collection('user_data').doc(userId).delete();
  }

  Future<void> deleteCurrentUser() async {
    await _auth.currentUser?.delete();
  }

  Future<int> getUserCount() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('user_data').get();
      int userCount = snapshot.docs.length;
      return userCount;
    } catch (e) {
      // Handle any errors here
      print(e);
      return 0; // Return 0 or handle the error as needed
    }
  }

  Future<void> _handleGoogleSignIn(BuildContext context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

    if (Platform.isIOS || Platform.isMacOS) {
      googleSignIn = GoogleSignIn(
        clientId: "YOUR_CLIENT_ID.apps.googleusercontent.com",
        scopes: ['email'],
      );
    }

    try {
      final GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

      if (googleAccount != null) {
        // Create an instance of UserDataHelper
        final userDataHelper = UserDataHelper();

        // await _uploadProfilePicture(googleAccount.photoUrl); //TODO

        // Extract the user's information
        final firstName = googleAccount.displayName?.split(' ').first ?? "";
        final lastName = googleAccount.displayName?.split(' ').last ?? "";
        final mail = googleAccount.email;

        final doesUserExist = userDataHelper.doesMailExist(mail: mail);
        if (!doesUserExist) {
          // Redirect to a profile completion screen if additional data is needed
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CompleteProfileScreen(
                firstName: firstName,
                lastName: lastName,
                mail: mail,
                onProfileComplete: (phone, birthdateDay, birthdateMonth, birthdateYear) async {
                  // Upload user data to Firestore
                  final uploadSuccess = await userDataHelper.uploadUserData(
                    firstName: firstName,
                    lastName: lastName,
                    mail: mail,
                    phone: phone,
                    birthdateDay: birthdateDay,
                    birthdateMonth: birthdateMonth,
                    birthdateYear: birthdateYear,
                  );

                  if (uploadSuccess) {
                    // Navigate to the next screen if upload is successful
                    Navigator.of(context).pushNamed(LocationPermissionCheckerScreen.id);
                  } else {
                    print("Failed to upload user data.");
                  }
                },
              ),
            ),
          );
        }Navigator.of(context).pushNamed(LocationPermissionCheckerScreen.id); //TODO
      }
    } catch (error) {
      print('Google Sign-In failed: $error');
//TODO Sho erro
    }
  }


}
