import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/messages.dart'; // importe os modelos Message e Conversation

class EnterPage extends StatefulWidget {
  final String userName;

  const EnterPage({super.key, required this.userName});
  static const routeName = '/EnterPage';

  @override
  State<EnterPage> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<EnterPage> {
  final TextEditingController _userInput = TextEditingController();

  late final GenerativeModel model;

  /// Armazena as mensagens da conversa atual
  final List<Message> _currentMessages = [];

  @override
  void initState() {
    super.initState();
    final apiKey = dotenv.env['API_KEY']!;
    model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  }

  Future<void> sendMessage() async {
    final messageText = _userInput.text;
    if (messageText.isEmpty) return;

    setState(() {
      _currentMessages.add(
        Message(isUser: true, message: messageText, date: DateTime.now()),
      );
    });

    _userInput.clear();

    final content = [Content.text(messageText)];
    final response = await model.generateContent(content);

    setState(() {
      _currentMessages.add(
        Message(
          isUser: false,
          message: response.text ?? "",
          date: DateTime.now(),
        ),
      );
    });
  }

  /// Função para finalizar a conversa e salvá-la no Firestore
  Future<void> finishConversation() async {
    if (_currentMessages.isNotEmpty) {
      // Cria a conversa usando a data da primeira mensagem
      final conversation = Conversation(
        startDate: _currentMessages.first.date,
        messages: List.from(_currentMessages),
      );

      // Limpa a conversa atual
      setState(() {
        _currentMessages.clear();
      });

      // Obtém o usuário atual
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          // Supondo que cada perfil é identificado pelo nome (ou você pode usar outro identificador)
          final profileDoc = FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('profiles')
              .doc(widget.userName);

          // Salva a conversa na subcoleção "conversations" do perfil
          await profileDoc.collection('conversations').add(
                conversation.toMap(),
              );
        } catch (e) {
          // Trate o erro conforme necessário
          debugPrint("Erro ao salvar a conversa: $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LUMI', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.list_rounded),
          color: Colors.white,
          onPressed: () async {
            // Opcional: finalize a conversa atual antes de navegar para o histórico
            await finishConversation();
            // Navega para o histórico de conversas (a tela de histórico pode buscar os dados do Firestore)
            Navigator.pushNamed(context, '/ChatHistory', arguments: widget.userName,);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Colors.white,
            onPressed: () async {
              await finishConversation();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _currentMessages.length,
              itemBuilder: (context, index) {
                final message = _currentMessages[index];
                return Messages(
                  isUser: message.isUser,
                  message: message.message,
                  date: DateFormat('HH:mm').format(message.date),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _userInput,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      labelText: 'Digite a sua mensagem',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget para exibir cada mensagem
class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;

  const Messages({
    super.key,
    required this.isUser,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isUser ? 100 : 10,
        right: isUser ? 10 : 100,
      ),
      decoration: BoxDecoration(
        color: isUser
            ? const Color.fromARGB(255, 0, 163, 160)
            : Colors.grey.shade400,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
          topRight: const Radius.circular(10),
          bottomRight: isUser ? Radius.zero : const Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: isUser ? Colors.white : Colors.black,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 10,
              color: isUser ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
