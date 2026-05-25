import 'package:flutter/material.dart';
import '../../domain/entities/child_entity.dart';
import '../../core/theme/teaColors.dart';
import '../../features/puzzle_game/puzzle_page.dart'; 
import '../../features/memory_game/memory_game_page.dart';
import '../../features/math_games/math_menu_page.dart';
import 'pin_dialog.dart';

class ChildHubPage extends StatelessWidget {
  final Child child;

  const ChildHubPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // 1. Extraemos el color para el fondo del círculo
    final Color chickColor = Color(int.parse(child.color.replaceFirst('#', '0xFF')));

    // 2. Mapeo del color para encontrar la imagen correcta
    final colorHex = child.color.toUpperCase();
    String colorName = 'orange'; 

    if (colorHex.contains('BBDEFB')) {
      colorName = 'blue';
    } else if (colorHex.contains('E1BEE7')) {
      colorName = 'purple';
    } else if (colorHex.contains('F8BBD0')) {
      colorName = 'red'; 
    } else if (colorHex.contains('C8E6C9') || colorHex.contains('A5D6A7')) {
      colorName = 'green';
    }

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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¡Hola, ${child.nombre}!',
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: TEAColors.textPrimary),
                  ),
                  const SizedBox(height: 40),

                  // --- AVATAR CON FONDO TRANSLÚCIDO Y HALO SUAVE ---
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: chickColor.withValues(alpha: 0.2), // Fondo translúcido al 20%
                      shape: BoxShape.circle,
                      boxShadow: [
                        // Sombra tintada del mismo color para dar efecto de brillo suave
                        BoxShadow(
                          color: chickColor.withValues(alpha: 0.15), 
                          blurRadius: 30, 
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/images/pollitos/$colorName.png',
                        width: 140, 
                        height: 140,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.egg, size: 100, color: Colors.amber),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 50),

                  // MENÚ DE JUEGOS EN FORMATO TRIÁNGULO
                  SizedBox(
                    width: 260, 
                    child: Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center, 
                      children: [
                        _buildGameButton(
                          context, 
                          '🧩', 
                          'Puzzles', 
                          TEAColors.bluePastel,
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => Game1Page(child: child))),
                        ),
                        
                        _buildGameButton(
                          context, 
                          '🧠', 
                          'Memoria', 
                          Colors.orangeAccent,
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => Game2Page(child: child))),
                        ),

                        _buildGameButton(
                          context, 
                          '🔢', 
                          'Mates', 
                          TEAColors.greenPastel,
                          () => Navigator.push(context, MaterialPageRoute(builder: (context) => MathMenuPage(child: child))),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
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