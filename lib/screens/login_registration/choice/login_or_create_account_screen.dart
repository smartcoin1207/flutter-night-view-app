import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/icons.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/screens/login_registration/utility/google_sign_in_manager.dart';
import 'package:nightview/widgets/icons/logo_top_right.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/screens/login_registration/login/login_nightview_screen.dart';
import 'package:nightview/screens/login_registration/creation/create_account_screen_one_personal.dart';
import 'package:nightview/widgets/stateless/login_registration_button.dart';

class LoginOrCreateAccountScreen extends StatelessWidget {
  static const id = 'login_or_create_account_screen';

  const LoginOrCreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ImageInsertDefaultTopRight(
              //TODO borderRadius flag.
              imagePath: 'images/flags/dk.png',
              width: 35,
              height: 35,
              borderRadius: 25,
            ),

            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'images/logo_text_subtitle.png',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: LoginRegistrationButton(
                          text: 'Log ind',
                          type: LoginRegistrationButtonType.transparent,
                          textStyle:
                              kTextStyleH3ToP1.copyWith(color: primaryColor),
                          onPressed: () {
                            Navigator.of(context).pushNamed(LoginScreen.id);
                          },
                        ),
                      ),
                      SizedBox(height: kNormalSpacerValue),
                      Divider(),
                      SizedBox(height: kNormalSpacerValue),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: LoginRegistrationButton(
                          text: 'Opret NightView profil',
                          type: LoginRegistrationButtonType.transparent,
                          filledColor: primaryColor,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(CreateAccountScreenOnePersonal.id);
                          },
                        ),
                      ),
                      SizedBox(height: kBigSpacerValue),
//                        Padding( TODO
                      //                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      //                      child: LoginRegistrationButton(
                      //                      icon: defaultGoogleIcon,
                      //                    text: 'Opret med Google',
                      //                  type: LoginRegistrationButtonType.transparent,
                      //                filledColor: primaryColor,
                      //              onPressed: () async {
                      //              await GoogleSignInHelper.handleGoogleSignIn(context);
//
                      //                       },
                      //                      ),
                      //                  ),
                      //           SizedBox(height: kBigSpacerValue),
                      // if (Platform.isIOS) // TODO BEFORE
                      //   Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      //     child: LoginRegistrationButton(
                      //       icon: defaultAppleIcon,
                      //       text: 'Opret med Apple',
                      //       type: LoginRegistrationButtonType.transparent,
                      //       filledColor: primaryColor,
                      //       onPressed: () {
                      //         AppleSignInManager.handleAppleSignIn();
                      //         Navigator.of(context)
                      //             .pushNamed(CreateAccountScreenOnePersonal.id);
                      //       },
                      //     ),
                      //   ),

                      // if (Platform.isIOS)// Working idea // Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // children: [ // LoginRegistrationIconButton(
                      // icon: defaultGoogleIcon, // onPressed: _handleGoogleSignIn,
                      // ), // LoginRegistrationIconButton( // icon: defaultAppleIcon,
                      // onPressed: () { // _handleAppleSignIn(); // }, // ), // ], // ),
                    ],
                  ),
                ),
                SizedBox(height: 80),
              ],
            ),
            // Positioned Image in the Top-Right Corner
          ],
        ),
      ),
    );
  }
}
