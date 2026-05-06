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
      // Aquí capturamos el código técnico (ej: 'email-already-in-use')
      print("Error en registro: ${e.code}");
      rethrow; // Lo relanzamos para que el Cubit/UI lo capture
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

  // --- EL TRADUCTOR MÁGICO ---
  // Este método estático te servirá en cualquier parte de la app
  static String getFriendlyErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Este correo ya está registrado. ¡Prueba a iniciar sesión!';
      case 'invalid-email':
        return 'El formato del correo no es correcto.';
      case 'weak-password':
        return 'La contraseña es muy corta. Usa al menos 6 caracteres.';
      case 'user-not-found':
        return 'No existe ninguna cuenta con este correo.';
      case 'wrong-password':
        return 'La contraseña no es correcta.';
      case 'network-request-failed':
        return 'Parece que no tienes conexión a internet.';
      default:
        return 'Ups, algo ha fallado. Inténtalo de nuevo.';
    }
  }
}