import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';

class IconWithText extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final VoidCallback? onTap;

  IconWithText({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          FaIcon(
            icon,
            color: iconColor,
            size: 80.0,
          ),
          SizedBox(
            height: kSmallSpacerValue,
          ),
          Text(
            text,
            style: kTextStyleH3,
          ),
        ],
      ),
    );
  }
}
