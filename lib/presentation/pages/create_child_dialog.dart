import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/teaColors.dart';
import '../../data/models/child_model.dart';
import '../blocs/child/child_cubit.dart';
import '../blocs/auth/auth_cubit.dart';
import '../blocs/auth/auth_state.dart';

class CreateChildDialog extends StatefulWidget {
  const CreateChildDialog({super.key});

  @override
  State<CreateChildDialog> createState() => _CreateChildDialogState();
}

class _CreateChildDialogState extends State<CreateChildDialog> {
  final _nameController = TextEditingController();
  Color _selectedColor = TEAColors.chickyYellow;
  bool _tieneGafas = false;

  // Lista de colores pastel para elegir
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

    // Obtenemos el ID del tutor desde el AuthCubit
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final newChild = ChildModel(
        id: '', // Firestore generará el ID
        nombre: _nameController.text.trim(),
        tutorId: authState.user.uid,
        especialistas: [],
        color: '#${_selectedColor.value.toRadixString(16).padLeft(8, '0').substring(2)}',
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
            const Text('Crear Nuevo Pollito', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: TEAColors.textPrimary)),
            const SizedBox(height: 24),
            
            // --- PREVIEW DEL POLLITO ---
            _buildPreview(),
            const SizedBox(height: 24),
            
            // --- CAMPO NOMBRE ---
            _buildNameField(),
            const SizedBox(height: 24),
            
            // --- SELECTOR COLOR ---
            _buildColorSelector(),
            const SizedBox(height: 24),
            
            // --- SWITCH GAFAS ---
            _buildGafasToggle(),
            const SizedBox(height: 32),
            
            // --- BOTONES ---
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(color: _selectedColor, shape: BoxShape.circle),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text('🐤', style: TextStyle(fontSize: 60)),
          if (_tieneGafas) 
            const Text('👓', style: TextStyle(fontSize: 50)),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        filled: true,
        fillColor: TEAColors.inputBackground,
        hintText: 'Nombre del niño/a',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildColorSelector() {
    return Wrap(
      spacing: 12,
      children: _palette.map((color) {
        bool isSelected = _selectedColor == color;
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = color),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: TEAColors.textPrimary, width: 2) : null,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGafasToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('¿Lleva gafas?', style: TextStyle(color: TEAColors.textSecondary)),
        Switch(
          value: _tieneGafas,
          activeColor: TEAColors.bluePastel,
          onChanged: (val) => setState(() => _tieneGafas = val),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: TEAColors.textSecondary)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: TEAColors.greenPastel,
              foregroundColor: TEAColors.textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Crear'),
          ),
        ),
      ],
    );
  }
}