import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importando o pacote intl para formatação de datas
import 'user_edit.dart';

class UserResponsible extends StatefulWidget {
  final String userId; // ID do usuário logado
  static const routeName = '/UserResponsible';

  UserResponsible({required this.userId});

  @override
  _UserResponsibleState createState() => _UserResponsibleState();
}

class _UserResponsibleState extends State<UserResponsible> {
  List<Map<String, dynamic>> users =
      []; // Lista local para armazenar os usuários

  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Carregar os usuários ao iniciar a tela
  }

  // Função para buscar os usuários no Firestore
  Future<void> _fetchUsers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId) // Caminho do UID do usuário logado
          .collection('profiles') // Subcoleção "profiles"
          .get();

      final fetchedUsers = snapshot.docs.map((doc) {
        return {
          'id': doc.id, // ID do documento
          'name': doc['name'], // Nome do usuário
          'birthDate': doc['birthDate'], // Data de nascimento
        };
      }).toList();

      setState(() {
        users = fetchedUsers; // Atualiza a lista local
      });
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar usuários: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Função para remover um usuário do Firestore
  Future<void> _removeUser(int index) async {
    try {
      final userId = users[index]['id'];

      // Exibe a mensagem de sucesso ANTES de remover o item
      final userName = users[index]['name'];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$userName foi removido com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('profiles')
          .doc(userId)
          .delete();

      setState(() {
        users.removeAt(index); // Remove o usuário da lista local
      });
    } catch (e) {
      print('Erro ao remover usuário: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover usuário: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gerenciar Usuários',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
        centerTitle: true,
      ),
      body: users.isEmpty
          ? const Center(
              child: Text('Nenhum usuário encontrado.'),
            )
          : ListView.separated(
              itemCount: users.length,
              separatorBuilder: (context, index) => Divider(
                thickness: 1,
                color: Colors.grey.shade300,
              ),
              itemBuilder: (context, index) {
                // Verifique o tipo de dado de 'birthDate'
                String formattedBirthDate = '';
                if (users[index]['birthDate'] != null) {
                  if (users[index]['birthDate'] is String) {
                    // Se já for uma string no formato correto (dd/MM/yyyy), use diretamente
                    formattedBirthDate = users[index]['birthDate'];
                  } else if (users[index]['birthDate'] is Timestamp) {
                    // Se for um Timestamp, converta para DateTime
                    final birthDate = users[index]['birthDate'].toDate();
                    // Formatar a data no formato brasileiro (dd/MM/yyyy)
                    formattedBirthDate =
                        DateFormat('dd/MM/yyyy').format(birthDate);
                  }
                }

                return Dismissible(
                  key: Key(users[index]['id']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _removeUser(index); // Remove do Firestore e da lista local
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserEdit(
                                userName: users[index]['name'],
                                onUpdate: (newName) async {
                                  try {
                                    final userId = users[index]['id'];
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.userId)
                                        .collection('profiles')
                                        .doc(userId)
                                        .update({'name': newName});

                                    setState(() {
                                      users[index]['name'] =
                                          newName; // Atualiza localmente
                                    });

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Usuário atualizado com sucesso!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Erro ao atualizar usuário: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(users[index]['name']),
                            ),
                            Text(
                              formattedBirthDate.isNotEmpty
                                  ? formattedBirthDate
                                  : 'Data inválida',
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(
                              width: 15,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
