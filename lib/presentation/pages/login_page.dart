import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/teaColors.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import 'register_page.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TEAColors.background, 
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- HEADER (Imagen de los pollitos en la biblioteca) ---
                  _buildHeader(),
                  const SizedBox(height: 32),
                  
                  // --- FORMULARIO (Caja Blanca) ---
                  _buildLoginForm(context),
                  
                  const SizedBox(height: 24),
                  
                  // --- BOTÓN PARA IR A REGISTRO ---
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      '¿No tienes cuenta? Regístrate aquí',
                      style: TextStyle(
                        color: TEAColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/images/login_header.png',
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: TEAColors.textPrimary,
            ),
            children: [
              TextSpan(text: 'TEA-'),
              TextSpan(
                text: 'Minds',
                style: TextStyle(color: TEAColors.bluePastel),
              ),
            ],
          ),
        ),
      
      ],
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TEAColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Text(
            'Acceso a tu cuenta',
            style: TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w500, 
              color: TEAColors.textPrimary
            ),
          ),
          const SizedBox(height: 24),
          
          _buildTextField(
            controller: _emailController,
            hint: 'Correo electrónico',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: _passwordController,
            hint: 'Contraseña',
            icon: Icons.lock_outline,
            isPassword: true,
          ),
          const SizedBox(height: 24),
          
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const CircularProgressIndicator();
              }
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<AuthCubit>().login(
                      _emailController.text.trim(),
                      _passwordController.text.trim(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TEAColors.bluePastel,
                    foregroundColor: TEAColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Entrar', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        filled: true,
        fillColor: TEAColors.inputBackground,
        hintText: hint,
        prefixIcon: Icon(icon, color: TEAColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}