import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClassementPage extends StatefulWidget {
  const ClassementPage({Key? key}) : super(key: key);

  @override
  State<ClassementPage> createState() => _ClassementPageState();
}

class _ClassementPageState extends State<ClassementPage> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchClassement();
  }

  Future<void> _fetchClassement() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .orderBy('points', descending: true)
              .limit(10)
              .get();

      final users =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'nom': data['nom'],
              'prenom': data['prenom'],
              'points': data['points'],
            };
          }).toList();

      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Erreur lors de la récupération des données : $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Classement des utilisateurs"),
        backgroundColor: const Color.fromARGB(255, 66, 218, 27),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _users.isEmpty
              ? const Center(
                child: Text(
                  "Aucun utilisateur trouvé.",
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return _buildUserTile(user, index);
                },
              ),
    );
  }

  Widget _buildUserTile(Map<String, dynamic> user, int index) {
    final isTop3 = index < 3;
    final medalColors = [
      Colors.amber, // 1er
      Colors.grey, // 2ème
      Colors.brown, // 3ème
    ];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isTop3 ? medalColors[index] : Colors.blueGrey,
          child:
              isTop3
                  ? Icon(Icons.emoji_events, color: Colors.white)
                  : Text(
                    "${index + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
        ),
        title: Text(
          "${user['prenom']} ${user['nom']}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${user['points']} points"),
        trailing:
            isTop3
                ? const Icon(Icons.star, color: Colors.amber)
                : const Icon(Icons.person, color: Colors.grey),
      ),
    );
  }
}
