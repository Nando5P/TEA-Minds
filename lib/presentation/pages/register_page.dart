import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/teaColors.dart';
import '../../domain/entities/user_entity.dart'; // Aquí es donde debe estar UserRole
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pinController = TextEditingController();
  
  // CORRECCIÓN: Usamos el Enum directamente
  UserRole _selectedRol = UserRole.tutor;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    final newUser = UserApp(
      uid: '', 
      nombreCompleto: _nameController.text,
      email: _emailController.text,
      rol: _selectedRol, // Ahora sí encaja el tipo
      pinSeguridad: _pinController.text,
      listaNinos: [],
    );
    context.read<AuthCubit>().register(newUser, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TEAColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildRegisterForm(context),
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
      children: const [
        Text('🐣', style: TextStyle(fontSize: 64)),
        SizedBox(height: 16),
        Text(
          'Crear Cuenta',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: TEAColors.textPrimary),
        ),
        Text(
          'Únete a la comunidad TEA-Minds',
          style: TextStyle(fontSize: 16, color: TEAColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: TEAColors.cardWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          _buildTextField(controller: _nameController, hint: 'Nombre Completo', icon: Icons.person_outline),
          const SizedBox(height: 16),
          _buildTextField(controller: _emailController, hint: 'Correo electrónico', icon: Icons.email_outlined),
          const SizedBox(height: 16),
          _buildTextField(controller: _passwordController, hint: 'Contraseña', icon: Icons.lock_outline, isPassword: true),
          const SizedBox(height: 16),
          _buildTextField(controller: _pinController, hint: 'PIN Seguridad (4 dígitos)', icon: Icons.pin_outlined, isNumeric: true),
          const SizedBox(height: 24),
          
          _buildRoleSelector(),
          const SizedBox(height: 32),

          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated) {
                Navigator.pop(context); // Volver al login o wrapper tras registrarse
              }
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              if (state is AuthLoading) return const CircularProgressIndicator();
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onRegisterPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TEAColors.greenPastel,
                    foregroundColor: TEAColors.textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Registrarme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _roleOption('Tutor', UserRole.tutor),
        const SizedBox(width: 16),
        _roleOption('Especialista', UserRole.especialista),
      ],
    );
  }

  Widget _roleOption(String label, UserRole role) {
    bool isSelected = _selectedRol == role;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _selectedRol = role);
      },
      selectedColor: TEAColors.bluePastel,
      backgroundColor: TEAColors.inputBackground,
      labelStyle: TextStyle(color: isSelected ? TEAColors.textPrimary : TEAColors.textSecondary),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isNumeric = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        fillColor: TEAColors.inputBackground,
        hintText: hint,
        prefixIcon: Icon(icon, color: TEAColors.textSecondary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}