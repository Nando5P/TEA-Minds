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
  
  // Seguimiento detallado para el informe del tutor
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
}

class MathCubit extends Cubit<MathState?> {
  final Random _random = Random();
  final ChildRepository _repository;

  MathCubit(this._repository) : super(null);

  void generateQuestion(MathOperation op, int level, {List<int>? selectedTables}) {
    int a = 0, b = 0;
    MathOperation activeOp = op;

    // Recuperamos o inicializamos los contadores de la sesión actual
    final int currentSuccesses = state?.successes ?? 0;
    final int currentFailures = state?.failures ?? 0;
    final DateTime currentStartTime = state?.startTime ?? DateTime.now();

    // Lógica para elegir operación en modos mixtos
    if (op == MathOperation.mixtaSumaResta) {
      activeOp = _random.nextBool() ? MathOperation.suma : MathOperation.resta;
    } else if (op == MathOperation.mixtaMultiDiv) {
      activeOp = _random.nextBool() ? MathOperation.multi : MathOperation.div;
    } else if (op == MathOperation.todas) {
      activeOp = MathOperation.values[_random.nextInt(4)];
    }

    // Configuración de números según nivel y operación activa
    switch (activeOp) {
      case MathOperation.suma:
        a = _random.nextInt(level * 10) + 1;
        b = _random.nextInt(level * 10) + 1;
        break;
      case MathOperation.resta:
        a = _random.nextInt(level * 10) + 5;
        b = _random.nextInt(a);
        break;
      case MathOperation.multi:
        a = (selectedTables != null && selectedTables.isNotEmpty)
            ? selectedTables[_random.nextInt(selectedTables.length)]
            : (_random.nextInt(10) + 1);
        b = _random.nextInt(10) + 1;
        break;
      case MathOperation.div:
        b = (selectedTables != null && selectedTables.isNotEmpty)
            ? selectedTables[_random.nextInt(selectedTables.length)]
            : (_random.nextInt(9) + 2);
        int multi = _random.nextInt(10) + 1;
        a = b * multi;
        break;
      default: break;
    }

    int result = _calculate(a, b, activeOp);
    
    // Generar opciones falsas coherentes
    Set<int> opts = {result};
    while (opts.length < 4) {
      int fake = result + (_random.nextInt(7) - 3);
      if (fake >= 0 && fake != result) opts.add(fake);
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

  int _calculate(int a, int b, MathOperation op) {
    if (op == MathOperation.suma) return a + b;
    if (op == MathOperation.resta) return a - b;
    if (op == MathOperation.multi) return a * b;
    if (op == MathOperation.div) return a ~/ b;
    return 0;
  }

  void checkAnswer(int selected) {
    if (state == null) return;
    bool correct = selected == state!.correctAnswer;
    
    emit(MathState(
      numA: state!.numA,
      numB: state!.numB,
      currentOp: state!.currentOp,
      options: state!.options,
      correctAnswer: state!.correctAnswer,
      score: correct ? state!.score + 1 : state!.score,
      lastAnswerCorrect: correct,
      // Actualizamos contadores para la estadística final
      successes: correct ? state!.successes + 1 : state!.successes,
      failures: correct ? state!.failures : state!.failures + 1,
      startTime: state!.startTime,
    ));
  }

  /// Guarda los resultados de la sesión en Firebase diferenciando por operación
  Future<void> finishGame(String childId) async {
    if (state == null) return;

    final duration = DateTime.now().difference(state!.startTime);
    
    // Creamos un ID de juego específico (ej. mates_suma, mates_multi)
    // Esto permite al tutor ver en qué operación falla más el niño.
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