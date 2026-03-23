import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';

// Capa de Datos (Data)
import 'package:tea_minds/data/sources/remote/auth_service.dart';
import 'package:tea_minds/data/repositories/auth_repository_impl.dart';
import 'package:tea_minds/data/repositories/child_repository_impl.dart';

// Capa de Lógica (Presentation/Blocs)
import 'package:tea_minds/presentation/blocs/auth/auth_cubit.dart';
import 'package:tea_minds/presentation/blocs/child/child_cubit.dart';

// UI y Colores
import 'package:tea_minds/presentation/pages/auth_wrapper.dart';
import 'package:tea_minds/models/teaColors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authService = AuthService();
  final authRepository = AuthRepositoryImpl(authService);
  final childRepository = ChildRepositoryImpl();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>.value(value: authRepository),
        RepositoryProvider<ChildRepositoryImpl>.value(value: childRepository),
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
        colorSchemeSeed: const Color(0xFFC8E6C9),
        brightness: Brightness.light,
        scaffoldBackgroundColor: TEAColors.background, // Usando tu clase en lib/models/
      ),
      home: const AuthWrapper(),
    );
  }
}