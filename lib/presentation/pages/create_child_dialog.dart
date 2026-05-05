import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/child_model.dart';
import '../../models/teaColors.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/child/child_cubit.dart';

class CreateChildDialog extends StatefulWidget {
  const CreateChildDialog({super.key});

  @override
  State<CreateChildDialog> createState() => _CreateChildDialogState();
}

class _CreateChildDialogState extends State<CreateChildDialog> {
  final _nameController = TextEditingController();
  bool _tieneGafas = false;
  Color _selectedColor = TEAColors.chickyYellow;

  final List<Color> _palette = [
    TEAColors.chickyYellow,
    const Color(0xFFF8BBD0), // Rosa
    const Color(0xFFBBDEFB), // Azul
    TEAColors.greenPastel,
    const Color(0xFFFFE0B2), // Naranja
    const Color(0xFFE1BEE7), // Lavanda
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_nameController.text.trim().isEmpty) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      // Creamos el modelo ajustado a la nueva estructura
      final newChild = ChildModel(
        id: '', // Firestore generará el ID automáticamente
        nombre: _nameController.text.trim(),
        tutorId: authState.user.uid,
        color: '#${_selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
        tieneGafas: _tieneGafas,
      );

      context.read<ChildCubit>().addChild(newChild);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nuevo Pollito',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del niño',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Elige un color:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: _palette.map((color) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('¿Lleva gafas?'),
              value: _tieneGafas,
              // Usamos thumbColor en lugar de activeColor para evitar deprecaciones si fuera necesario
              onChanged: (val) => setState(() => _tieneGafas = val),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _onSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TEAColors.bluePastel,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}