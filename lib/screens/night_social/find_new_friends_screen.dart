
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/search_friends_helper.dart';
import 'package:provider/provider.dart';

class FindNewFriendsScreen extends StatefulWidget {
  static const id = 'find_new_friends_screen';

  const FindNewFriendsScreen({super.key});

  @override
  State<FindNewFriendsScreen> createState() => _FindNewFriendsScreenState();
}

class _FindNewFriendsScreenState extends State<FindNewFriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(kBigPadding),
              color: Colors.black,
              child: Text(
                'Find nye venner',
                style: kTextStyleH1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: EdgeInsets.all(kMainPadding),
              color: Colors.black,
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: primaryColor,
                    size: 35.0,
                  ),
                  SizedBox(
                    width: kSmallSpacerValue,
                  ),
                  Expanded(
                    child: TextField(
                      decoration: kSearchInputDecoration.copyWith(
                        hintText: 'Skriv navn',
                      ),
                      cursorColor: primaryColor,
                      onChanged: (String input) {
                        Provider.of<SearchFriendsHelper>(context, listen: false)
                            .updateSearch(context, input);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Text(
              Provider.of<SearchFriendsHelper>(context).searchString ??
                  'Ikke noget',
            ),
          ],
        ),
      ),
    );
  }
}
