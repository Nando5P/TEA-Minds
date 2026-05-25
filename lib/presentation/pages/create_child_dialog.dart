import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/child_model.dart';
import '../../core/theme/teaColors.dart';
import '../../core/widgets/tea_snackbars.dart';
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
  final _idController = TextEditingController();
  Color _selectedColor = TEAColors.chickyYellow;

  final List<Color> _palette = [
    const Color(0xFFF8BBD0),
    const Color(0xFFBBDEFB),
    TEAColors.greenPastel,
    const Color(0xFFFFE0B2),
    const Color(0xFFE1BEE7),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  void _onCreate() {
    if (_nameController.text.trim().isEmpty) {
      TEASnackBars.show(context, message: 'Ponle un nombre al pollito', isError: true);
      return;
    }

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      final newChild = ChildModel(
        id: '', 
        nombre: _nameController.text.trim(),
        tutorIds: [authState.user.uid], 
        color: '#${_selectedColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}',
        tieneGafas: false, // Mantenemos el modelo pero forzado a false
      );

      context.read<ChildCubit>().addChild(newChild);
      Navigator.pop(context);
      TEASnackBars.show(context, message: '¡Pollito creado con éxito! 🐣', isError: false);
    }
  }

  Future<void> _onLink() async {
    final childId = _idController.text.trim();
    if (childId.isEmpty) {
      TEASnackBars.show(context, message: 'Introduce un ID válido', isError: true);
      return;
    }

    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      try {
        await context.read<ChildCubit>().linkChild(childId, authState.user.uid);
        if (mounted) {
          Navigator.pop(context);
          TEASnackBars.show(context, message: '¡Pollito vinculado con éxito! 🎉', isError: false);
        }
      } catch (e) {
        if (mounted) {
          TEASnackBars.show(context, message: 'No se encontró ningún pollito con ese ID', isError: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: DefaultTabController(
        length: 2,
        child: Container(
          constraints: const BoxConstraints(maxHeight: 450), // Un poco más pequeño al quitar las gafas
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    const Text('Añadir Pollito', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),
                    TabBar(
                      labelColor: TEAColors.textPrimary,
                      unselectedLabelColor: TEAColors.textSecondary,
                      indicatorColor: TEAColors.bluePastel,
                      indicatorWeight: 3,
                      tabs: const [
                        Tab(text: 'Crear', icon: Icon(Icons.egg_outlined)),
                        Tab(text: 'Vincular', icon: Icon(Icons.link)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildCreateTab(),
                    _buildLinkTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _onCreate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TEAColors.bluePastel,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Crear'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLinkTab() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.diversity_3, size: 60, color: TEAColors.chickyYellow),
          const SizedBox(height: 20),
          const Text(
            'Pega aquí el ID para compartir los datos del perfil.',
            textAlign: TextAlign.center,
            style: TextStyle(color: TEAColors.textSecondary),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _idController,
            decoration: InputDecoration(
              labelText: 'Pega el ID aquí',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.paste),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _onLink,
                style: ElevatedButton.styleFrom(
                  backgroundColor: TEAColors.greenPastel,
                  foregroundColor: TEAColors.textPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Vincular', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}