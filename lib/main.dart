import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Este archivo lo genera FlutterFire CLI

void main() async {
  // 1. Aseguramos que los bindings de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializamos Firebase con las opciones de tu proyecto
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const TeaMindsApp());
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
        colorSchemeSeed: Colors.green, // Color base de nuestros pollitos
      ),
      home: const Scaffold(
        body: Center(child: Text('Conexión establecida 🐥')),
      ),
    );
  }
}