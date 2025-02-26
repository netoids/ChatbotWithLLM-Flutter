import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserEdit extends StatefulWidget {
  final String userName;
  final String birthDate;
  final String userImage;
  final LatLng? userLocation;
  final Function(String, String, String, LatLng?) onUpdate;

  const UserEdit({
    super.key,
    required this.userName,
    required this.birthDate,
    required this.userImage,
    required this.userLocation,
    required this.onUpdate,
  });

  @override
  _UserEditState createState() => _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  late TextEditingController _nameController;
  late TextEditingController _birthDateController;
  File? _selectedFileImage;
  String? _selectedAssetImage;
  LatLng? _selectedLocation;

  final List<String> _predefinedImages = [
    'lib/src/assets/images/image1.jpeg',
    'lib/src/assets/images/image2.jpeg',
    'lib/src/assets/images/image3.jpeg',
    'lib/src/assets/images/image4.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userName);
    _birthDateController = TextEditingController(text: widget.birthDate);
    _selectedAssetImage =
        _predefinedImages.isNotEmpty ? _predefinedImages[0] : null;
    _selectedLocation = widget.userLocation;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF00A3A0), // Cor principal (mesma do AppBar)
              onPrimary: Colors.white, // Cor do texto nos botões
              surface: Colors.white, // Fundo do calendário
              onSurface: Colors.black, // Cor do texto
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Color(0xFF00A3A0), // Cor dos botões "CANCELAR" e "OK"
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _birthDateController.text =
            DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  void _save() {
    String imagePath =
        _selectedFileImage?.path ?? _selectedAssetImage ?? widget.userImage;
    widget.onUpdate(
      _nameController.text,
      _birthDateController.text,
      imagePath,
      _selectedLocation,
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title:
            const Text('Editar Usuário', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 163, 160),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Selecione o avatar',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.center,
                    children: _predefinedImages.map((image) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedAssetImage = image;
                            _selectedFileImage = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: _selectedAssetImage == image
                                ? Border.all(
                                    color: Color.fromARGB(255, 50, 201, 199),
                                    width: 3)
                                : null,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.asset(image, width: 60, height: 60),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: _nameController,
                      decoration:
                          const InputDecoration(labelText: 'Nome do Usuário'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: GestureDetector(
                      onTap: () => _selectBirthDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _birthDateController,
                          decoration: const InputDecoration(
                            labelText: 'Data de Nascimento',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _selectedLocation ??
                              const LatLng(-8.0476, -34.8770),
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
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: size.width,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 50, 201, 199),
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                  ),
                  onPressed: _save,
                  child: const Text('Salvar', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
