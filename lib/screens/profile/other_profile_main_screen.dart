import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/button_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/biography_helper.dart';
import 'package:nightview/models/profile_picture_helper.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class OtherProfileMainScreen extends StatefulWidget {
  static const id = 'other_profile_main_screen';

  const OtherProfileMainScreen({super.key});

  @override
  State<OtherProfileMainScreen> createState() => _OtherProfileMainScreenState();
}

class _OtherProfileMainScreenState extends State<OtherProfileMainScreen> {
  final TextEditingController biographyController = TextEditingController();
  
  ImageProvider? profilePicture;

  @override
  void initState() {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      String? userId = Provider.of<GlobalProvider>(context, listen: false).chosenProfile?.id;
      
      if (userId == null) {
        return;
      }
      
      biographyController.text = await BiographyHelper.getBiography(userId) ?? '';
      profilePicture = await ProfilePictureHelper.getProfilePicture(userId).then((url) => url == null ? null : NetworkImage(url));
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<GlobalProvider>(context).chosenProfile == null ? 'Ugyldig bruger' : '${Provider.of<GlobalProvider>(context).chosenProfile?.firstName} ${Provider.of<GlobalProvider>(context).chosenProfile?.lastName}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(kMainPadding),
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
                              controller: biographyController,
                              decoration: InputDecoration.collapsed(hintText: 'Denne bruger har ikke angivet en biografi'),
                              readOnly: true,
                              maxLines: 8,
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
                        backgroundImage:
                            profilePicture ?? AssetImage('images/user_pb.jpg'),
                        radius: 60.0,
                      ),
                      SizedBox(
                        height: kNormalSpacerValue,
                      ),
                      FilledButton(
                        onPressed: () {},
                        style: kTransparentButtonStyle,
                        child: Row(
                          children: [
                            Text(
                              'Find',
                              style: kTextStyleH3,
                            ),
                            SizedBox(
                              width: kSmallSpacerValue,
                            ),
                            Icon(Icons.pin_drop),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(kMainPadding),
              child: FilledButton(
                onPressed: () {},
                style: kFilledButtonStyle,
                child: Padding(
                  padding: EdgeInsets.all(kMainPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tilføj ven',
                        style: kTextStyleH2,
                      ),
                      FaIcon(FontAwesomeIcons.userPlus),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
