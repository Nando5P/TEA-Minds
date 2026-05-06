import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importante añadir esta línea
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
    } on FirebaseAuthException catch (e) {
      // Enviamos solo el código limpio para que el traductor lo entienda
      emit(AuthError(e.code));
    } catch (e) {
      emit(AuthError("unknown"));
    }
  }

  // Lógica de Registro
  Future<void> register(UserApp newUser, String password) async {
    emit(AuthLoading());
    try {
      await _authRepository.signUp(newUser, password);
      emit(AuthAuthenticated(newUser));
    } on FirebaseAuthException catch (e) {
      // AQUÍ ESTABA EL CAMBIO: Emitimos e.code en lugar del string completo
      emit(AuthError(e.code));
    } catch (e) {
      emit(AuthError("unknown"));
    }
  }

  // Cerrar Sesión
  Future<void> logout() async {
    await _authRepository.signOut();
    emit(AuthUnauthenticated());
  }
}