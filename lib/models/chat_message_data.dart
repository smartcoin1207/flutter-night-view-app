
class ChatMessageData {

  final String sender;
  final String receiver;
  final String message;
  final DateTime timestamp;

  ChatMessageData({required this.sender, required this.receiver, required this.message, required this.timestamp});

  String getReadableTimestamp() {

    return '${timestamp.hour} og så noget mere!';

  }

}