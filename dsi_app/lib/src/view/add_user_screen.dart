import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedImage;

  final List<String> _predefinedImages = [
    'lib/src/assets/images/image1.jpeg',
    'lib/src/assets/images/image2.jpeg',
    'lib/src/assets/images/image3.jpeg',
    'lib/src/assets/images/image4.jpeg',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF00A3A0),
        title: const Text(
          'Novo Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text('Escolha um avatar:', textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Center(
              child: Wrap(
                spacing: 10,
                alignment: WrapAlignment.center,
                children: _predefinedImages.map((image) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImage = image;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: _selectedImage == image
                            ? Border.all(color: Colors.blue, width: 3)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.asset(image, width: 60, height: 60),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nome do Usuário',
                prefixIcon: const Icon(Icons.person),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    prefixIcon: const Icon(Icons.calendar_today),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
                        const Spacer(), // Isso empurra os campos para o centro
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final userName = _controller.text.trim();
                final birthDate = _dateController.text.trim();
                if (userName.isEmpty ||
                    birthDate.isEmpty ||
                    _selectedImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, preencha todos os campos.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                try {
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
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('profiles')
                      .doc()
                      .set({
                    'name': userName,
                    'birthDate': birthDate,
                    'image': _selectedImage,
                    'createdAt': FieldValue.serverTimestamp(),
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Perfil adicionado com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
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
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
