import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/tea_snackbars.dart';
import '../../data/sources/auth_service.dart';
import '../../core/theme/teaColors.dart';
import '../../domain/entities/user_entity.dart';
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
    // Validación de seguridad local
    if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
      TEASnackBars.show(context, message: 'Por favor, completa los campos obligatorios', isError: true);
      return;
    }

    final newUser = UserApp(
      uid: '', 
      nombreCompleto: _nameController.text,
      email: _emailController.text,
      rol: _selectedRol,
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
      children: [
        // --- CAMBIO AQUÍ: EMOJI POR IMAGEN ---
        Image.asset(
          'assets/images/pollitos/orange.png', // He puesto el naranja, cámbialo si quieres otro
          height: 100, // Tamaño similar al tamaño del texto original
          width: 100,
          // Fallback por seguridad si no carga la imagen
          errorBuilder: (context, error, stackTrace) => const Text('🐣', style: TextStyle(fontSize: 64)),
        ),
        const SizedBox(height: 16),
        const Text(
          'Crear Cuenta',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: TEAColors.textPrimary),
        ),
        const Text(
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
                // Éxito con SnackBar verde pastel
                TEASnackBars.show(context, message: '¡Cuenta creada! Bienvenido 🐣', isError: false);
                Navigator.pop(context); 
              }
              
              if (state is AuthError) {
                // 1. Aplicamos la traducción (state.message ahora es el código "email-already-in-use")
                final String mensajeTraducido = AuthService.getFriendlyErrorMessage(state.message);
                
                // 2. Llamamos a TU WIDGET (el que tiene el diseño rojo pastel)
                TEASnackBars.show(context, message: mensajeTraducido, isError: true);
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
                  child: const Text('Registrarme', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Los métodos auxiliares se mantienen igual pero con retoques de diseño
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
      labelStyle: TextStyle(
        color: isSelected ? TEAColors.textPrimary : TEAColors.textSecondary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
      ),
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