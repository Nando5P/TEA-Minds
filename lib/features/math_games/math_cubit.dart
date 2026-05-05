import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MathOperation { suma, resta, mixtaSumaResta, multi, div, mixtaMultiDiv, todas }

class MathState {
  final int numA;
  final int numB;
  final MathOperation currentOp;
  final List<int> options;
  final int correctAnswer;
  final int score;
  final bool? lastAnswerCorrect;

  MathState({
    required this.numA,
    required this.numB,
    required this.currentOp,
    required this.options,
    required this.correctAnswer,
    this.score = 0,
    this.lastAnswerCorrect,
  });
}

class MathCubit extends Cubit<MathState?> {
  final Random _random = Random();

  MathCubit() : super(null);

  void generateQuestion(MathOperation op, int level, {List<int>? selectedTables}) {
    int a = 0, b = 0;
    MathOperation activeOp = op;

    // Lógica para elegir operación si es mixta
    if (op == MathOperation.mixtaSumaResta) {
      activeOp = _random.nextBool() ? MathOperation.suma : MathOperation.resta;
    } else if (op == MathOperation.mixtaMultiDiv) {
      activeOp = _random.nextBool() ? MathOperation.multi : MathOperation.div;
    } else if (op == MathOperation.todas) {
      activeOp = MathOperation.values[_random.nextInt(4)]; // Suma, resta, multi o div
    }

    // Configuración de números según nivel y operación
    switch (activeOp) {
      case MathOperation.suma:
        a = _random.nextInt(level * 10) + 1;
        b = _random.nextInt(level * 10) + 1;
        break;
      case MathOperation.resta:
        a = _random.nextInt(level * 10) + 5;
        b = _random.nextInt(a); // No negativos
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
        a = b * multi; // División exacta
        break;
      default: break;
    }

    int result = _calculate(a, b, activeOp);
    
    // Opciones falsas coherentes
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
    ));
  }
}