import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nightview/firebase_options.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/providers/login_registration_provider.dart';
import 'package:nightview/providers/main_navigation_provider.dart';
import 'package:nightview/screens/location_permission/location_permission_always_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_whileinuse_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_checker_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_precise_screen.dart';
import 'package:nightview/screens/location_permission/location_permission_service_screen.dart';
import 'package:nightview/screens/login_registration/login_main_screen.dart';
import 'package:nightview/screens/login_registration/login_registration_option_screen.dart';
import 'package:nightview/screens/login_registration/registration_age_screen.dart';
import 'package:nightview/screens/login_registration/registration_authentication_screen.dart';
import 'package:nightview/screens/login_registration/registration_confirmation_screen.dart';
import 'package:nightview/screens/login_registration/registration_name_screen.dart';
import 'package:nightview/screens/login_registration/registration_password_screen.dart';
import 'package:nightview/screens/login_registration/registration_welcome_screen.dart';
import 'package:nightview/screens/main_screen.dart';
import 'package:nightview/screens/my_profile/my_profile_main_screen.dart';
import 'package:nightview/screens/night_map/night_map_main_offer_screen.dart';
import 'package:nightview/screens/night_social/night_social_conversation_screen.dart';
import 'package:nightview/screens/preferences/preferences_main_screen.dart';
import 'package:nightview/screens/swipe/swipe_main_screen.dart';
import 'package:nightview/screens/utility/waiting_for_login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(NightViewApp());
}

class NightViewApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalProvider>(
          create: (_) => GlobalProvider(),
        ),
        ChangeNotifierProvider<MainNavigationProvider>(
          create: (_) => MainNavigationProvider(),
        ),
        ChangeNotifierProvider<LoginRegistrationProvider>(
          create: (_) => LoginRegistrationProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            color: Colors.black,
          ),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.black,
            showUnselectedLabels: false,
          ),
        ),
        initialRoute: WaitingForLoginScreen.id,
        routes: {
          LoginMainScreen.id: (context) => const LoginMainScreen(),
          LoginRegistrationOptionScreen.id: (context) =>
              const LoginRegistrationOptionScreen(),
          RegistrationAgeScreen.id: (context) => const RegistrationAgeScreen(),
          RegistrationAuthenticationScreen.id: (context) =>
              const RegistrationAuthenticationScreen(),
          RegistrationConfirmationScreen.id: (context) =>
              const RegistrationConfirmationScreen(),
          RegistrationNameScreen.id: (context) =>
              const RegistrationNameScreen(),
          RegistrationPasswordScreen.id: (context) =>
              const RegistrationPasswordScreen(),
          RegistrationWelcomeScreen.id: (context) =>
              const RegistrationWelcomeScreen(),
          MyProfileMainScreen.id: (context) => const MyProfileMainScreen(),
          NightSocialConversationScreen.id: (context) =>
              const NightSocialConversationScreen(),
          MainScreen.id: (context) => const MainScreen(),
          PreferencesMainScreen.id: (context) => const PreferencesMainScreen(),
          SwipeMainScreen.id: (context) => const SwipeMainScreen(),
          WaitingForLoginScreen.id: (context) => const WaitingForLoginScreen(),
          NightMapMainOfferScreen.id: (context) =>
              const NightMapMainOfferScreen(),
          LocationPermissionWhileInUseScreen.id: (context) =>
              const LocationPermissionWhileInUseScreen(),
          LocationPermissionAlwaysScreen.id: (context) =>
              const LocationPermissionAlwaysScreen(),
          LocationPermissionPreciseScreen.id: (context) =>
              const LocationPermissionPreciseScreen(),
          LocationPermissionServiceScreen.id: (context) =>
              const LocationPermissionServiceScreen(),
          LocationPermissionCheckerScreen.id: (context) =>
              const LocationPermissionCheckerScreen(),
        },
      ),
    );
  }
}
