
class ChatMessageData {

  final String sender;
  final String receiver;
  final String message;
  final DateTime timestamp;

  ChatMessageData({required this.sender, required this.receiver, required this.message, required this.timestamp});

  String getReadableTimestamp() {

    return '${getShortWeekday().toUpperCase()}${timestamp.hour}:${timestamp.minute}';

  }

  String getShortWeekday() {

    int dayToday = DateTime.now().weekday;

    if (dayToday == timestamp.weekday) {
      return '';
    }

    switch (timestamp.weekday) {
      case 1:
        return 'MAN ';
      case 2:
        return 'TIR ';
      case 3:
        return 'ONS ';
      case 4:
        return 'TOR ';
      case 5:
        return 'FRE ';
      case 6:
        return 'LØR ';
      case 7:
        return 'SØN ';
    }

    return '';

  }

}