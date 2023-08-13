import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/models/location_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_always_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_precise_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_service_screen.dart';
import 'package:nightview/screens/main_screen.dart';
import 'package:nightview/screens/swipe/swipe_main_screen.dart';
import 'package:provider/provider.dart';

class LocationPermissionCheckerScreen extends StatefulWidget {
  static const id = 'location_permission_checker_screen';

  const LocationPermissionCheckerScreen({super.key});

  @override
  State<LocationPermissionCheckerScreen> createState() =>
      _LocationPermissionCheckerScreenState();
}

class _LocationPermissionCheckerScreenState
    extends State<LocationPermissionCheckerScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      LocationHelper locationHelper =
          Provider.of<GlobalProvider>(context, listen: false).locationHelper;

      if (await locationHelper.serviceEnabled) {
        if (await locationHelper.hasPermissionAlways) {
          if (await locationHelper.hasPermissionPrecise) {
            locationHelper.activateBackgroundLocation();
            Provider.of<GlobalProvider>(context, listen: false).userDataHelper
                .currentUserData
                .answeredStatusToday()
                ? Navigator.of(context).pushReplacementNamed(MainScreen.id)
                : Navigator.of(context).pushReplacementNamed(SwipeMainScreen.id);
          } else {
            Navigator.of(context).pushReplacementNamed(LocationPermissionPreciseScreen.id);
          }
        } else {
          Navigator.of(context).pushReplacementNamed(LocationPermissionAlwaysScreen.id);
        }
      } else {
        Navigator.of(context).pushReplacementNamed(LocationPermissionServiceScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SpinKitPouringHourGlass(
            color: primaryColor,
            size: 150.0,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}
