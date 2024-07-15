import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:nightview/widgets/icon_with_text.dart';
import 'package:provider/provider.dart';

class SwipeCardContent extends StatelessWidget {
  const SwipeCardContent({super.key});

  //TODO Put variables in here. Pictures and text

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/swipe_card_image.png'),
          fit: BoxFit.fitHeight,
        ),
        borderRadius: BorderRadius.circular(kMainBorderRadius),
      ),
      width: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.only(bottom: kSwipeBottomPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Skal du i byen i aften?',
              style: kTextStyleH2,
            ),
            SizedBox(
              height: kNormalSpacerValue,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconWithText(
                  icon: FontAwesomeIcons.xmark,
                  text: 'Ikke i dag',
                  iconColor: Colors.white,
                  onTap: () {
                    Provider.of<GlobalProvider>(context, listen: false)
                        .cardController
                        .swipeLeft();
                  },
                ),
                IconWithText(
                  icon: FontAwesomeIcons.solidHeart,
                  text: 'Jeg er frisk!',
                  iconColor: Colors.redAccent,
                  onTap: () {
                    Provider.of<GlobalProvider>(context, listen: false)
                        .cardController
                        .swipeRight();
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
