import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VoirMissionPage extends StatefulWidget {
  const VoirMissionPage({Key? key}) : super(key: key);

  @override
  State<VoirMissionPage> createState() => _VoirMissionPageState();
}

class _VoirMissionPageState extends State<VoirMissionPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _missions = [];

  @override
  void initState() {
    super.initState();
    _fetchMissions();
  }

  Future<void> _fetchMissions() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('missions')
          .orderBy('createdAt', descending: true)
          .get();

      final missions = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'title': data['title'],
          'description': data['description'],
          'deadline': data['deadline'],
          'createdAt': data['createdAt'],
        };
      }).toList();

      setState(() {
        _missions = missions;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Erreur lors de la récupération des missions : $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des Missions"),
        backgroundColor: const Color.fromARGB(255, 66, 218, 27),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _missions.isEmpty
              ? const Center(
                  child: Text(
                    "Aucune mission trouvée.",
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _missions.length,
                  itemBuilder: (context, index) {
                    final mission = _missions[index];
                    return _buildMissionCard(mission);
                  },
                ),
    );
  }

  Widget _buildMissionCard(Map<String, dynamic> mission) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mission['title'],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              mission['description'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date limite : ${mission['deadline']}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "Créée le : ${_formatDate(mission['createdAt'])}",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "Inconnue";
    final date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year}";
  }
}