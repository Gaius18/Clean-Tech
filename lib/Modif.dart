import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPointsPage extends StatefulWidget {
  const AddPointsPage({Key? key}) : super(key: key);

  @override
  State<AddPointsPage> createState() => _AddPointsPageState();
}

class _AddPointsPageState extends State<AddPointsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _addPoints() async {
    final String name = _nameController.text.trim();
    final String pointsText = _pointsController.text.trim();

    if (name.isEmpty || pointsText.isEmpty) {
      setState(() {
        _errorMessage = "Veuillez remplir tous les champs.";
      });
      return;
    }

    final int? points = int.tryParse(pointsText);
    if (points == null || points <= 0) {
      setState(() {
        _errorMessage = "Veuillez entrer un nombre de points valide.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Rechercher l'utilisateur par nom
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('nom', isEqualTo: name)
              .get();

      if (querySnapshot.docs.isEmpty) {
        setState(() {
          _errorMessage = "Aucun utilisateur trouvé avec ce nom.";
        });
        return;
      }

      // Mettre à jour les points de l'utilisateur
      final userDoc = querySnapshot.docs.first;
      final currentPoints = userDoc['points'] ?? 0;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userDoc.id)
          .update({'points': currentPoints + points});

      setState(() {
        _errorMessage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Points ajoutés avec succès à $name !")),
      );

      _nameController.clear();
      _pointsController.clear();
    } catch (e) {
      setState(() {
        _errorMessage = "Une erreur est survenue : $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter des points"),
        backgroundColor: const Color.fromARGB(255, 66, 218, 27),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Ajouter des points à un utilisateur",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Nom de l'utilisateur",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pointsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Nombre de points à ajouter",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: _addPoints,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 66, 218, 27),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Ajouter des points",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
