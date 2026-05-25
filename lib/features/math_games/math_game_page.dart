import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/repositories/child_repository.dart';
import '../../core/theme/teaColors.dart'; 
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
  
  // Estados para controlar el modo visual
  bool _showRegletas = false;
  bool _showColorHelp = false; 

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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  // Cambiamos spaceEvenly a start para tener control absoluto de los espacios
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    
                    // --- CONTROLES VISUALES ---
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Switch(
                              value: _showColorHelp,
                              activeColor: TEAColors.bluePastel,
                              onChanged: (val) {
                                setState(() {
                                  _showColorHelp = val;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            const Text('Ayuda por colores', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Row(
                          children: [
                            Switch(
                              value: _showRegletas,
                              activeColor: TEAColors.bluePastel,
                              onChanged: (val) {
                                setState(() {
                                  _showRegletas = val;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            const Text('Regletas', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),

                    // --- MENSAJE DE FEEDBACK ---
                    SizedBox(
                      height: 50, // Reducido un poco
                      child: Center(
                        child: AnimatedOpacity(
                          opacity: _isShowingFeedback ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            _feedbackMessage ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: _feedbackMessage?.contains('GENIAL') == true 
                                  ? Colors.orange 
                                  : Colors.blueGrey,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Spacer(flex: 1), // Empuja el bloque central un poco hacia abajo

                    // --- BLOQUE CENTRAL AGRUPADO (Operación + Botones) ---
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // --- ÁREA DE LA OPERACIÓN ---
                        Container(
                          // Aquí estaba el problema: vertical era 40, lo hemos bajado a 20
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                          width: double.infinity,
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
                          child: FittedBox( 
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildNumberDisplay(state.numA.toString()),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: _getOperatorIcon(state.currentOp),
                                ),
                                _buildNumberDisplay(state.numB.toString()),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Text('=', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black)),
                                ),
                                _buildNumberDisplay('?'),
                              ],
                            ),
                          ),
                        ),

                        // ESPACIO MUY REDUCIDO ENTRE OPERACIÓN Y BOTONES
                        const SizedBox(height: 15), 

                        // --- GRILLA DE OPCIONES ---
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 15, // Un poco más juntos horizontalmente
                            mainAxisSpacing: 15,  // Un poco más juntos verticalmente
                            childAspectRatio: 1.6, // Botones un pelín más anchos que altos
                          ),
                          itemCount: state.options.length,
                          itemBuilder: (context, index) {
                            final option = state.options[index];
                            Color btnColor = Colors.white;

                            if (_isShowingFeedback) {
                              if (option == state.correctAnswer) {
                                btnColor = TEAColors.successPastel;
                              } else if (option == _lastSelected) {
                                btnColor = TEAColors.errorPastel;
                              }
                            }

                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: btnColor,
                                disabledBackgroundColor: btnColor,
                                disabledForegroundColor: Colors.black,
                                elevation: _isShowingFeedback ? 0 : 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.all(10),
                              ),
                              onPressed: _isShowingFeedback ? null : () => _handleAnswer(context, option, state.correctAnswer),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: _buildNumberDisplay(option.toString()),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const Spacer(flex: 2), // Asegura que quede un poco de margen inferior
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleAnswer(BuildContext context, int selected, int correct) async {
    setState(() {
      _lastSelected = selected;
      _isShowingFeedback = true;
      _feedbackMessage = (selected == correct) ? '¡GENIAL! 🌟' : '¡OH NO! ☁️';
    });

    context.read<MathCubit>().checkAnswer(selected);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isShowingFeedback = false;
        _lastSelected = null;
        _feedbackMessage = null;
      });
      context.read<MathCubit>().generateQuestion(
        widget.operation, 
        widget.level, 
        selectedTables: widget.selectedTables
      );
    }
  }
  
  Widget _buildNumberDisplay(String text) {
    if (text == '?') {
      return const Text('?', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.black));
    }

    if (_showRegletas) {
      return _buildCuisenaireRods(text);
    } else {
      return _buildColoredText(text);
    }
  }

  Widget _buildColoredText(String text) {
    if (text == '0') return Text('0', style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: _showColorHelp ? Colors.blue : Colors.black));

    final String tens = text.length > 1 ? text.substring(0, text.length - 1) : '';
    final String units = text.isNotEmpty ? text.substring(text.length - 1) : '';

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        children: [
          if (tens.isNotEmpty) TextSpan(text: tens, style: TextStyle(color: _showColorHelp ? Colors.red : Colors.black)),
          TextSpan(text: units, style: TextStyle(color: _showColorHelp ? Colors.blue : Colors.black)),
        ],
      ),
    );
  }

  Widget _buildCuisenaireRods(String text) {
    int? value = int.tryParse(text);
    if (value == null || value == 0) {
      return _buildColoredText(text); 
    }

    List<Widget> rods = [];
    int tens = value ~/ 10;
    int units = value % 10;

    for (int i = 0; i < tens; i++) {
      rods.add(_buildSingleRod(10));
    }
    
    if (units > 0) {
      rods.add(_buildSingleRod(units));
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160), 
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: 4, 
        runSpacing: 6, 
        children: rods,
      ),
    );
  }

  Widget _buildSingleRod(int value) {
    final Map<int, Color> rodColors = {
      1: Colors.white,
      2: Colors.red,
      3: Colors.lightGreen,
      4: Colors.purple[300]!, 
      5: Colors.yellow,
      6: Colors.green[800]!,
      7: Colors.black,
      8: Colors.brown,
      9: Colors.blue,
      10: Colors.orange,
    };

    return Container(
      width: value * 15.0, 
      height: 40, 
      decoration: BoxDecoration(
        color: rodColors[value],
        border: Border.all(color: Colors.black38, width: 2),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(1, 2),
          ),
        ],
      ),
    );
  }

  Widget _getOperatorIcon(MathOperation op) {
    switch (op) {
      case MathOperation.suma: return const Icon(Icons.add, size: 50, color: Colors.black);
      case MathOperation.resta: return const Icon(Icons.remove, size: 50, color: Colors.black);
      case MathOperation.multi: return const Icon(Icons.close, size: 50, color: Colors.black);
      case MathOperation.div: 
        return const Text('÷', style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold, color: Colors.black));
      default: return const Icon(Icons.help_outline, size: 50, color: Colors.black);
    }
  }
}