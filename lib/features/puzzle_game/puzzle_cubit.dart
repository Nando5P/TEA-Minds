import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/entities/puzzle_item.dart';
import '../../domain/repositories/child_repository.dart';

class PuzzleState {
  final bool isWin;
  final bool isError;
  final PuzzleItem? targetItem;
  final List<PuzzleItem> options;
  final int currentScore;
  final int bestScore;

  PuzzleState({
    required this.isWin,
    this.isError = false, // Por defecto no hay error
    this.targetItem,
    required this.options,
    this.currentScore = 0,
    this.bestScore = 0,
  });

  // Método copyWith para actualizar el estado de forma limpia
  PuzzleState copyWith({
    bool? isWin,
    bool? isError,
    PuzzleItem? targetItem,
    List<PuzzleItem>? options,
    int? currentScore,
    int? bestScore,
  }) {
    return PuzzleState(
      isWin: isWin ?? this.isWin,
      isError: isError ?? this.isError,
      targetItem: targetItem ?? this.targetItem,
      options: options ?? this.options,
      currentScore: currentScore ?? this.currentScore,
      bestScore: bestScore ?? this.bestScore,
    );
  }
}

class PuzzleCubit extends Cubit<PuzzleState> {
  final Child child;
  final ChildRepository repository;

  PuzzleCubit({required this.child, required this.repository})
      : super(PuzzleState(
          isWin: false, 
          isError: false,
          options: [], 
          bestScore: child.recordEncaje
        ));

  final List<PuzzleItem> _pool = [
    PuzzleItem(id: '1', emoji: '🍎', nombre: 'Manzana', color: Colors.redAccent),
    PuzzleItem(id: '2', emoji: '🍌', nombre: 'Plátano', color: Colors.yellow),
    PuzzleItem(id: '3', emoji: '🍇', nombre: 'Uva', color: Colors.purple),
    PuzzleItem(id: '4', emoji: '🍉', nombre: 'Sandía', color: Colors.green),
    PuzzleItem(id: '5', emoji: '🍓', nombre: 'Fresa', color: Colors.red),
    PuzzleItem(id: '6', emoji: '🍍', nombre: 'Piña', color: Colors.orange),
  ];

  void initGame() {
    final random = Random();
    final target = _pool[random.nextInt(_pool.length)];
    List<PuzzleItem> options = [target];

    while (options.length < 3) {
      final potential = _pool[random.nextInt(_pool.length)];
      if (!options.contains(potential)) options.add(potential);
    }
    options.shuffle();

    emit(state.copyWith(
      isWin: false,
      isError: false,
      targetItem: target,
      options: options,
    ));
  }

  void checkMatch(String itemId) {
    if (state.isWin) return; // Evitar clics si ya ha ganado

    if (itemId == state.targetItem?.id) {
      // --- CASO DE ÉXITO ---
      final newScore = state.currentScore + 1;
      final newBest = newScore > state.bestScore ? newScore : state.bestScore;

      if (newBest > state.bestScore) {
        repository.updateRecordEncaje(child.id, newBest);
      }

      emit(state.copyWith(
        isWin: true,
        isError: false,
        currentScore: newScore,
        bestScore: newBest,
      ));
    } else {
      // --- CASO DE FALLO ---
      emit(state.copyWith(
        isError: true, 
        isWin: false,
        currentScore: 0, // Reset de racha
      ));

      // Esperamos 2 segundos y quitamos el mensaje de error automáticamente
      Future.delayed(const Duration(seconds: 2), () {
        if (!isClosed) {
          emit(state.copyWith(isError: false));
        }
      });
    }
  }
}