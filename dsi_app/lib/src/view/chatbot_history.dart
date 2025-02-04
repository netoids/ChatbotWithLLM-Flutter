import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/messages.dart';
import 'chat_detail.dart';

class ChatHistory extends StatelessWidget {
  const ChatHistory({Key? key}) : super(key: key);

  static const routeName = '/ChatHistory';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado.')),
      );
    }
final arguments = ModalRoute.of(context)?.settings.arguments;
final String profileName = arguments is String ? arguments : 'defaultProfile'; // ajuste conforme sua lógica

    final conversationsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('profiles')
        .doc(profileName)
        .collection('conversations')
        .orderBy('startDate', descending: true)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Conversas', style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: conversationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('Nenhuma conversa para exibir.'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final conversation = Conversation.fromMap(data);
              final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(conversation.startDate);
              return ListTile(
                title: Text('Conversa iniciada em: $formattedDate'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // Navega para a tela de detalhes da conversa, passando os dados
                  Navigator.pushNamed(
                    context,
                    ChatDetail.routeName,
                    arguments: conversation,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
