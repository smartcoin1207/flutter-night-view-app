import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nightview/constants/button_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/biography_helper.dart';
import 'package:nightview/models/friends_helper.dart';
import 'package:nightview/models/profile_picture_helper.dart';
import 'package:nightview/models/user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/screens/night_social/find_new_friends_screen.dart';
import 'package:nightview/screens/profile/other_profile_main_screen.dart';
import 'package:provider/provider.dart';

class MyProfileMainScreen extends StatefulWidget {
  static const id = 'my_profile_main_screen';

  const MyProfileMainScreen({super.key});

  @override
  State<MyProfileMainScreen> createState() => _MyProfileMainScreenState();
}

class _MyProfileMainScreenState extends State<MyProfileMainScreen> {

  final TextEditingController biographyController = TextEditingController();

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      List<String> friendIds = await FriendsHelper.getAllFriendIds();
      List<UserData> friends = friendIds
          .map((id) => Provider.of<GlobalProvider>(context, listen: false)
              .userDataHelper
              .userData[id]!)
          .toList();
      Provider.of<GlobalProvider>(context, listen: false).setFriends(friends);

      String currentUserId = Provider.of<GlobalProvider>(context, listen: false).userDataHelper.currentUserId;
      biographyController.text = await BiographyHelper.getBiography(currentUserId) ?? "";
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(kMainPadding),
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kMainBorderRadius),
                        border: Border.all(
                          color: Colors.white,
                          width: kMainStrokeWidth,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: kSmallSpacerValue,
                          ),
                          Text(
                            'Biografi',
                            style: kTextStyleH3,
                          ),
                          Divider(
                            color: Colors.white,
                            thickness: kMainStrokeWidth,
                          ),
                          Padding(
                            padding: EdgeInsets.all(kMainPadding),
                            child: TextField(
                              onChanged: (String text) {
                                Provider.of<GlobalProvider>(context,
                                        listen: false)
                                    .setBiographyChanged(true);
                              },
                              controller: biographyController,
                              maxLines: 8,
                              maxLength: 100,
                              textCapitalization: TextCapitalization.sentences,
                              cursorColor: primaryColor,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Skriv her',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: kNormalSpacerValue,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: Provider.of<GlobalProvider>(context).profilePicture,
                        radius: 60.0,
                      ),
                      SizedBox(
                        height: kNormalSpacerValue,
                      ),
                      FilledButton(
                        onPressed: () async {
                          if (await ProfilePictureHelper
                              .pickCropResizeCompressAndUploadPb()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Profilbillede opdateret',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.black,
                              ),
                            );
                            String currentUserId = Provider.of<GlobalProvider>(context, listen: false).userDataHelper.currentUserId;
                            String? pbUrl = await ProfilePictureHelper.getProfilePicture(currentUserId);
                            Provider.of<GlobalProvider>(context, listen: false).setProfilePicture(pbUrl);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Der skete en fejl under ændring af profilbillede',
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.black,
                              ),
                            );
                          }
                        },
                        style: kTransparentButtonStyle,
                        child: Text(
                          'Skift PB',
                          style: kTextStyleH3,
                        ),
                      ),
                      SizedBox(
                        height: kSmallSpacerValue,
                      ),
                      Visibility(
                        visible: Provider.of<GlobalProvider>(context)
                            .biographyChanged,
                        child: FilledButton(
                          onPressed: () async {

                            if (await BiographyHelper.setBiography(biographyController.text)) {

                              Provider.of<GlobalProvider>(context, listen: false)
                                  .setBiographyChanged(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Biografi opdateret',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Der skete en fejl under opdatering af biografi',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              );
                            }
                          },
                          style: kTransparentButtonStyle,
                          child: Text(
                            'Gem',
                            style: kTextStyleH3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(kBigPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Venner',
                    style: kTextStyleH1,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(FindNewFriendsScreen.id);
                    },
                    icon: FaIcon(FontAwesomeIcons.userPlus),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: Provider.of<GlobalProvider>(context).friends.isNotEmpty,
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
                      UserData user =
                          Provider.of<GlobalProvider>(context).friends[index];

                      return ListTile(
                        onTap: () {
                          Provider.of<GlobalProvider>(context, listen: false).setChosenProfile(user);
                          Navigator.of(context).pushNamed(OtherProfileMainScreen.id);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(kMainBorderRadius),
                          side: BorderSide(
                            width: kMainStrokeWidth,
                            color: Colors.white,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundImage: AssetImage('images/user_pb.jpg'),
                        ),
                        title: Text(
                          '${user.firstName} ${user.lastName}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(
                          height: kSmallSpacerValue,
                        ),
                    itemCount:
                        Provider.of<GlobalProvider>(context).friends.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
