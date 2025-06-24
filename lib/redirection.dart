import 'package:flutter/material.dart';
import 'package:app2/begin_page.dart';
import 'package:app2/connexion_page.dart';
import 'package:app2/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get userStream => _firebaseAuth.authStateChanges();
}

class RedirectionPage extends StatefulWidget {
  const RedirectionPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RedirectionPageState();
  }
}

class _RedirectionPageState extends State<RedirectionPage> {
  Stream<User?> get userStream => FirebaseAuth.instance.authStateChanges();

  @override
  Widget build(BuildContext context) {
    // Correction du type de retour
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          return BeginPage(); // Correction du nom de la classe
        } else {
          return const ConnexionPage();
        }
      },
    );
  }
}
