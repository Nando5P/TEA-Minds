import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Registra un nuevo usuario en el sistema de autenticación 
  /// y guarda sus datos adicionales en la base de datos.
  Future<void> signUp(UserApp user, String password);

  /// Inicia sesión utilizando las credenciales de correo y contraseña.
  Future<void> signIn(String email, String password);

  /// Cierra la sesión activa del usuario.
  Future<void> signOut();

  /// Recupera los datos del usuario que tiene la sesión iniciada.
  Future<UserApp?> getCurrentUser();

  /// Escucha los cambios en el estado de la autenticación.
  Stream<UserApp?> get onAuthStateChanged;
}