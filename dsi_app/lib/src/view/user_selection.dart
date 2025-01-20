import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsi_app/src/view/login_page.dart';
import 'package:dsi_app/src/view/user_chatbot_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String? userId; // ID do usuário logado

  @override
  void initState() {
    super.initState();
  }

  // Função para ouvir mudanças em tempo real na subcoleção "profiles"
  Stream<List<Map<String, dynamic>>> _getUsersStream() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // Se o usuário não estiver logado, retorna um stream vazio
      return Stream.value([]);
    }

    userId = user.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // Usar o UID do usuário logado
        .collection('profiles') // Subcoleção "profiles"
        .snapshots()
        .map((snapshot) {
      final users = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      if (users.isEmpty) {
        // Adiciona dinamicamente o perfil "Visitante" se não houver nenhum usuário
        users.add({'name': 'Visitante'});
      }
      return users;
    });
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 163, 160),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
        centerTitle: true,
        title: const Text(
          'Selecione o Perfil',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await _logout();
              },
              tooltip: 'Sair',
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _getUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                }

                final users = snapshot.data ?? [];

                return GridView.builder(
                  padding: const EdgeInsets.all(16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: users.length + 1, // +1 para o botão de adicionar
                  itemBuilder: (context, index) {
                    if (index < users.length) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EnterPage(userName: users[index]['name']),
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
                              users[index]['name'] ?? 'Nome não disponível',
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
                            // Chama _fetchUsers para atualizar a lista de usuários após adicionar um novo perfil
                            // Aqui não é mais necessário, pois o StreamBuilder já está ouvindo as mudanças
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
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              width: size.width,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 50, 201, 199),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                onPressed: () async {
                  if (userId != null) {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserResponsible(
                          userId: userId!,
                        ),
                      ),
                    );
                    setState(() {});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Erro: Não foi possível recuperar o ID do usuário.'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Entrar como responsável',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
