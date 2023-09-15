import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/button_styles.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class MyProfileMainScreen extends StatefulWidget {
  static const id = 'my_profile_main_screen';

  const MyProfileMainScreen({super.key});

  @override
  State<MyProfileMainScreen> createState() => _MyProfileMainScreenState();
}

class _MyProfileMainScreenState extends State<MyProfileMainScreen> {
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
                        backgroundImage: AssetImage('images/user_pb.jpg'),
                        radius: 60.0,
                      ),
                      SizedBox(
                        height: kNormalSpacerValue,
                      ),
                      FilledButton(
                        onPressed: () {},
                        style: kTransparentButtonStyle.copyWith(),
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
                          onPressed: () {
                            Provider.of<GlobalProvider>(context, listen: false)
                                .setBiographyChanged(false);
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
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.userPlus),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
