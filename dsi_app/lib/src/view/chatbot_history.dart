import 'package:flutter/material.dart';

class ChatHistory extends StatefulWidget {
  static const routeName = '/ChatHistory';

  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.popAndPushNamed(context, "/EnterPage")),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 10, // Placeholder count
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Conversa ${index + 1}'),
              subtitle:
                  Text('Data: ${DateTime.now().toString().split(' ')[0]}'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle conversation tap
              },
            ),
          );
        },
      ),
    );
  }
}
