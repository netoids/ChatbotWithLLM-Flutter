import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({required this.isUser, required this.message, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'isUser': isUser,
      'message': message,
      // Você pode também armazenar as datas como Timestamp se desejar
      'date': Timestamp.fromDate(date),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      isUser: map['isUser'],
      message: map['message'],
      date: map['date'] is Timestamp
          ? (map['date'] as Timestamp).toDate()
          : DateTime.parse(map['date']),
    );
  }
}

class Conversation {
  final DateTime startDate;
  final List<Message> messages;

  Conversation({required this.startDate, required this.messages});

  Map<String, dynamic> toMap() {
    return {
      // Armazena a data como Timestamp para facilitar os filtros
      'startDate': Timestamp.fromDate(startDate),
      'messages': messages.map((m) => m.toMap()).toList(),
    };
  }

  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      startDate: map['startDate'] is Timestamp
          ? (map['startDate'] as Timestamp).toDate()
          : DateTime.parse(map['startDate']),
      messages: List<Message>.from(
        (map['messages'] as List<dynamic>).map((item) => Message.fromMap(item)),
      ),
    );
  }
}
