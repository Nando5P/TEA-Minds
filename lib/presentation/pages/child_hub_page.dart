import 'package:flutter/material.dart';
import '../../domain/entities/child_entity.dart';
import '../../models/teaColors.dart';
import '../../features/game_1/game_1_page.dart'; 
import 'pin_dialog.dart';

class ChildHubPage extends StatelessWidget {
  final Child child;

  const ChildHubPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final Color chickColor = Color(int.parse(child.color.replaceFirst('#', '0xFF')));

    return Scaffold(
      backgroundColor: TEAColors.background,
      body: Stack(
        children: [
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.lock_outline, size: 30, color: TEAColors.textSecondary),
              onPressed: () async {
                final bool? canExit = await showDialog<bool>(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const PinDialog(),
                );
                if (canExit == true && context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '¡Hola, ${child.nombre}!',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: TEAColors.textPrimary),
                ),
                const SizedBox(height: 40),

                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: chickColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Text('🐤', style: TextStyle(fontSize: 100)),
                      if (child.tieneGafas) const Text('👓', style: TextStyle(fontSize: 90)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 60),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // BOTÓN DE PUZZLES CORREGIDO
                    _buildGameButton(
                      context, 
                      '🧩', 
                      'Puzzles', 
                      TEAColors.bluePastel,
                      () => Navigator.push(
                        context, 
                        MaterialPageRoute(
                          // PASAMOS EL HIJO Y QUITAMOS EL CONST
                          builder: (context) => Game1Page(child: child), 
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    _buildGameButton(
                      context, 
                      '🔢', 
                      'Números', 
                      TEAColors.greenPastel,
                      () => print('Próximamente...'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameButton(BuildContext context, String icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color, width: 4),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4)),
              ],
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 40))),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: TEAColors.textPrimary),
          ),
        ],
      ),
    );
  }
}