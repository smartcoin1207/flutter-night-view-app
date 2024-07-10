import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; // For formatting DateTime
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/club_data.dart';
import 'package:nightview/widgets/favorite_club_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ClubHeader extends StatelessWidget {
  final ClubData club;

  const ClubHeader({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    final String currentWeekday =
        DateFormat('EEEE').format(DateTime.now()).toLowerCase();
    final Map<String, dynamic>? todayHours =
        club.openingHours[currentWeekday] as Map<String, dynamic>?;

    String openingHoursText;
    if (todayHours == null || todayHours.isEmpty) {
      openingHoursText = 'Åbningstider i dag: Lukket'; // Closed today
    } else {
      final String openTime = todayHours['open'] ?? '00:00';
      final String closeTime = todayHours['close'] ?? '00:00';
      openingHoursText = 'Åbningstider i dag: $openTime - $closeTime';
    }

    final percentOfCapacity = (club.totalPossibleAmountOfVisitors > 0)
        ? club.visitors / club.totalPossibleAmountOfVisitors
        : 10.00;

    print(club.visitors);
    print(club.totalPossibleAmountOfVisitors);
    print(percentOfCapacity);

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: SingleChildScrollView(
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
            Text(
              club.name,
              style: kTextStyleH1,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kMainPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(club.logo),
                    radius: 25.0,
                  ),
                  const SizedBox(width: kNormalSpacerValue),
                  const FavoriteClubButton(),
                  CircularPercentIndicator(
                    radius: 30.0,
                    lineWidth: 5.0,
                    percent: percentOfCapacity,
                    center: Text(
                      '${(percentOfCapacity * 100).toStringAsFixed(0)}%',
                      style: kTextStyleH3,
                    ),
                    progressColor: secondaryColor,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: kSmallSpacerValue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type: ${club.typeOfClub}',
                    style: kTextStyleH3,
                  ),
                  Text(
                    'Aldersgrænse: ${club.ageRestriction}+',
                    style: kTextStyleH3,
                  ),
                  Text(
                    openingHoursText,
                    style: kTextStyleH3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(club.rating, (index) {
                      return const Icon(
                        Icons.star,
                        color: secondaryColor,
                        size: 20.0,
                      );
                    }),
                  ),
                ],
              ),
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
      ),
    );
  }
}
