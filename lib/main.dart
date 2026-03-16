import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'data/sources/remote/auth_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/pages/auth_wrapper.dart';

void main() async {
  // 1. Aseguramos que Flutter esté listo para plugins nativos
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Inicializamos Firebase con las opciones generadas
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Preparamos las dependencias (Fontanería)
  final authService = AuthService();
  final authRepository = AuthRepositoryImpl(authService);

  runApp(
    // Inyectamos el Repositorio para que esté disponible en toda la app
    RepositoryProvider.value(
      value: authRepository,
      child: BlocProvider(
        // Creamos el Cubit y lanzamos el chequeo de sesión automático
        create: (context) => AuthCubit(authRepository)..appStarted(),
        child: const TeaMindsApp(),
      ),
    ),
  );
}

class TeaMindsApp extends StatelessWidget {
  const TeaMindsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TEA-Minds',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Usamos el verde pastel que definimos en el prompt de diseño
        colorSchemeSeed: const Color(0xFFC8E6C9), 
        brightness: Brightness.light,
      ),
      // El punto de entrada es el Wrapper que acabas de crear
      home: const AuthWrapper(),
    );
  }
}