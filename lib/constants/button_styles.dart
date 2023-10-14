import 'package:flutter/material.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/values.dart';

const kLoginRegistrationButtonStyle = ButtonStyle(
  shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(kMainBorderRadius)),
    ),
  ),
);

const kTextFieldLookalikeButtonStyle = ButtonStyle(
  shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(kMainBorderRadius)),
    ),
  ),
  side: MaterialStatePropertyAll(
    BorderSide(
      color: Colors.white,
      width: kMainStrokeWidth,
    ),
  ),
  backgroundColor: MaterialStatePropertyAll(Colors.black),
  foregroundColor: MaterialStatePropertyAll(Colors.white),
  fixedSize: MaterialStatePropertyAll(
    Size(double.maxFinite, 60.0),
  ),
);

const kTransparentButtonStyle = ButtonStyle(
  shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(kMainBorderRadius),
      ),
    ),
  ),
  side: MaterialStatePropertyAll(
    BorderSide(color: Colors.white, width: kMainStrokeWidth),
  ),
  backgroundColor: MaterialStatePropertyAll(Colors.transparent),
  foregroundColor: MaterialStatePropertyAll(Colors.white),
);

ButtonStyle kFilledButtonStyle = ButtonStyle(
  shape: MaterialStatePropertyAll(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(kMainBorderRadius),
      ),
    ),
  ),
  backgroundColor: MaterialStateProperty.resolveWith((states) {
    if (states.contains(MaterialState.disabled)) {
      return Colors.grey;
    }
    return primaryColor;
  }),
  foregroundColor: MaterialStatePropertyAll(Colors.white),
);
