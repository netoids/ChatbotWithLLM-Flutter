import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/messages.dart';

class ChatDetail extends StatelessWidget {
  const ChatDetail({Key? key}) : super(key: key);

  static const routeName = '/ChatDetail';

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final Conversation? conversation = arguments is Conversation ? arguments : null;

    if (conversation == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes da Conversa', style: TextStyle(color: Colors.white),),
          backgroundColor: const Color.fromARGB(255, 0, 163, 160),
        ),
        body: const Center(child: Text('Conversa não encontrada.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversa de ${DateFormat('dd/MM/yyyy HH:mm').format(conversation.startDate)}', style: const TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
      ),
      body: ListView.builder(
        itemCount: conversation.messages.length,
        itemBuilder: (context, index) {
          final message = conversation.messages[index];
          return Container(
            padding: const EdgeInsets.all(15),
            margin: EdgeInsets.symmetric(vertical: 15).copyWith(
              left: message.isUser ? 100 : 10,
              right: message.isUser ? 10 : 100,
            ),
            decoration: BoxDecoration(
              color: message.isUser
                  ? const Color.fromARGB(255, 0, 163, 160)
                  : Colors.grey.shade400,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                bottomLeft: message.isUser ? const Radius.circular(10) : Radius.zero,
                topRight: const Radius.circular(10),
                bottomRight: message.isUser ? Radius.zero : const Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: TextStyle(
                    fontSize: 16,
                    color: message.isUser ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  DateFormat('HH:mm').format(message.date),
                  style: TextStyle(
                    fontSize: 10,
                    color: message.isUser ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
