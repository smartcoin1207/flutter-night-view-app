import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/screens/night_social/night_social_conversation_screen.dart';

class NightSocialMainScreen extends StatefulWidget {
  static const id = 'night_social_main_screen';

  const NightSocialMainScreen({super.key});

  @override
  State<NightSocialMainScreen> createState() => _NightSocialMainScreenState();
}

class _NightSocialMainScreenState extends State<NightSocialMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(kMainPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chats',
                style: kTextStyleH1,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: FaIcon(
                      FontAwesomeIcons.penToSquare,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: FaIcon(
                      FontAwesomeIcons.userPlus,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(kMainPadding),
            itemCount: 10,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                print('Tapped ${index}');
                Navigator.of(context).pushNamed(NightSocialConversationScreen.id);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kMainBorderRadius),
                side: BorderSide(
                  color: Colors.white,
                  width: kMainStrokeWidth,
                ),
              ),
              leading: CircleAvatar(
                child: Image.asset('images/logo_icon.png'),
              ),
              title: Text('Gunnar'),
              subtitle: Text('Dig: Haha xd'),
            ),
            separatorBuilder: (context, index) => SizedBox(
              height: kSmallSpacerValue,
            ),
          ),
        ),
      ],
    );
  }
}
