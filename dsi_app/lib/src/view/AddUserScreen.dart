// add_user_screen.dart
import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Fundo claro e agradável
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF00A3A0),
        title: const Text(
          'Novo Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment(0.0, 0.3), // Levemente abaixo do centro
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Nome do Usuário',
                  labelStyle: TextStyle(color: Colors.grey[700]),
                  prefixIcon: Icon(Icons.person, color: Colors.grey[700]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Color(0xFF00A3A0)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 56.0, // Altura do botão
        child: ElevatedButton(
          onPressed: () {
            final userName = _controller.text.trim();
            if (userName.isNotEmpty) {
              Navigator.pop(context, userName);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, insira um nome válido.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A3A0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero, // Sem bordas arredondadas
            ),
          ),
          child: const Text(
            'Adicionar',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
