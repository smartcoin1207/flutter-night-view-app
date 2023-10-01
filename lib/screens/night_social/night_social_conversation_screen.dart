import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nightview/constants/colors.dart';
import 'package:nightview/constants/input_decorations.dart';
import 'package:nightview/constants/text_styles.dart';
import 'package:nightview/constants/values.dart';
import 'package:nightview/models/chat_helper.dart';
import 'package:nightview/models/chat_message_data.dart';
import 'package:nightview/models/chat_subscriber.dart';
import 'package:nightview/models/simple_user_data.dart';
import 'package:nightview/providers/global_provider.dart';
import 'package:provider/provider.dart';

class NightSocialConversationScreen extends StatefulWidget {
  static const id = 'night_social_conversation_screen';

  const NightSocialConversationScreen({super.key});

  @override
  State<NightSocialConversationScreen> createState() => _NightSocialConversationScreenState();
}

class _NightSocialConversationScreenState extends State<NightSocialConversationScreen> {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? chatSubscription;
  TextEditingController messageController = TextEditingController();
  String _lastMessageTimestamp = '';
  SimpleUserData otherUser = SimpleUserData.empty(); // HER ER DU NÅET TIL!

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String? chatId = Provider.of<GlobalProvider>(context, listen: false).chosenChatId;

      if (chatId == null) {
        return;
      }
      _lastMessageTimestamp = '';
      chatSubscription = Provider.of<ChatSubscriber>(context, listen: false).subscribeToChat(chatId);
    });
    super.initState();
  }

  @override
  void dispose() {
    if (chatSubscription != null) {
      chatSubscription!.cancel();
    }

    super.dispose();
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
                      itemCount: Provider.of<ChatSubscriber>(context).messages.length,
                      itemBuilder: (context, index) {
                        ChatMessageData? message = Provider.of<ChatSubscriber>(context, listen: false).messages.values.toList().reversed.toList()[index];

                        if (message == null) {
                          return null;
                        }

                        bool bySelf = message.sender == Provider.of<GlobalProvider>(context, listen: false).userDataHelper.currentUserId;

                        bool showTimestamp = message.getReadableTimestamp() != _lastMessageTimestamp;
                        _lastMessageTimestamp = message.getReadableTimestamp();

                        return Column(
                          children: [
                            Visibility(
                              visible: showTimestamp,
                              child: Text(
                                message.getReadableTimestamp(),
                                style: kTextStyleP2.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: kSmallSpacerValue,
                            ),
                            Align(
                              alignment: bySelf ? Alignment.topRight : Alignment.topLeft,
                              child: Container(
                                padding: EdgeInsets.all(kMainPadding),
                                constraints: BoxConstraints(
                                  minWidth: 40.0,
                                  maxWidth: MediaQuery.of(context).size.width * 0.75,
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
                        height: kSmallSpacerValue,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(kMainPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: messageController,
                            decoration: kMainInputDecoration.copyWith(
                              hintText: 'Aa',
                            ),
                            cursorColor: primaryColor,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            String? chatId = Provider.of<GlobalProvider>(context, listen: false).chosenChatId;
                            String? userId = Provider.of<GlobalProvider>(context, listen: false).userDataHelper.currentUserId;
                            if (chatId == null || userId == null) {
                              return;
                            }
                            ChatMessageData messageData = ChatMessageData(
                              sender: userId,
                              message: messageController.text,
                              timestamp: DateTime.now(),
                            );
                            if (await ChatHelper.sendChatMessage(messageData, chatId)) {
                              messageController.text = "";
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Kunne ikke sende besked',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.black,
                                ),
                              );
                            }
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
