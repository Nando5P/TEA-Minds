import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/repositories/child_repository.dart';
import '../../models/teaColors.dart'; 
import 'math_cubit.dart';

class MathGamePage extends StatefulWidget {
  final Child child;
  final MathOperation operation;
  final int level;
  final List<int>? selectedTables;

  const MathGamePage({
    super.key,
    required this.child,
    required this.operation,
    required this.level,
    this.selectedTables,
  });

  @override
  State<MathGamePage> createState() => _MathGamePageState();
}

class _MathGamePageState extends State<MathGamePage> {
  int? _lastSelected;
  bool _isShowingFeedback = false;
  String? _feedbackMessage;

  // Colores pastel para el feedback visual de los botones
  static const Color greenPastel = Color(0xFFA5D6A7);
  static const Color redPastel = Color(0xFFEF9A9A);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MathCubit(context.read<ChildRepository>())
        ..generateQuestion(widget.operation, widget.level, selectedTables: widget.selectedTables),
      child: BlocBuilder<MathCubit, MathState?>(
        builder: (context, state) {
          if (state == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) {
                // Al salir, guardamos los datos acumulados de la sesión para el tutor
                await context.read<MathCubit>().finishGame(widget.child.id);
              }
            },
            child: Scaffold(
              backgroundColor: TEAColors.background,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('Jugando con ${widget.child.nombre}', 
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.redAccent),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // --- MENSAJE DE FEEDBACK (ESTILO GENIAL) ---
                    SizedBox(
                      height: 60, // Mantiene la UI estable cuando no hay mensaje
                      child: AnimatedOpacity(
                        opacity: _isShowingFeedback ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Text(
                          _feedbackMessage ?? '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900, // Grosor máximo corregido
                            color: _feedbackMessage?.contains('GENIAL') == true 
                                ? Colors.orange 
                                : Colors.blueGrey,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),

                    // --- ÁREA DE LA OPERACIÓN (NÚMEROS EN NEGRO) ---
                    Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildNumberText(state.numA.toString()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: _getOperatorIcon(state.currentOp),
                          ),
                          _buildNumberText(state.numB.toString()),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text('=', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black)),
                          ),
                          _buildNumberText('?'),
                        ],
                      ),
                    ),

                    // --- GRILLA DE OPCIONES ---
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: state.options.length,
                      itemBuilder: (context, index) {
                        final option = state.options[index];
                        
                        // Lógica de colores de fondo durante el feedback
                        Color btnColor = Colors.white;
                        if (_isShowingFeedback) {
                          if (option == state.correctAnswer) {
                            btnColor = greenPastel;
                          } else if (option == _lastSelected) {
                            btnColor = redPastel;
                          }
                        }

                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: btnColor,
                            disabledBackgroundColor: btnColor, // Mantiene el color al desactivar
                            disabledForegroundColor: Colors.black,
                            elevation: _isShowingFeedback ? 0 : 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: _isShowingFeedback ? null : () => _handleAnswer(context, option, state.correctAnswer),
                          child: Text(
                            option.toString(), 
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Maneja la respuesta del niño y gestiona los 3 segundos de espera
  void _handleAnswer(BuildContext context, int selected, int correct) async {
    setState(() {
      _lastSelected = selected;
      _isShowingFeedback = true;
      _feedbackMessage = (selected == correct) ? '¡GENIAL! 🌟' : '¡OH NO! ☁️';
    });

    // Registra el acierto/fallo en el Cubit
    context.read<MathCubit>().checkAnswer(selected);

    // Espera obligatoria de 3 segundos para que el niño vea el resultado
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isShowingFeedback = false;
        _lastSelected = null;
        _feedbackMessage = null;
      });
      // Genera la siguiente pregunta después del tiempo de espera
      context.read<MathCubit>().generateQuestion(
        widget.operation, 
        widget.level, 
        selectedTables: widget.selectedTables
      );
    }
  }

  Widget _buildNumberText(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
    );
  }

  Widget _getOperatorIcon(MathOperation op) {
    IconData icon;
    switch (op) {
      case MathOperation.suma: icon = Icons.add; break;
      case MathOperation.resta: icon = Icons.remove; break;
      case MathOperation.multi: icon = Icons.close; break;
      case MathOperation.div: icon = Icons.horizontal_rule; break;
      default: icon = Icons.help_outline;
    }
    return Icon(icon, size: 40, color: Colors.black);
  }
}