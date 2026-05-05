import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/repositories/child_repository.dart';
import '../../models/teaColors.dart';
import 'puzzle_cubit.dart';

class Game1Page extends StatelessWidget {
  final Child child;

  const Game1Page({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PuzzleCubit(
        child: child,
        repository: context.read<ChildRepository>(), // Asegúrate de que el repo esté en el Provider
      )..initGame(),
      child: Scaffold(
        backgroundColor: TEAColors.background,
        appBar: AppBar(
          title: Text('¡Vamos, ${child.nombre}!'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<PuzzleCubit, PuzzleState>(
          builder: (context, state) {
            if (state.targetItem == null) return const SizedBox();

            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // MARCADOR DE PUNTOS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildScoreBox("Puntos", state.currentScore, TEAColors.bluePastel),
                    _buildScoreBox("Récord", state.bestScore, TEAColors.greenPastel),
                  ],
                ),

                // ZONA DE DESTINO
                DragTarget<String>(
                  onAcceptWithDetails: (details) => context.read<PuzzleCubit>().checkMatch(details.data),
                  builder: (context, candidate, rejected) {
                    return Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        color: state.isWin ? state.targetItem!.color.withOpacity(0.2) : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: state.isWin ? Colors.transparent : Colors.grey.withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: ColorFiltered(
                          colorFilter: state.isWin 
                            ? const ColorFilter.mode(Colors.transparent, BlendMode.dst)
                            : ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.srcIn),
                          child: Text(state.targetItem!.emoji, style: const TextStyle(fontSize: 100)),
                        ),
                      ),
                    );
                  },
                ),

                // FEEDBACK Y BOTÓN SIGUIENTE
                if (state.isWin)
                  Column(
                    children: [
                      const Text('¡GENIAL! 🌟', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange)),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => context.read<PuzzleCubit>().initGame(),
                        style: ElevatedButton.styleFrom(backgroundColor: TEAColors.greenPastel, shape: StadiumBorder()),
                        child: const Text('¡A por otro!', style: TextStyle(color: TEAColors.textPrimary)),
                      ),
                    ],
                  )
                else
                  // PIEZAS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: state.options.map((item) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Draggable<String>(
                        data: item.id,
                        feedback: _buildPiece(item, true),
                        childWhenDragging: Opacity(opacity: 0.3, child: _buildPiece(item, false)),
                        child: _buildPiece(item, false),
                      ),
                    )).toList(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildScoreBox(String label, int value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: TEAColors.textSecondary)),
        Text('$value', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }

  Widget _buildPiece(dynamic item, bool isDragging) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 50, decoration: TextDecoration.none))),
    );
  }
}