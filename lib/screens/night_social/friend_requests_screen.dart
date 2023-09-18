import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/friend_request.dart';
import 'package:nightview/models/friend_request_helper.dart';
import 'package:nightview/models/friends_helper.dart';
import 'package:nightview/models/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class FriendRequestsScreen extends StatefulWidget {
  static const id = 'friend_requests_screen';
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  List<FriendRequest> friendRequests = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fetchRequests();
    });

    super.initState();
  }

  void fetchRequests() {
    Provider.of<GlobalProvider>(context, listen: false)
        .setFriendRequestsLoaded(false);

    FriendRequestHelper.getPendingFriendRequests().then((requests) {
      friendRequests = requests.reversed.toList();
      Provider.of<GlobalProvider>(context, listen: false)
          .setFriendRequestsLoaded(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(kBigPadding),
              color: Colors.black,
              width: double.maxFinite,
              child: Text(
                'Venneanmodninger',
                style: kTextStyleH2,
              ),
            ),
            Visibility(
              visible:
                  Provider.of<GlobalProvider>(context).friendRequestsLoaded,
              replacement: Expanded(
                child: SpinKitPouringHourGlass(
                  color: primaryColor,
                  size: 150.0,
                  strokeWidth: 2.0,
                ),
              ),
              child: Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(kMainPadding),
                  itemBuilder: (context, index) {
                    FriendRequest request = friendRequests[index];

                    try {
                      UserData fromUserData =
                          Provider.of<GlobalProvider>(context)
                              .userDataHelper
                              .userData[request.fromId]!;
                      // 0BC6Kd6hjWXlh0aSUf3W0ci8Qfr2
                      // 0EcW1tUBQFUwJ0VXjCQ9OxGH6DM2

                      return ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(kMainBorderRadius),
                            side: BorderSide(
                              width: kMainStrokeWidth,
                              color: Colors.white,
                            )),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/user_pb.jpg'),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${fromUserData.firstName} ${fromUserData.lastName}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                FriendRequestHelper.acceptFriendRequest(
                                        request.requestId)
                                    .then((value) => fetchRequests());
                                FriendsHelper.addFriend(request.fromId);
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.check,
                                color: primaryColor,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                FriendRequestHelper.rejectFriendRequest(
                                    request.requestId)
                                    .then((value) => fetchRequests());
                              },
                              icon: FaIcon(
                                FontAwesomeIcons.x,
                                color: Colors.redAccent,
                              ),
                            )
                          ],
                        ),
                      );
                    } catch (e) {
                      return null;
                    }
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: kSmallSpacerValue,
                    );
                  },
                  itemCount: friendRequests.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
