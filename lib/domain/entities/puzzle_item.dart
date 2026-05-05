import 'package:flutter/material.dart';

class PuzzleItem {
  final String id;
  final String emoji;      // Usaremos emojis para que sea funcional ya
  final String nombre;
  final Color color;

  PuzzleItem({
    required this.id, 
    required this.emoji, 
    required this.nombre, 
    required this.color
  });
}