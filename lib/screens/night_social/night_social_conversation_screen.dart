import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/chat_message_data.dart';

class NightSocialConversationScreen extends StatefulWidget {
  static const id = 'night_social_conversation_screen';

  const NightSocialConversationScreen({super.key});

  @override
  State<NightSocialConversationScreen> createState() =>
      _NightSocialConversationScreenState();
}

class _NightSocialConversationScreenState
    extends State<NightSocialConversationScreen> {
  List<ChatMessageData> messages = [];

  @override
  void initState() {
    for (int i = 0; i < 20; i++) {
      String m = "";

      for (int j = 0; j < i; j++) {
        m += j.toString();
        m += j.toString();
        m += j.toString();
        m += j.toString();
        m += j.toString();
        m += j.toString();
      }

      messages.add(
        ChatMessageData(
          sender: i % 3 == 0 ? 'Gunnar' : 'Max',
          receiver: i % 3 != 0 ? 'Gunnar' : 'Max',
          message: '${m} ${i}',
          timestamp: DateTime.now(),
        ),
      );
    }
    messages = messages.reversed.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(kMainPadding),
              child: Container(
                padding: EdgeInsets.all(kMainPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kMainBorderRadius),
                  border: Border.all(
                    width: kMainStrokeWidth,
                    color: Colors.white,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('images/user_pb.jpg'),
                    ),
                    SizedBox(
                      width: kNormalSpacerValue,
                    ),
                    Text(
                      'Gunnar Nielsen',
                      style: kTextStyleH2,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.all(kMainPadding),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        ChatMessageData message = messages[index];
                        bool bySelf = message.sender == 'Max';

                        return Column(
                          children: [
                            Text(
                              message.getReadableTimestamp(),
                              style: kTextStyleP2.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              height: kNormalSpacerValue,
                            ),
                            Align(
                              alignment: bySelf
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.all(kMainPadding),
                                constraints: BoxConstraints(
                                  minWidth: 40.0,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.75,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    kMainBorderRadius,
                                  ),
                                  border: Border.all(
                                    width: kMainStrokeWidth,
                                    color: bySelf ? primaryColor : Colors.white,
                                  ),
                                ),
                                child: Text(
                                  message.message,
                                  softWrap: true,
                                  style: kTextStyleP1.copyWith(
                                    color: bySelf ? primaryColor : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        height: kNormalSpacerValue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(kMainPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: kMainInputDecoration.copyWith(
                              hintText: 'Aa',
                            ),
                            cursorColor: primaryColor,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            print('SEND MESSAGE!');
                          },
                          child: FaIcon(
                            FontAwesomeIcons.solidPaperPlane,
                            color: primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
