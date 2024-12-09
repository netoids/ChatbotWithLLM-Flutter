import 'dart:convert';
//import 'package:flutter_ollama_ai/screens/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:dsi_app/src/Controller/ollama_controller.dart';
import 'package:dsi_app/src/models/Chatbot_model.dart';

class EnterPage extends StatefulWidget {
  const EnterPage({super.key});
  static const routeName = '/EnterPage';

  @override
  State<EnterPage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<EnterPage> {
  // TextEditingController para obter o texto do campo de mensagem
  final messageController = TextEditingController();

  // ScrollController para sempre mantermos a lista visível, conforme a IA vai gerando a resposta
  final scrollController = ScrollController();

  final formKey = GlobalKey<FormState>();

  // Armazenará as mensagens do chat
  List<ChatbotMessageModel> messages = [];

  @override
  void dispose() {
    messageController.dispose();

    super.dispose();
  }

  // Método chamado sempre que o usuário fizer uma nova mensagem
  void onNewMessage() {
    FocusManager.instance.primaryFocus!.unfocus(); // Retira o focus do TextField

    if (!formKey.currentState!.validate()) return;

    final question = messageController.text;

    setState(() {
      // Adiciona a mensagem do usuário a lista de mensagens
      messages.add(ChatbotMessageModel.usuario(question));
    });

    // Cria uma nova mensagem, de IA, que futuramente terá as respostas adicionadas conforme a Stream de dados
    final messageIa = ChatbotMessageModel.ia();

    setState(() {
      messages.add(messageIa);
    });

    // Faz a requisição pra API, obtendo uma Stream<String>? como resposta
    final stream = OllamaController().generateResponse(question);

    // Ouve a Stream
    stream?.listen(
      (data) {
        // Decodifica a resposta e adiciona a resposta na mensagem criada para a IA
        final iaResponse = IAResponseModel.fromWeb(jsonDecode(data));
        setState(() {
          messageIa.addIAResponse(iaResponse);
        });

        // A cada nova resposta da IA, mantém a ListView sempre visível (final do conteúdo)
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      },
      onError: (err) {
        // Tratamento de erros na geração de respostas
      },
      onDone: () {
        // Ao finalizar a geração das respostas
      },
    );

    // Limpa o prompt de mensagem após a inserção
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
        title: const Text('LUMI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 3, 133, 150), 
        elevation: 5,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 186, 112, 186),
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
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  hintText: 'Insira sua mensagem...',
                  labelText: 'Mensagem',
                  labelStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  border: borderDecoration,
                  errorBorder: borderDecoration,
                  enabledBorder: borderDecoration,
                  focusedBorder: borderDecoration,
                  disabledBorder: borderDecoration,
                  focusedErrorBorder: borderDecoration,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: onNewMessage,
                    tooltip: 'Enviar',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }}
class CardMessage extends StatelessWidget {
  const CardMessage({
    required this.message,
    super.key,
  });

  final ChatbotMessageModel message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 300),
        child: Card(
          elevation: 1,
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
                  data: message.isUser ? message.question! : message.fullIaResponseText,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}