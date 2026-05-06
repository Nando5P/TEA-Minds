import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/teaColors.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';

class PinDialog extends StatefulWidget {
  const PinDialog({super.key});

  @override
  State<PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final _pinController = TextEditingController();
  String? _errorMessage;

  void _validatePin() {
    final authState = context.read<AuthCubit>().state;
    
    if (authState is AuthAuthenticated) {
      // El PIN real guardado en el usuario de la DB
      final String correctPin = authState.user.pinSeguridad;

      if (_pinController.text == correctPin) {
        // PIN correcto: Cerramos el diálogo devolviendo 'true'
        Navigator.pop(context, true);
      } else {
        // PIN incorrecto: Mostramos error y limpiamos
        setState(() {
          _errorMessage = "PIN incorrecto. Inténtalo de nuevo.";
          _pinController.clear();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text(
        'Control Parental',
        textAlign: TextAlign.center,
        style: TextStyle(color: TEAColors.textPrimary, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Introduce tu PIN de 4 dígitos para salir.',
            textAlign: TextAlign.center,
            style: TextStyle(color: TEAColors.textSecondary),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, letterSpacing: 16),
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: TEAColors.inputBackground,
              errorText: _errorMessage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              if (value.length == 4) _validatePin();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar', style: TextStyle(color: TEAColors.textSecondary)),
        ),
      ],
    );
  }
}