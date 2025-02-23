import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final String userId; // ID do usuário

  const MapPage({super.key, required this.userId}); // Construtor com userId

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  List<Marker> _markers = []; // Lista para armazenar marcadores
  bool _loading = true; // Flag de carregamento
  String _errorMessage = ''; // Mensagem de erro

  @override
  void initState() {
    super.initState();
    _fetchUserLocations(); // Buscando as localizações ao iniciar
  }

  Future<void> _fetchUserLocations() async {
    try {
      // Buscando os perfis do usuário específico
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('profiles')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Limpa a lista de marcadores
        _markers.clear();
        for (var doc in querySnapshot.docs) {
          final data = doc.data();
          if (data['location'] != null) {
            double latitude = data['location']['latitude'] ?? 0.0;
            double longitude = data['location']['longitude'] ?? 0.0;
            String name = data['name'] ?? 'Usuário sem nome'; // Obtém o nome

            // Adiciona o marcador à lista
            _markers.add(Marker(
              markerId: MarkerId(doc.id), // ID único para cada marcador
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(title: name), // Exibe o nome ao tocar
              onTap: () {
                // Você pode exibir um SnackBar ou um Dialog aqui
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name')),
                );
              },
            ));
          }
        }
        setState(() {
          _loading = false; // Carregamento concluído
        });
      } else {
        setState(() {
          _errorMessage = 'Perfil de usuário não encontrado';
          _loading = false; // Carregamento concluído
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao buscar localizações: $e';
        _loading = false; // Carregamento concluído
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    // Mova a câmera para a primeira localização se houver
                    if (_markers.isNotEmpty) {
                      _mapController.moveCamera(
                          CameraUpdate.newLatLngZoom(_markers[0].position, 12));
                    }
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0, 0), // Localização padrão
                    zoom: 2, // Zoom inicial
                  ),
                  markers: Set<Marker>.of(
                      _markers), // Converte a lista de marcadores em um conjunto
                ),
    );
  }
}
