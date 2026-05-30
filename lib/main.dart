import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

// Capa de Dominio (Interfaces)
import 'package:tea_minds/domain/repositories/auth_repository.dart';
import 'package:tea_minds/domain/repositories/child_repository.dart';

// Capa de Datos (Implementaciones)
import 'package:tea_minds/data/sources/auth_service.dart';
import 'package:tea_minds/data/repositories/auth_repository_impl.dart';
import 'package:tea_minds/data/repositories/child_repository_impl.dart';

// Capa de Lógica (Presentation/Blocs)
import 'package:tea_minds/presentation/blocs/auth/auth_cubit.dart';
import 'package:tea_minds/presentation/blocs/child/child_cubit.dart';

// UI y Colores
import 'package:tea_minds/presentation/pages/auth_wrapper.dart';
import 'package:tea_minds/core/theme/teaColors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authService = AuthService();
  // Definimos las variables con el tipo de la INTERFAZ
  final AuthRepository authRepository = AuthRepositoryImpl(authService);
  final ChildRepository childRepository = ChildRepositoryImpl();

  runApp(
    MultiRepositoryProvider(
      providers: [
        // Cambiamos el tipo genérico a la clase abstracta
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<ChildRepository>.value(value: childRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(authRepository)..appStarted(),
          ),
          BlocProvider(
            create: (context) => ChildCubit(childRepository),
          ),
        ],
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
        colorSchemeSeed: TEAColors.seedGreen,
        brightness: Brightness.light,
        scaffoldBackgroundColor: TEAColors.background,
      ),
      home: const AuthWrapper(),
    );
  }
}