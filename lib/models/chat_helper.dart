
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nightview/models/chat_message_data.dart';

class ChatHelper {

  static Future<String?> createNewChat(String otherId) async {
    final firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return null;
    }

    List<String> participants = [
      auth.currentUser!.uid,
      otherId,
    ]..sort();

    String? chatId = await getChatIdWithParticipants(participants);

    if (chatId != null) {
      return chatId;
    }

    try {
      DocumentReference<Map<String,dynamic>> ref = await firestore.collection('chats').add({
        'participants': participants,
      });
      return ref.id;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<String?> getChatIdWithParticipants(List<String> participants) async {
    final firestore = FirebaseFirestore.instance;

    QuerySnapshot chatsAlikeSnap = await firestore.collection('chats').where('participants', isEqualTo: participants).get();

    if (chatsAlikeSnap.size <= 0) {
      return null;
    }

    return chatsAlikeSnap.docs.first.id;

  }

  static Future<bool> sendChatMessage(ChatMessageData messageData, String chatId) async {
    final firestore = FirebaseFirestore.instance;

    try {
      await firestore.collection('chats').doc(chatId).collection('messages').add({
        'message': messageData.message,
        'sender': messageData.sender,
        'timestamp': Timestamp.fromDate(messageData.timestamp),
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }

  }

}