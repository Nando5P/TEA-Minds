import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'math_cubit.dart';
import '../../models/teaColors.dart';

class MathGamePage extends StatelessWidget {
  final dynamic child;
  final MathOperation operation;
  final int level;
  final List<int>? selectedTables;

  const MathGamePage({super.key, required this.child, required this.operation, required this.level, this.selectedTables});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MathCubit()..generateQuestion(operation, level, selectedTables: selectedTables),
      child: Scaffold(
        backgroundColor: TEAColors.background,
        appBar: AppBar(backgroundColor: Colors.transparent),
        body: BlocBuilder<MathCubit, MathState?>(
          builder: (context, state) {
            if (state == null) return const Center(child: CircularProgressIndicator());

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _box(state.numA.toString()),
                    _symbol(_sym(state.currentOp)),
                    _box(state.numB.toString()),
                    _symbol('='),
                    _box('?', color: Colors.grey[100]),
                  ],
                ),
                const SizedBox(height: 60),
                Wrap(
                  spacing: 20, runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: state.options.map((o) => _optBtn(context, o, state)).toList(),
                ),
                const SizedBox(height: 40),
                if (state.lastAnswerCorrect != null)
                  Text(state.lastAnswerCorrect! ? '¡Genial! 🌟' : '¡Casi! 💪', 
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, 
                    color: state.lastAnswerCorrect! ? Colors.green : Colors.red)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _box(String t, {Color? color}) => Container(
    width: 75, height: 75,
    decoration: BoxDecoration(color: color ?? Colors.white, borderRadius: BorderRadius.circular(15)),
    child: Center(child: Text(t, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
  );

  Widget _symbol(String s) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Text(s, style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
  );

  Widget _optBtn(BuildContext context, int v, MathState s) => GestureDetector(
    onTap: () {
      context.read<MathCubit>().checkAnswer(v);
      if (v == s.correctAnswer) {
        Future.delayed(const Duration(milliseconds: 800), () {
          if (context.mounted) context.read<MathCubit>().generateQuestion(operation, level, selectedTables: selectedTables);
        });
      }
    },
    child: Container(
      width: 110, height: 70,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: TEAColors.bluePastel, width: 3)),
      child: Center(child: Text(v.toString(), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold))),
    ),
  );

  String _sym(MathOperation op) {
    if (op == MathOperation.suma) return '+';
    if (op == MathOperation.resta) return '-';
    if (op == MathOperation.multi) return '×';
    return '÷';
  }
}