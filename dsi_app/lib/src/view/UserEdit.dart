//user_edit.dart
import 'package:flutter/material.dart';

class UserEdit extends StatefulWidget {
  final String userName;
  final Function(String) onUpdate;

  UserEdit({required this.userName, required this.onUpdate});

  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.userName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    widget.onUpdate(_controller.text);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuário'),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Nome do Usuário'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _save,
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
