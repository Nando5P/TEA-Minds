import 'package:flutter/material.dart';

class TEASnackBars {
  /// Muestra un aviso personalizado en la parte inferior de la pantalla
  static void show(
    BuildContext context, {
    required String message,
    bool isError = true,
  }) {
    // Colores basados en tu paleta de los juegos
    final Color backgroundColor = isError 
        ? const Color(0xFFEF9A9A) // Rojo pastel (¡OH NO!)
        : const Color(0xFFA5D6A7); // Verde pastel (¡GENIAL!)

    final IconData icon = isError ? Icons.info_outline : Icons.check_circle_outline;

    // Limpiamos cualquier snackbar anterior para que no se amontonen
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
        duration: const Duration(seconds: 3),
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}