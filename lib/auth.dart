import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get userStream => _firebaseAuth.authStateChanges();
  //Login
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("Aucun utilisateur trouvé pour cet email.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Mot de passe incorrect.");
      } else {
        throw Exception("Erreur lors de la connexion : ${e.message}");
      }
    }
  }

  //LOGOUT
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  //CREER UTILISATEUR EMAIL-PASSWORD
  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Réinitialiser le mot de passe
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Erreur lors de la réinitialisation du mot de passe : $e");
    }
  }
}
