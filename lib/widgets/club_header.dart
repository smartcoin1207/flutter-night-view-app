import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/widgets/favorite_club_button.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';

class ClubHeader extends StatelessWidget {
  final ClubData club;

  const ClubHeader({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FaIcon(
                FontAwesomeIcons.chevronDown,
                size: 30.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              club.name,
              style: kTextStyleH1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(club.logo),
                    radius: 25.0,
                  ),
                  SizedBox(
                    width: kSmallSpacerValue,
                  ),
                  FavoriteClubButton(),
                ],
              ),
              Visibility(
                visible: backgroundLocationEnabled,
                child: Row(
                  children: [
                    // Text(
                    //   'Kapacitet',
                    //   style: kTextStyleH3,
                    // ),
                    // SizedBox(
                    //   width: kSmallSpacerValue,
                    // ),
                    // CircularPercentIndicator(
                    //   radius: 25.0,
                    //   percent: 0.6,
                    //   center: Text('60%'),
                    //   progressColor: primaryColor,
                    //   backgroundColor: Colors.white,
                    // ),
                    Text(
                      'Besøgende',
                      style: kTextStyleH3,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: kSmallSpacerValue),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(kSubtleBorderRadius),
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: kMainStrokeWidth,
                          ),
                        ),
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: kMainPadding),
                          child: Text(
                            club.visitors.toString(),
                            style: kTextStyleH3,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: kMainPadding),
            child: Divider(
              height: kNormalSpacerValue * 2,
              color: Colors.white,
              thickness: kMainStrokeWidth,
            ),
          ),
        ],
      ),
    );
  }
}
