import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/friend_request_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_social/friend_requests_screen.dart';
import 'package:nightview/screens/night_social/night_social_conversation_screen.dart';
import 'package:provider/provider.dart';

class NightSocialMainScreen extends StatefulWidget {
  static const id = 'night_social_main_screen';

  const NightSocialMainScreen({super.key});

  @override
  State<NightSocialMainScreen> createState() => _NightSocialMainScreenState();
}

class _NightSocialMainScreenState extends State<NightSocialMainScreen> {

  @override
  void initState() {

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        checkPending();
      });

    super.initState();
  }

  void checkPending() {
    FriendRequestHelper.pendingFriendRequests().then((pending) {
      Provider.of<GlobalProvider>(context, listen: false).setPendingFriendRequests(pending);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(kBigPadding),
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chats',
                style: kTextStyleH1,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.penToSquare,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: FaIcon(
                      FontAwesomeIcons.userPlus,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: Provider.of<GlobalProvider>(context).pendingFriendRequests,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(FriendRequestsScreen.id);
            },
            child: Container(
              padding: EdgeInsets.all(kBigPadding),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Nye venneanmodninger',
                    style: kTextStyleH3,
                  ),
                  FaIcon(FontAwesomeIcons.arrowRight),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(kMainPadding),
            itemCount: 10,
            itemBuilder: (context, index) => ListTile(
              onTap: () {
                print('Tapped ${index}');
                Navigator.of(context)
                    .pushNamed(NightSocialConversationScreen.id);
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kMainBorderRadius),
                side: BorderSide(
                  color: Colors.white,
                  width: kMainStrokeWidth,
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: AssetImage('images/user_pb.jpg'),
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
