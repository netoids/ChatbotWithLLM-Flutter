import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _dateController =
      TextEditingController(); // Controlador para o campo de data

  // Função para exibir o seletor de data
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Data inicial (hoje)
      firstDate: DateTime(1900), // Data mínima permitida
      lastDate: DateTime(2101), // Data máxima permitida
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}"; // Formato dd/MM/yyyy
      });
    }
  }

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
      body: Center(
        // Centraliza o conteúdo verticalmente
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centraliza verticalmente
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centraliza horizontalmente
            children: [
              // Campo de nome do usuário
              TextField(
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
              const SizedBox(height: 20), // Espaço entre os campos

              // Campo de data (com funcionalidade de selecionar data)
              GestureDetector(
                onTap: () => _selectDate(context), // Abre o seletor de data
                child: AbsorbPointer(
                  // Impede a edição direta no campo de texto
                  child: TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Data de Nascimento',
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      prefixIcon:
                          Icon(Icons.calendar_today, color: Colors.grey[700]),
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
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 56.0, // Altura do botão
        child: ElevatedButton(
          onPressed: () async {
            final userName = _controller.text.trim();
            final birthDate = _dateController.text.trim();

            if (userName.isEmpty || birthDate.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Por favor, preencha todos os campos.'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            try {
              // Obter o UID do usuário logado
              final User? user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Usuário não autenticado.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              final uid = user.uid;

              // Adicionar dados ao Firestore
              final docRef = FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid) // Caminho do UID do usuário logado
                  .collection('profiles') // Subcoleção "profiles"
                  .doc(); // Gerar ID automático para o perfil

              await docRef.set({
                'name': userName,
                'birthDate': birthDate,
                'createdAt': FieldValue.serverTimestamp(),
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Perfil adicionado com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pop(context); // Voltar para a tela anterior
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro ao adicionar perfil: $e'),
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
