import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CarteConteneursPage extends StatelessWidget {
  final List<Map<String, dynamic>> conteneurs = [
    {"name": "Conteneur 1", "lat": 5.4571, "lng": -4.008442},
    {"name": "Conteneur 2", "lat": 5.365, "lng": -4.01},
    {"name": "Conteneur 3", "lat": 5.40, "lng": -4.02},
    {"name": "Conteneur 4", "lat": 5.350, "lng": -4.015},
    {"name": "Conteneur 5", "lat": 5.362, "lng": -4.005},
    {"name": "Conteneur 6", "lat": 5.358, "lng": -4.012},
    {"name": "Conteneur 7", "lat": 5.361, "lng": -4.08},
    {"name": "Conteneur 8", "lat": 5.364, "lng": -4.011},
    {"name": "Conteneur 9", "lat": 5.357, "lng": -4.09},
    {"name": "Conteneur 10", "lat": 5.356, "lng": -4.107},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carte des Conteneurs à Abidjan"),
        backgroundColor: Colors.teal,
      ),
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: LatLng(5.359971, -4.008442),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
            userAgentPackageName: 'com.example.app',
          ),
          TileLayer(
            urlTemplate:
                'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: conteneurs.map((conteneur) {
              return Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(conteneur['lat'], conteneur['lng']),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(conteneur['name']),
                        content: const Text('Conteneur trouvé à cet emplacement.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Fermer"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
