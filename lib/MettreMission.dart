import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MettreMissionPage extends StatefulWidget {
  const MettreMissionPage({Key? key}) : super(key: key);

  @override
  State<MettreMissionPage> createState() => _MettreMissionPageState();
}

class _MettreMissionPageState extends State<MettreMissionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submitMission() async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();
    final String deadline = _deadlineController.text.trim();

    if (title.isEmpty || description.isEmpty || deadline.isEmpty) {
      setState(() {
        _errorMessage = "Veuillez remplir tous les champs.";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseFirestore.instance.collection('missions').add({
        'title': title,
        'description': description,
        'deadline': deadline,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mission ajoutée avec succès !")),
      );

      _titleController.clear();
      _descriptionController.clear();
      _deadlineController.clear();
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
        title: const Text("Créer une Mission"),
        backgroundColor: const Color.fromARGB(255, 66, 218, 27),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Nouvelle Mission",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _titleController,
                label: "Titre de la Mission",
                hint: "Entrez le titre de la mission",
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: "Description",
                hint: "Entrez une description détaillée",
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _deadlineController,
                label: "Date Limite",
                hint: "Entrez la date limite (ex: 2025-12-31)",
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _submitMission,
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
                      "Ajouter la Mission",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
