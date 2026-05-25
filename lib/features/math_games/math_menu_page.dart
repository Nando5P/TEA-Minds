import 'package:flutter/material.dart';
import '../../core/theme/teaColors.dart';
import 'math_cubit.dart';
import 'math_game_page.dart';

class MathMenuPage extends StatefulWidget {
  final dynamic child;
  const MathMenuPage({super.key, required this.child});

  @override
  State<MathMenuPage> createState() => _MathMenuPageState();
}

class _MathMenuPageState extends State<MathMenuPage> {
  int _selectedLevel = 1;
  final List<int> _tempSelectedTables = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TEAColors.background,
      appBar: AppBar(
        title: const Text('Juegos de Mates'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Elige la dificultad', 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: TEAColors.textPrimary)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLevelBtn(1, 'Fácil', TEAColors.greenPastel),
                const SizedBox(width: 10),
                _buildLevelBtn(2, 'Medio', TEAColors.bluePastel),
                const SizedBox(width: 10),
                _buildLevelBtn(3, 'Difícil', TEAColors.orangeAccent),
              ],
            ),
            const SizedBox(height: 40),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: [
                _buildOpCard('Sumas', '➕', MathOperation.suma),
                _buildOpCard('Restas', '➖', MathOperation.resta),
                _buildOpCard('Multiplicar', '✖️', MathOperation.multi),
                _buildOpCard('Dividir', '➗', MathOperation.div),
                _buildOpCard('Mezcla +/-', '➕➖', MathOperation.mixtaSumaResta),
                _buildOpCard('¡Todo!', '🚀', MathOperation.todas),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelBtn(int level, String text, Color color) {
    bool isSelected = _selectedLevel == level;
    return GestureDetector(
      onTap: () => setState(() => _selectedLevel = level),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color, width: 2),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : color,
          ),
        ),
      ),
    );
  }

  Widget _buildOpCard(String title, String icon, MathOperation op) {
    return GestureDetector(
      onTap: () {
        if ((op == MathOperation.multi || op == MathOperation.div) && _selectedLevel < 3) {
          _showTablePicker(op);
        } else {
          _startGame(op);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 45)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _showTablePicker(MathOperation op) {
    _tempSelectedTables.clear();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => StatefulBuilder(
        builder: (modalContext, setModalState) {
          
          Widget buildTableBtn(int val) {
            bool isSel = _tempSelectedTables.contains(val);
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FilterChip(
                  showCheckmark: false, // Eliminamos el tic que descuadra
                  label: Container(
                    constraints: const BoxConstraints(minHeight: 45),
                    alignment: Alignment.center,
                    child: Text(
                      val.toString(),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isSel ? Colors.white : TEAColors.textPrimary,
                      ),
                    ),
                  ),
                  selected: isSel,
                  selectedColor: TEAColors.greenPastel,
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  side: BorderSide(color: isSel ? TEAColors.greenPastel : Colors.transparent),
                  onSelected: (selected) {
                    setModalState(() {
                      if (_selectedLevel == 1) {
                        // Selección única en nivel Fácil
                        _tempSelectedTables.clear();
                        _tempSelectedTables.add(val);
                      } else {
                        // Selección múltiple en nivel Medio
                        selected 
                          ? _tempSelectedTables.add(val) 
                          : _tempSelectedTables.remove(val);
                      }
                    });
                  },
                ),
              ),
            );
          }

          return Container(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedLevel == 1 ? 'Elige una tabla' : 'Elige las tablas',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                
                // Filas de la cuadrícula
                Row(children: [buildTableBtn(1), buildTableBtn(2), buildTableBtn(3)]),
                Row(children: [buildTableBtn(4), buildTableBtn(5), buildTableBtn(6)]),
                Row(children: [buildTableBtn(7), buildTableBtn(8), buildTableBtn(9)]),
                
                // Fila especial (Atrás, 10, Jugar)
                Row(
                  children: [
                    // Botón Volver (bajo el 7)
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.redAccent, size: 35),
                        onPressed: () => Navigator.pop(modalContext),
                      ),
                    ),
                    // Tabla del 10 (bajo el 8)
                    buildTableBtn(10),
                    // Botón Jugar (bajo el 9)
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          Icons.check_circle_rounded,
                          color: _tempSelectedTables.isEmpty ? Colors.grey[300] : TEAColors.greenPastel,
                          size: 60,
                        ),
                        onPressed: _tempSelectedTables.isEmpty 
                          ? null 
                          : () {
                              Navigator.pop(modalContext);
                              _startGame(op, tables: _tempSelectedTables);
                            },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _startGame(MathOperation op, {List<int>? tables}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MathGamePage(
          child: widget.child,
          operation: op,
          level: _selectedLevel,
          selectedTables: tables,
        ),
      ),
    );
  }
}