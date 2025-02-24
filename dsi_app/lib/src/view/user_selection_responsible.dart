// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dsi_app/src/view/map.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importando o pacote intl para formatação de datas
import 'user_edit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserResponsible extends StatefulWidget {
  final String userId; // ID do usuário logado
  static const routeName = '/UserResponsible';

  const UserResponsible({super.key, required this.userId});

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
          'location': {
            'latitude': doc['location']['latitude'], // Latitude
            'longitude': doc['location']['longitude'], // Longitude
          },
        };
      }).toList();

      // Aqui você pode fazer algo com fetchedUsers, como armazenar em uma variável de estado

      setState(() {
        users = fetchedUsers; // Atualiza a lista local
      });
    } catch (e) {
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
      body: Stack(
        children: [
          // A ListView que exibe os usuários
          users.isEmpty
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
                    // O restante do código permanece o mesmo
                    String formattedBirthDate = '';
                    if (users[index]['birthDate'] != null) {
                      if (users[index]['birthDate'] is String) {
                        formattedBirthDate = users[index]['birthDate'];
                      } else if (users[index]['birthDate'] is Timestamp) {
                        final birthDate = users[index]['birthDate'].toDate();
                        formattedBirthDate =
                            DateFormat('dd/MM/yyyy').format(birthDate);
                      }
                    }

                    return Dismissible(
                      key: Key(users[index]['id']),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        _removeUser(
                            index); // Remove do Firestore e da lista local
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
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UserEdit(
                                    userName: users[index]['name'],
                                    birthDate: formattedBirthDate,
                                    userImage: users[index]['image'] ??
                                        '', // Adicione esta linha
                                    userLocation:
                                        users[index]['location'] != null
                                            ? LatLng(
                                                users[index]['location']
                                                    ['latitude'],
                                                users[index]['location']
                                                    ['longitude'])
                                            : null,

                                    onUpdate: (newName, newBirthDate,
                                        newUserImage, newLocation) async {
                                      try {
                                        final userId = users[index]['id'];
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(widget.userId)
                                            .collection('profiles')
                                            .doc(userId)
                                            .update({
                                          'name': newName,
                                          'birthDate': newBirthDate,
                                          'image':
                                              newUserImage, // Adicione esta linha
                                          'location': newLocation,
                                        });

                                        setState(() {
                                          users[index]['name'] = newName;
                                          users[index]['birthDate'] =
                                              newBirthDate;
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                'Usuário atualizado com sucesso!'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                                  style: const TextStyle(color: Colors.grey),
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

          // O botão que se sobrepõe aos demais na parte inferior
          // Na classe _UserResponsibleState, onde o botão 'Visualização por mapa' está localizado
          // Na classe _UserResponsibleState, onde o botão 'Visualização por mapa' está localizado
          Positioned(
            left: 0,
            right: 0,
            bottom: 16,
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(
                          userId:
                              widget.userId), // Passando o userId para MapPage
                    ),
                  );
                },
                child: const Text(
                  'Visualizar locais seguros',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 50, 201, 199),
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
