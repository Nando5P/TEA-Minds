import 'package:flutter/material.dart';
import 'dart:math';

class FlipCardWidget extends StatelessWidget {
  final bool isFlipped;
  final Widget front;
  final Widget back;
  final VoidCallback onTap;
  final Duration duration;

  const FlipCardWidget({
    super.key,
    required this.isFlipped,
    required this.front,
    required this.back,
    required this.onTap,
    this.duration = const Duration(milliseconds: 400),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: isFlipped ? pi : 0),
        duration: duration,
        builder: (context, val, __) {
          final isBack = val > (pi / 2);
          
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspectiva 3D
              ..rotateY(val),
            child: isBack 
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi), // Evita el efecto espejo
                  child: back,
                )
              : front,
          );
        },
      ),
    );
  }
}