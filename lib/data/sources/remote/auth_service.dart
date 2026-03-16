import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Obtener el usuario actual
  User? get currentUser => _auth.currentUser;

  // 2. Registro con Email y Contraseña
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      // Aquí gestionaremos los errores (email ya usado, password débil, etc.)
      print("Error en registro: ${e.code}");
      rethrow;
    }
  }

  // 3. Inicio de Sesión
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print("Error en login: ${e.code}");
      rethrow;
    }
  }

  // 4. Cerrar Sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}