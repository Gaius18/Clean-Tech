import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImpactEntreprisePage extends StatefulWidget {
  const ImpactEntreprisePage({Key? key}) : super(key: key);

  @override
  State<ImpactEntreprisePage> createState() => _ImpactEntreprisePageState();
}

class _ImpactEntreprisePageState extends State<ImpactEntreprisePage> {
  Map<String, dynamic>? _entrepriseData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEntrepriseData();
  }

  Future<void> _fetchEntrepriseData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc =
            await FirebaseFirestore.instance
                .collection('entreprises')
                .doc(user.uid)
                .get();

        if (doc.exists) {
          setState(() {
            _entrepriseData = doc.data();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint(
        "Erreur lors de la récupération des données de l'entreprise : $e",
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Impact de l'Entreprise"),
        backgroundColor: const Color.fromARGB(255, 66, 218, 27),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _entrepriseData == null
              ? const Center(
                child: Text(
                  "Aucune donnée trouvée pour l'entreprise.",
                  style: TextStyle(fontSize: 18),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildInfoCard(
                      "Nom de l'entreprise",
                      "${_entrepriseData!['nom']}",
                    ),
                    _buildInfoCard("Adresse", "${_entrepriseData!['adresse']}"),
                    _buildInfoCard("Email", "${_entrepriseData!['email']}"),
                    _buildInfoCard(
                      "Nombre d'employés",
                      "${_entrepriseData!['employes']}",
                    ),
                    _buildInfoCard(
                      "Type de l'entreprise",
                      "${_entrepriseData!['type']}",
                    ),
                    _buildInfoCard("ISO", "${_entrepriseData!['iso']}"),
                    _buildInfoCard(
                      "Localisation",
                      "${_entrepriseData!['localisation']}",
                    ),
                    const SizedBox(height: 20),
                    _buildImpactSection(),
                  ],
                ),
              ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.business, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            "${_entrepriseData!['nom']}",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            "${_entrepriseData!['email']}",
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        leading: const Icon(Icons.info, color: Colors.teal),
      ),
    );
  }

  Widget _buildImpactSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Impact de l'Entreprise",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "🌱 L'entreprise a un impact positif grâce à ses initiatives et ses employés.",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              "🎯 Continuez à contribuer pour un avenir meilleur !",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
