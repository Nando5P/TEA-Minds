import '../../../domain/entities/user_entity.dart';

abstract class AuthState {}

// 1. Estado inicial (mientras la app arranca)
class AuthInitial extends AuthState {}

// 2. Cargando (mientras pulsas el botón y esperamos a Firebase)
class AuthLoading extends AuthState {}

// 3. Autenticado (¡Estamos dentro! Tenemos los datos del usuario)
class AuthAuthenticated extends AuthState {
  final UserApp user;
  AuthAuthenticated(this.user);
}

// 4. No autenticado (Hay que mostrar el Login)
class AuthUnauthenticated extends AuthState {}

// 5. Error (Algo ha fallado: contraseña mal, sin internet...)
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}