import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/entities/puzzle_item.dart';
import '../../domain/repositories/child_repository.dart';

class PuzzleState {
  final bool isWin;
  final PuzzleItem? targetItem;
  final List<PuzzleItem> options;
  final int currentScore;
  final int bestScore;

  PuzzleState({
    required this.isWin, 
    this.targetItem, 
    required this.options, 
    this.currentScore = 0, 
    this.bestScore = 0
  });
}

class PuzzleCubit extends Cubit<PuzzleState> {
  final Child child;
  final ChildRepository repository;

  PuzzleCubit({required this.child, required this.repository}) 
    : super(PuzzleState(isWin: false, options: [], bestScore: child.recordEncaje));

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

    emit(PuzzleState(
      isWin: false, 
      targetItem: target, 
      options: options, 
      currentScore: state.currentScore, 
      bestScore: state.bestScore
    ));
  }

  void checkMatch(String itemId) {
    if (itemId == state.targetItem?.id) {
      final newScore = state.currentScore + 1;
      final newBest = newScore > state.bestScore ? newScore : state.bestScore;

      if (newBest > state.bestScore) {
        repository.updateRecordEncaje(child.id, newBest);
      }

      emit(PuzzleState(
        isWin: true, 
        targetItem: state.targetItem, 
        options: state.options, 
        currentScore: newScore, 
        bestScore: newBest
      ));
    } else {
      emit(PuzzleState(
        isWin: false, 
        targetItem: state.targetItem, 
        options: state.options, 
        currentScore: 0, // Reset de racha al fallar
        bestScore: state.bestScore
      ));
    }
  }
}