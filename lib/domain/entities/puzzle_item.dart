import 'package:flutter/material.dart';

class PuzzleItem {
  final String id;
  final String emoji;      // En el futuro cambiar a array de emojis para más variedad
  final String nombre;
  final Color color;

  PuzzleItem({
    required this.id, 
    required this.emoji, 
    required this.nombre, 
    required this.color
  });
}