import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../models/messages.dart'; // Certifique-se de que Message e Conversation possuem os métodos toMap/fromMap

class ChatDetail extends StatefulWidget {
  static const routeName = '/ChatDetail';
  const ChatDetail({Key? key}) : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  late Conversation conversation;
  late String conversationId;
  late String profileName;
  final TextEditingController _messageController = TextEditingController();
  late final GenerativeModel model;

  @override
  void initState() {
    super.initState();
    // Inicializa o modelo Gemini utilizando a API key do .env
    final apiKey = dotenv.env['API_KEY']!;
    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Espera-se que os argumentos sejam passados como um Map com as chaves:
    // 'conversation' (objeto Conversation), 'conversationId' (String) e 'profileName' (String)
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic>) {
      conversation = args['conversation'] as Conversation;
      conversationId = args['conversationId'] as String;
      profileName = args['profileName'] as String;
    }
  }

  Future<void> sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Adiciona a mensagem do usuário na conversa localmente
    setState(() {
      conversation.messages.add(
        Message(isUser: true, message: messageText, date: DateTime.now()),
      );
    });
    _messageController.clear();

    // Envia o texto para o Gemini e aguarda a resposta
    final content = [Content.text(messageText)];
    final response = await model.generateContent(content);
    final geminiResponse = response.text ?? "";

    // Adiciona a resposta do Gemini na conversa localmente
    setState(() {
      conversation.messages.add(
        Message(isUser: false, message: geminiResponse, date: DateTime.now()),
      );
    });

    // Atualiza o documento da conversa no Firestore com a lista atualizada de mensagens
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final conversationDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('profiles')
          .doc(profileName)
          .collection('conversations')
          .doc(conversationId);

      final messagesMap = conversation.messages.map((m) => m.toMap()).toList();
      await conversationDoc.update({'messages': messagesMap});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Conversa de ${DateFormat('dd/MM/yyyy HH:mm').format(conversation.startDate)}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
      ),
      body: Column(
        children: [
          // Exibe a lista de mensagens
          Expanded(
            child: ListView.builder(
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
          ),
          // Campo de entrada e botão de envio para continuar a conversa
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Digite sua mensagem',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
