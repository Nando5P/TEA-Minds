import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/child_repository.dart';

enum MathOperation { suma, resta, mixtaSumaResta, multi, div, mixtaMultiDiv, todas }

class MathState {
  final int numA;
  final int numB;
  final MathOperation currentOp;
  final List<int> options;
  final int correctAnswer;
  final int score;
  final bool? lastAnswerCorrect;
  
  final int successes;
  final int failures;
  final DateTime startTime;

  MathState({
    required this.numA,
    required this.numB,
    required this.currentOp,
    required this.options,
    required this.correctAnswer,
    this.score = 0,
    this.lastAnswerCorrect,
    required this.successes,
    required this.failures,
    required this.startTime,
  });

  MathState copyWith({
    int? numA,
    int? numB,
    MathOperation? currentOp,
    List<int>? options,
    int? correctAnswer,
    int? score,
    bool? lastAnswerCorrect,
    int? successes,
    int? failures,
    DateTime? startTime,
  }) {
    return MathState(
      numA: numA ?? this.numA,
      numB: numB ?? this.numB,
      currentOp: currentOp ?? this.currentOp,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      score: score ?? this.score,
      lastAnswerCorrect: lastAnswerCorrect ?? this.lastAnswerCorrect,
      successes: successes ?? this.successes,
      failures: failures ?? this.failures,
      startTime: startTime ?? this.startTime,
    );
  }
}

class MathCubit extends Cubit<MathState?> {
  final Random _random = Random();
  final ChildRepository _repository;

  MathCubit(this._repository) : super(null);

  void generateQuestion(MathOperation op, int level, {List<int>? selectedTables}) {
    int a = 0, b = 0, result = 0;
    MathOperation activeOp = op;

    final int currentSuccesses = state?.successes ?? 0;
    final int currentFailures = state?.failures ?? 0;
    final DateTime currentStartTime = state?.startTime ?? DateTime.now();

    // 1. Elección de operación (Evitamos el interrogante en modos mixtos)
    if (op == MathOperation.mixtaSumaResta) {
      activeOp = _random.nextBool() ? MathOperation.suma : MathOperation.resta;
    } else if (op == MathOperation.mixtaMultiDiv) {
      activeOp = _random.nextBool() ? MathOperation.multi : MathOperation.div;
    } else if (op == MathOperation.todas) {
      final possible = [MathOperation.suma, MathOperation.resta, MathOperation.multi, MathOperation.div];
      activeOp = possible[_random.nextInt(possible.length)];
    }

    // 2. Generación de números (Evitando ceros)
    int range = (level + 1) * 10;

    switch (activeOp) {
      case MathOperation.suma:
        a = _random.nextInt(range) + 1;
        b = _random.nextInt(range) + 1;
        result = a + b;
        break;
      case MathOperation.resta:
        a = _random.nextInt(range) + 5;
        b = _random.nextInt(a - 1) + 1; // b siempre menor que a y no cero
        result = a - b;
        break;
      case MathOperation.multi:
        a = (selectedTables != null && selectedTables.isNotEmpty)
            ? selectedTables[_random.nextInt(selectedTables.length)]
            : (_random.nextInt(9) + 1);
        b = _random.nextInt(9) + 1;
        result = a * b;
        break;
      case MathOperation.div:
        // Generamos b y result primero para asegurar división exacta y no cero
        b = (selectedTables != null && selectedTables.isNotEmpty)
            ? selectedTables[_random.nextInt(selectedTables.length)]
            : (_random.nextInt(8) + 2);
        result = _random.nextInt(9) + 1;
        a = b * result;
        break;
      default:
        activeOp = MathOperation.suma;
        a = 1; b = 1; result = 2;
    }

    // 3. Generar opciones falsas
    Set<int> opts = {result};
    while (opts.length < 4) {
      int fake = result + (_random.nextInt(7) - 3);
      if (fake >= 1 && fake != result) opts.add(fake);
    }

    emit(MathState(
      numA: a,
      numB: b,
      currentOp: activeOp,
      options: opts.toList()..shuffle(),
      correctAnswer: result,
      score: state?.score ?? 0,
      successes: currentSuccesses,
      failures: currentFailures,
      startTime: currentStartTime,
    ));
  }

  void checkAnswer(int selected) {
    if (state == null) return;
    bool correct = selected == state!.correctAnswer;
    
    emit(state!.copyWith(
      score: correct ? state!.score + 1 : state!.score,
      lastAnswerCorrect: correct,
      successes: correct ? state!.successes + 1 : state!.successes,
      failures: correct ? state!.failures : state!.failures + 1,
    ));
  }

  Future<void> finishGame(String childId) async {
    if (state == null) return;
    final duration = DateTime.now().difference(state!.startTime);
    final String specificGameId = 'mates_${state!.currentOp.name}';

    final session = GameSession(
      id: '', 
      childId: childId,
      gameId: specificGameId, 
      date: DateTime.now(),
      totalAttempts: state!.successes + state!.failures,
      successes: state!.successes,
      failures: state!.failures,
      duration: duration,
    );

    await _repository.saveGameSession(session);
  }
}