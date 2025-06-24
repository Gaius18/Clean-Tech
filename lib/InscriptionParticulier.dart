import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app2/connexionParticulier.dart';

class InscriptionParticulier extends StatefulWidget {
  const InscriptionParticulier({Key? key}) : super(key: key);

  @override
  State<InscriptionParticulier> createState() => _InscriptionParticulierState();
}

class _InscriptionParticulierState extends State<InscriptionParticulier> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;

  // Validation des champs
  String? _validateFields() {
    if (_nomController.text.trim().isEmpty ||
        _prenomController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _confirmPasswordController.text.trim().isEmpty) {
      return "Tous les champs doivent être remplis.";
    }
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      return "Les mots de passe ne correspondent pas.";
    }
    return null; // Pas d'erreur
  }

  Future<void> _register() async {
    // Validation avant de lancer l'inscription
    final validationMessage = _validateFields();
    if (validationMessage != null) {
      setState(() {
        _errorMessage = validationMessage;
      });
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final nom = _nomController.text.trim();
    final prenom = _prenomController.text.trim();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Inscription avec Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Enregistrer les informations supplémentaires dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'nom': nom,
            'prenom': prenom,
            'email': email,
            'points': 0, // Initialisation des points à 0
            'createdAt': FieldValue.serverTimestamp(), // Ajout d'un timestamp
          });

      debugPrint("Utilisateur enregistré avec succès dans Firestore.");

      // Rediriger vers la page de connexion après une inscription réussie
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Connexionparticulier()),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Gestion des erreurs Firebase
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      // Gestion des erreurs générales
      setState(() {
        _errorMessage = "Une erreur inattendue est survenue.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 66, 218, 27),
        elevation: 0,
        title: const Text(
          "Inscription ",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Retour à la page précédente
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          children: [
            const SizedBox(height: 100), // Espace sous l'AppBar
            const Text(
              "Particulier",
              style: TextStyle(
                color: Color.fromARGB(255, 66, 218, 27),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: Column(
                    children: [
                      _buildInput(controller: _nomController, hint: "Nom"),
                      _buildInput(
                        controller: _prenomController,
                        hint: "Prénom",
                      ),
                      _buildInput(
                        controller: _emailController,
                        hint: "Adresse email",
                      ),
                      _buildInput(
                        controller: _passwordController,
                        hint: "Mot de passe",
                        obscure: true,
                      ),
                      _buildInput(
                        controller: _confirmPasswordController,
                        hint: "Confirmer mot de passe",
                        obscure: true,
                      ),
                      const SizedBox(height: 20),
                      if (_errorMessage != null)
                        Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(height: 10),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                66,
                                218,
                                27,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30,
                              ),
                            ),
                            child: const Text(
                              "Inscription",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const Connexionparticulier(),
                            ),
                          );
                        },
                        child: const Text(
                          "Déjà un compte ? Connectez-vous",
                          style: TextStyle(
                            color: Color.fromARGB(255, 66, 218, 27),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Colors.grey, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: Color(0xFF4CD964), width: 2.5),
          ),
        ),
      ),
    );
  }
}
