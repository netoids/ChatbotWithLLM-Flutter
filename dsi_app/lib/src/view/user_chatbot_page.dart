import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:dsi_app/src/Controller/ollama_controller.dart';
import 'package:dsi_app/src/models/chatbot_model.dart';

class EnterPage extends StatefulWidget {
  final String userName; // Parâmetro recebido

  const EnterPage({super.key, required this.userName});

  static const routeName = '/EnterPage';

  @override
  State<EnterPage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<EnterPage> {
  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final formKey = GlobalKey<FormState>();
  List<ChatbotMessageModel> messages = [];

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void onNewMessage() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!formKey.currentState!.validate()) return;

    final question = messageController.text;

    setState(() {
      messages.add(ChatbotMessageModel.usuario(question));
    });

    final messageIa = ChatbotMessageModel.ia();

    setState(() {
      messages.add(messageIa);
    });

    final stream = OllamaController().generateResponse(question);

    stream?.listen(
      (data) {
        final iaResponse = IAResponseModel.fromWeb(jsonDecode(data));
        setState(() {
          messageIa.addIAResponse(iaResponse);
        });

        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      },
    );

    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final borderDecoration = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: BorderSide(
        color: Colors.grey[800]!,
        width: 2,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.list),
          onPressed: () {
            Navigator.popAndPushNamed(context, "/ChatHistory");
          },
        ),
        title: Text(
          'LUMI - ${widget.userName}', // Exibe o nome do usuário
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 133, 150),
        elevation: 5,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.popAndPushNamed(context, "/Config");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(500, 50, 201, 199),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(10),
                  itemCount: messages.length,
                  itemBuilder: (_, index) {
                    final message = messages[index];
                    return CardMessage(message: message);
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 5),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Form(
              key: formKey,
              child: TextFormField(
                controller: messageController,
                validator: (message) {
                  if (message!.trim().isEmpty) {
                    return 'Informe uma mensagem';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Insira sua mensagem...',
                  labelText: 'Mensagem',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  border: borderDecoration,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: onNewMessage,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CardMessage extends StatelessWidget {
  const CardMessage({required this.message, super.key});

  final ChatbotMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 300),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.isUser ? 'Você' : 'Lumi',
                  style: TextStyle(
                    color: Colors.blue[500],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                MarkdownBody(
                  data: message.isUser
                      ? message.question!
                      : message.fullIaResponseText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
