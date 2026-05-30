import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'memory_cubit.dart';
import '../../domain/entities/child_entity.dart';
import '../../core/theme/teaColors.dart';
import '../../core/widgets/flip_card_widget.dart'; // Import actualizado

class Game2Page extends StatelessWidget {
  final Child child;
  const Game2Page({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MemoryCubit(child: child)..initGame(),
      child: Scaffold(
        backgroundColor: TEAColors.background,
        appBar: AppBar(
          title: Text('Parejas de ${child.nombre}'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<MemoryCubit, MemoryState>(
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: state.cards.length,
                    itemBuilder: (context, index) {
                      final card = state.cards[index];
                      
                      return FlipCardWidget(
                        isFlipped: card.isFlipped || card.isMatched,
                        onTap: () => context.read<MemoryCubit>().flipCard(index),
                        // Cara frontal: Azul con "?" blanco
                        front: _buildCardContainer(
                          color: TEAColors.bluePastel,
                          child: const Text('?', 
                            style: TextStyle(
                              fontSize: 50, 
                              color: Colors.white, 
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none
                            )
                          ),
                        ),
                        // Cara trasera: Blanca con el emoji
                        back: _buildCardContainer(
                          color: Colors.white,
                          child: Text(card.emoji, style: const TextStyle(fontSize: 40)),
                        ),
                      );
                    },
                  ),
                ),
                
                if (state.isWin)
                  _buildWinButton(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Color color, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), 
            blurRadius: 4, 
            offset: const Offset(0, 4)
          ),
        ],
      ),
      child: Center(child: child),
    );
  }

  Widget _buildWinButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: ElevatedButton.icon(
        onPressed: () => context.read<MemoryCubit>().initGame(),
        icon: const Icon(Icons.refresh),
        label: const Text('¡Jugar de nuevo!'),
        style: ElevatedButton.styleFrom(
          backgroundColor: TEAColors.greenPastel,
          foregroundColor: TEAColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }
}