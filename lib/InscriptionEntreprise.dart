import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app2/connexionEntreprise.dart';

class InscriptionEntreprise extends StatefulWidget {
  const InscriptionEntreprise({super.key});

  @override
  State<InscriptionEntreprise> createState() => _InscriptionEntrepriseState();
}

class _InscriptionEntrepriseState extends State<InscriptionEntreprise> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _isoController = TextEditingController();
  final TextEditingController _localisationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _typeEntreprise;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _registerEntreprise() async {
    final String nom = _nomController.text.trim();
    final String iso = _isoController.text.trim();
    final String localisation = _localisationController.text.trim();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (nom.isEmpty ||
        iso.isEmpty ||
        localisation.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        _typeEntreprise == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Les mots de passe ne correspondent pas."),
        ),
      );
      return;
    }

    try {
      // Création de l'utilisateur avec Firebase Authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Enregistrement des données dans Firestore
      await _firestore
          .collection('entreprises')
          .doc(userCredential.user!.uid)
          .set({
            'nom': nom,
            'iso': iso,
            'localisation': localisation,
            'email': email,
            'typeEntreprise': _typeEntreprise,
            'createdAt': FieldValue.serverTimestamp(),
          });

      // Redirection vers la page de connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Connexionentreprise()),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Inscription réussie !")));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : ${e.message}")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur inattendue : $e")));
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
        decoration: const BoxDecoration(),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Entreprise",
                  style: TextStyle(
                    fontSize: 30,
                    color: Color.fromARGB(255, 66, 218, 27),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                _buildInput("Nom de l'entreprise", _nomController),
                _buildInput(
                  "Identifiant Iso",
                  _isoController,
                  inputType: TextInputType.number,
                ),
                _buildInput("Localisation", _localisationController),
                _buildDropdown(),
                _buildInput(
                  "Email",
                  _emailController,
                  inputType: TextInputType.emailAddress,
                ),
                _buildInput("Mot de passe", _passwordController, obscure: true),
                _buildInput(
                  "Confirmer le mot de passe",
                  _confirmPasswordController,
                  obscure: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerEntreprise,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 66, 218, 27),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 30,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "S'inscrire",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                // Bouton pour aller à la page de connexion
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Connexionentreprise(),
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
    );
  }

  Widget _buildInput(
    String hint,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
    bool obscure = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 20,
          ),
        ),
        hint: const Text("Type d'entreprise"),
        items: const [
          DropdownMenuItem(
            value: "collecte",
            child: Text("Entreprise de collecte"),
          ),
          DropdownMenuItem(
            value: "recyclage",
            child: Text("Entreprise de recyclage"),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _typeEntreprise = value;
          });
        },
      ),
    );
  }
}
