import 'package:dsi_app/src/view/user_chatbot_page.dart';
import 'package:flutter/material.dart';
import 'add_user_screen.dart';
import 'user_selection_responsible.dart';

class UserSelectionScreen extends StatefulWidget {
  const UserSelectionScreen({super.key});
  static const routeName = '/UserSelection';

  @override
  _UserSelectionScreenState createState() => _UserSelectionScreenState();
}

class _UserSelectionScreenState extends State<UserSelectionScreen> {
  // Lista de usuários
  List<String> users = [];

  void _addUser(String name) {
    setState(() {
      users.add(name);
    });
  }

  void _removeUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 163, 160),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
        centerTitle: true,
        title: const Text(
          'Selecione o Perfil',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: users.length + 1,
              itemBuilder: (context, index) {
                if (index < users.length) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EnterPage(userName: users[index]),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 7, 83, 81),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          users[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddUserScreen()),
                      );
                      if (result != null && result is String) {
                        _addUser(result);
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 30.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        const Text(
                          "Adicionar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserResponsible(users: users),
                  ),
                );
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text('Entrar como responsável'),
            ),
          ),
        ],
      ),
    );
  }
}
