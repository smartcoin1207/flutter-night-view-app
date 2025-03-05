import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/screens/login_registration/choice/login_or_create_account_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

class WaitingForLoginScreen extends StatefulWidget {
  static const id = 'waiting_for_login_screen';

  const WaitingForLoginScreen({super.key});

  @override
  State<WaitingForLoginScreen> createState() => _WaitingForLoginScreenState();
}

class _WaitingForLoginScreenState extends State<WaitingForLoginScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // Existing login logic
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? mail = prefs.getString('mail');
      String? password = prefs.getString('password');

      if (mail == null || password == null) {
        Navigator.of(context)
            .pushReplacementNamed(LoginOrCreateAccountScreen.id);
      } else {
        bool loginSucces =
            await Provider.of<GlobalProvider>(context, listen: false)
                .userDataHelper
                .loginUser(mail: mail, password: password);

        if (loginSucces) {
          Navigator.of(context)
              .pushReplacementNamed(LocationPermissionCheckerScreen.id);
        } else {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Fejl ved login'),
              content: SingleChildScrollView(
                child: Text(
                  'Der skete en fejl, da vi forsøgte at logge dig ind automatisk. Måske har du ændret din kode siden sidst.',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          );
          Navigator.of(context)
              .pushReplacementNamed(LoginOrCreateAccountScreen.id);
        }
      }

      // Add tracking logic here
      await _initAppTrackingTransparency();
    });
  }

  Future<void> _initAppTrackingTransparency() async {
    // Ensure tracking authorization is requested properly
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      // Show custom explainer dialog
      await _showCustomTrackingDialog();
      // Delay slightly before showing the system dialog
      await Future.delayed(const Duration(milliseconds: 1000));
      // Request tracking authorization
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  Future<void> _showCustomTrackingDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location tracking'),
          content: const Text(
            'We use your location data to improve the app for you and others. '
            'You can opt out at any time in your device settings.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
