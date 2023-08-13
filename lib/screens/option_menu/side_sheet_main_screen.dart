import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/enums.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/login_registration/login_registration_option_screen.dart';
import 'package:nightview/screens/option_menu/bottom_sheet_status_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideSheetMainScreen extends StatefulWidget {
  const SideSheetMainScreen({super.key});

  @override
  State<SideSheetMainScreen> createState() => _SideSheetMainScreenState();
}

class _SideSheetMainScreenState extends State<SideSheetMainScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String currentUserId = Provider.of<GlobalProvider>(context, listen: false)
          .userDataHelper
          .currentUserId;
      PartyStatus status = Provider.of<GlobalProvider>(context, listen: false)
              .userDataHelper
              .userData[currentUserId]
              ?.partyStatus ??
          PartyStatus.unsure;
      Provider.of<GlobalProvider>(context, listen: false)
          .setPartyStatusLocal(status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.arrowRight,
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Skift status'),
                  leading: FaIcon(
                    FontAwesomeIcons.solidCircleDot,
                    color:
                        Provider.of<GlobalProvider>(context).partyStatusColor,
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => BottomSheetStatusScreen(),
                    );
                  },
                )
              ],
            ),
            Column(
              children: [
                ListTile(
                  title: Text('Log af'),
                  leading: FaIcon(
                    FontAwesomeIcons.rightFromBracket,
                  ),
                  onTap: () async {
                    await Provider.of<GlobalProvider>(context, listen: false).userDataHelper.signOutCurrentUser();
                    Navigator.of(context).pushNamedAndRemoveUntil(LoginRegistrationOptionScreen.id, (route) => false);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.remove('mail');
                    prefs.remove('password');
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
