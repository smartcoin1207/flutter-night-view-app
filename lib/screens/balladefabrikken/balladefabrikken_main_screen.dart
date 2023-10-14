import 'dart:math';

import 'package:flutter/material.dart';
import 'package:nightview/constants/button_styles.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/providers/balladefabrikken_provider.dart';
import 'package:nightview/screens/balladefabrikken/shot_accumulation_screen.dart';
import 'package:provider/provider.dart';

class BalladefabrikkenMainScreen extends StatefulWidget {
  static String id = 'balladefabrikken_main_screen';
  const BalladefabrikkenMainScreen({super.key});

  @override
  State<BalladefabrikkenMainScreen> createState() => _BalladefabrikkenMainScreenState();
}

class _BalladefabrikkenMainScreenState extends State<BalladefabrikkenMainScreen> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _shotFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<BalladefabrikkenProvider>(context, listen: false).redemtionCount = min(10, Provider.of<BalladefabrikkenProvider>(context, listen: false).points);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NightView x Balladefabrikken'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(kMainPadding),
                    child: Text(
                      'Del NightView',
                      style: kTextStyleH2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kMainPadding),
                    child: Text(
                      'Send et link til dine venner og bed dem om at indtaste din kode for at få endnu flere shots!',
                      style: kTextStyleP1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kMainPadding),
                    child: Form(
                      key: _phoneFormKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: kMainInputDecoration.copyWith(
                                hintText: 'Indtast telefonnummer',
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Skriv venligst et telefonnummer';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Ugyldigt tlf-nummer';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: kSmallSpacerValue,
                          ),
                          FilledButton(
                            onPressed: () {
                              bool? valid = _phoneFormKey.currentState?.validate();
                              if (valid == null) {
                                return;
                              }
                            },
                            style: kFilledButtonStyle.copyWith(
                              fixedSize: MaterialStatePropertyAll(
                                Size(60.0, 60.0),
                              ),
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 32,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kNormalSpacerValue,
                  ),
                  Padding(
                    padding: EdgeInsets.all(kMainPadding),
                    child: Text(
                      'Giv et shot',
                      style: kTextStyleH2,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(kMainPadding),
                    child: Form(
                      key: _shotFormKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: kMainInputDecoration.copyWith(
                                hintText: 'Indtast kode',
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Skriv venligst en kode';
                                }
                                if (!RegExp(r'^[A-Za-z0-9]+$').hasMatch(value)) {
                                  return 'Ugyldig kode';
                                }
                                if (false) {
                                  // Søg efter vennekode
                                  return 'Vennekode findes ikke';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: kSmallSpacerValue,
                          ),
                          FilledButton(
                            onPressed: () {
                              bool? valid = _shotFormKey.currentState?.validate();
                              if (valid == null) {
                                return;
                              }
                            },
                            style: kFilledButtonStyle.copyWith(
                              fixedSize: MaterialStatePropertyAll(
                                Size(60.0, 60.0),
                              ),
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_right,
                              size: 32,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(kMainPadding),
              color: Colors.black,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(kMainPadding),
                    child: Text(
                      'Du har optjent: ${Provider.of<BalladefabrikkenProvider>(context).points} point',
                      style: kTextStyleH2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(kMainPadding),
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(ShotAccumulationScreen.id);
                      },
                      style: kFilledButtonStyle.copyWith(
                        fixedSize: MaterialStatePropertyAll(
                          Size(double.maxFinite, 60.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(kMainPadding),
                        child: Text(
                          'Indløs shots?',
                          style: kTextStyleH2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kBottomSpacerValue,
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
