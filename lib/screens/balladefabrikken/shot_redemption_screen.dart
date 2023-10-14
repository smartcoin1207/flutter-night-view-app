import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/balladefabrikken_provider.dart';
import 'package:provider/provider.dart';
import 'package:slider_button/slider_button.dart';

class ShotRedemtionScreen extends StatefulWidget {
  static String id = 'shot_redemption_screen';
  const ShotRedemtionScreen({super.key});

  @override
  State<ShotRedemtionScreen> createState() => _ShotRedemtionScreenState();
}

class _ShotRedemtionScreenState extends State<ShotRedemtionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(kCardPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    Placeholder(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(kMainPadding),
                        child: Text(
                          '${Provider.of<BalladefabrikkenProvider>(context).redemtionCount < 10 ? '${Provider.of<BalladefabrikkenProvider>(context).redemtionCount} ${Provider.of<BalladefabrikkenProvider>(context).redemtionCount == 1 ? 'shot' : 'shots'}' : '1 flaske'}',
                          style: kTextStyleH2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: kNormalSpacerValue,
              ),
              SliderButton(
                width: MediaQuery.of(context).size.width * 0.8,
                height: kSliderHeight,
                backgroundColor: Colors.white.withAlpha(0x44),
                baseColor: primaryColor,
                buttonColor: primaryColor,
                vibrationFlag: true,
                label: Text(
                  '            Indløs',
                  style: kTextStyleH1,
                ),
                alignLabel: Alignment.centerLeft,
                icon: FaIcon(
                  FontAwesomeIcons.chevronRight,
                  //color: Colors.black,
                  size: kSliderHeight * 0.5,
                ),
                action: () {
                  Provider.of<BalladefabrikkenProvider>(context, listen: false).points -= Provider.of<BalladefabrikkenProvider>(context, listen: false).redemtionCount;
                  Provider.of<BalladefabrikkenProvider>(context, listen: false).redemtionCount = min(10, Provider.of<BalladefabrikkenProvider>(context, listen: false).points);
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(
                height: kBottomSpacerValue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
