import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/messages.dart';
import 'chat_detail.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({Key? key}) : super(key: key);

  static const routeName = '/ChatHistory';

  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  DateTimeRange? _selectedDateRange;

  Future<void> _pickDateRange() async {
    final initialDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    );
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange ?? initialDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 0, 163, 160), // Cor primária
              onPrimary: Colors.white, // Cor do texto no botão primário
              surface: Colors.white, // Cor de fundo do DatePicker
              onSurface: Colors.black, // Cor do texto no DatePicker
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _clearFilter() {
    setState(() {
      _selectedDateRange = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não autenticado.')),
      );
    }

    // Recupera o nome do perfil passado como argumento
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final String profileName =
        arguments is String ? arguments : 'defaultProfile';

    // Query base para as conversas
    Query conversationsQuery = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('profiles')
        .doc(profileName)
        .collection('conversations');

    // Se houver filtro, ajusta o query para incluir o intervalo de datas
    if (_selectedDateRange != null) {
      // Define o final do dia para o dia selecionado (23:59:59)
      final startDate = _selectedDateRange!.start;
      final endDate = DateTime(
        _selectedDateRange!.end.year,
        _selectedDateRange!.end.month,
        _selectedDateRange!.end.day,
        23,
        59,
        59,
      );

      conversationsQuery = conversationsQuery
          .where('startDate',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
    }

    // Ordena as conversas por data (mais recentes primeiro)
    conversationsQuery =
        conversationsQuery.orderBy('startDate', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Histórico de Conversas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: _pickDateRange,
          ),
          if (_selectedDateRange != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearFilter,
            ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedDateRange != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Filtrado de ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start)} '
                'até ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end)}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: conversationsQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(
                      child: Text('Nenhuma conversa para exibir.'));
                }
                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final data = doc.data() as Map<String, dynamic>;
                    final conversation = Conversation.fromMap(data);
                    final formattedDate = DateFormat('dd/MM/yyyy HH:mm')
                        .format(conversation.startDate);
                    return Dismissible(
                      key: Key(doc.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .collection('profiles')
                              .doc(profileName)
                              .collection('conversations')
                              .doc(doc.id)
                              .delete();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Conversa deletada')),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Erro ao deletar conversa: $e')),
                          );
                        }
                      },
                      child: ListTile(
                        title: Text('Conversa iniciada em: $formattedDate'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ChatDetail.routeName,
                            arguments: {
                              'conversation': conversation,
                              'conversationId': doc.id,
                              'profileName': profileName,
                            },
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
