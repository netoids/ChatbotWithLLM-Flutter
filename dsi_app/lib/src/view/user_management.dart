//user_management.dart
import 'package:flutter/material.dart';

class UserManagement extends StatelessWidget {
  final String userName;

  UserManagement({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciar Usuário $userName'),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
      ),
      body: Center(
        child: Text(
          'Teste',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}
