import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedImage;
  LatLng? _selectedLocation;

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
      resizeToAvoidBottomInset: false,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 40),
          const Text(
            'Escolha um avatar',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: TextField(
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
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: GestureDetector(
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
          ),
          const SizedBox(height: 20),

          // Mapa do Google Maps
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Local seguro",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              height: 300,
              child: GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(
                      -8.0476, -34.8770), // Recife, PE como posição inicial
                  zoom: 12,
                ),
                onTap: (LatLng location) {
                  setState(() {
                    _selectedLocation = location;
                  });
                },
                markers: _selectedLocation != null
                    ? {
                        Marker(
                          markerId: const MarkerId("selected_location"),
                          position: _selectedLocation!,
                        ),
                      }
                    : {},
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              height: 60,
              child: ElevatedButton(
                onPressed: () async {
                  final userName = _controller.text.trim();
                  final birthDate = _dateController.text.trim();

                  if (userName.isEmpty ||
                      birthDate.isEmpty ||
                      _selectedImage == null ||
                      _selectedLocation == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Por favor, preencha todos os campos e selecione um local no mapa.'),
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
                      'location': {
                        'latitude': _selectedLocation!.latitude,
                        'longitude': _selectedLocation!.longitude,
                      },
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
                  backgroundColor: const Color.fromARGB(255, 50, 201, 199),
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  'Cadastrar',
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
