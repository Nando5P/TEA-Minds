import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/entities/user_entity.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  // Verificar si ya hay una sesión activa al abrir la app
  Future<void> appStarted() async {
    try {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (_) {
      emit(AuthUnauthenticated());
    }
  }

  // Lógica de Inicio de Sesión
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _authRepository.signIn(email, password);
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError("Fallo al iniciar sesión: $e"));
    }
  }

  // Lógica de Registro
  Future<void> register(UserApp newUser, String password) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(newUser, password);
      emit(AuthAuthenticated(newUser));
    } catch (e) {
      emit(AuthError("Fallo en el registro: $e"));
    }
  }

  // Cerrar Sesión
  Future<void> logout() async {
    await _authRepository.signOut();
    emit(AuthUnauthenticated());
  }
}