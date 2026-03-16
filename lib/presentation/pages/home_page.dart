import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TEA-Minds 🐥')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.read<AuthCubit>().logout(),
          child: const Text('Cerrar Sesión'),
        ),
      ),
    );
  }
}