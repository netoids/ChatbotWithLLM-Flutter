// models.dart
class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'isUser': isUser,
      'message': message,
      'date': date.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      isUser: map['isUser'],
      message: map['message'],
      date: DateTime.parse(map['date']),
    );
  }
}

class Conversation {
  final DateTime startDate;
  final List<Message> messages;

  Conversation({required this.startDate, required this.messages});

  Map<String, dynamic> toMap() {
    return {
      'startDate': startDate.toIso8601String(),
      'messages': messages.map((m) => m.toMap()).toList(),
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      startDate: DateTime.parse(map['startDate']),
      messages: List<Message>.from(
        (map['messages'] as List<dynamic>).map((item) => Message.fromMap(item)),
      ),
    );
  }
}
