import 'package:flutter/material.dart';
import 'UserEdit.dart';
import 'UserManagement.dart';

class UserResponsible extends StatefulWidget {
  final List<String> users;
  static const routeName = '/UserResponsible';

  UserResponsible({required this.users});

  @override
  _UserResponsibleState createState() => _UserResponsibleState();
}

class _UserResponsibleState extends State<UserResponsible> {
  void _removeUser(int index) {
    setState(() {
      widget.users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gerenciar Usuários',
          style: TextStyle(color: Colors.white), // Cor da fonte para branco
        ),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
        centerTitle: true, // Centraliza o título
      ),
      body: ListView.separated(
        itemCount: widget.users.length,
        separatorBuilder: (context, index) => Divider(
          thickness: 1,
          color: Colors.grey.shade300,
        ),
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(widget.users[index]),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _removeUser(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.users[index]} foi removido'),
                  duration: Duration(seconds: 2),
                ),
              );
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
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                title: GestureDetector(
                  onTap: () {
                    // Navega para a tela de gerenciamento de usuário
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserManagement(
                          userName: widget.users[index],
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserEdit(
                          userName: widget.users[index],
                          onUpdate: (newName) {
                            setState(() {
                              widget.users[index] = newName;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Text(widget.users[index]),
                ),
                trailing: GestureDetector(
                  onTap: () {
                    // Navega para a tela de edição do usuário
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserEdit(
                          userName: widget.users[index],
                          onUpdate: (newName) {
                            setState(() {
                              widget.users[index] = newName;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  child: Icon(Icons.edit),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
