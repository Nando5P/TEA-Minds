import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';
import '../sources/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepositoryImpl(this._authService);

  @override
  Future<void> signUp(UserApp user, String password) async {
    // 1. Creamos la cuenta en Firebase Auth
    final credential = await _authService.signUpWithEmail(user.email, password);
    
    if (credential?.user != null) {
      // 2. Si la cuenta se crea, guardamos los datos extras en Firestore
      // Usamos el UserModel que creamos antes para el toMap()
      final userModel = UserModel(
        uid: credential!.user!.uid,
        nombreCompleto: user.nombreCompleto,
        email: user.email,
        rol: user.rol,
        pinSeguridad: user.pinSeguridad,
        listaNinos: [],
      );

      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    await _authService.signInWithEmail(email, password);
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future<UserApp?> getCurrentUser() async {
    final firebaseUser = _authService.currentUser;
    if (firebaseUser == null) return null;

    // Buscamos los datos extra en la colección de Firestore
    final doc = await _firestore.collection('users').doc(firebaseUser.uid).get();
    
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, firebaseUser.uid);
    }
    return null;
  }

  @override
  Stream<UserApp?> get onAuthStateChanged {
    // Escuchamos los cambios de Firebase Auth y los convertimos en UserApp
    return FirebaseAuth.instance.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await getCurrentUser();
    });
  }
}