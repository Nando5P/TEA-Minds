import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart'; // Librería de gráficos
import '../../domain/entities/child_entity.dart';
import '../../domain/repositories/child_repository.dart';
import '../../core/theme/teaColors.dart';
import '../blocs/stats/stats_cubit.dart';

class TutorStatsPage extends StatelessWidget {
  final Child child;

  const TutorStatsPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsCubit(context.read<ChildRepository>())..loadChildStats(child.id),
      child: Scaffold(
        backgroundColor: TEAColors.background,
        appBar: AppBar(
          title: Text('Progreso de ${child.nombre}', 
            style: const TextStyle(color: TEAColors.textPrimary, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<StatsCubit, StatsState>(
          builder: (context, state) {
            if (state.isLoading) return const Center(child: CircularProgressIndicator());
            if (state.sessions.isEmpty) return const Center(child: Text('Aún no hay partidas registradas.'));

            // Calculamos totales globales para el gráfico
            int totalSuccesses = 0;
            int totalFailures = 0;
            for (var s in state.sessions) {
              totalSuccesses += s.successes;
              totalFailures += s.failures;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- TARJETAS DE RESUMEN ---
                  Row(
                    children: [
                      _buildSummaryCard('Punto Fuerte', state.strength, Icons.trending_up, Colors.green),
                      const SizedBox(width: 15),
                      _buildSummaryCard('A mejorar', state.weakness, Icons.trending_down, Colors.orange),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // --- GRÁFICO CIRCULAR GLOBAL ---
                  const Text('Rendimiento Global', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildPieChart(totalSuccesses, totalFailures),
                  const SizedBox(height: 40),
                  
                  const Text('Historial de Actividad', 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),

                  // --- LISTA DE SESIONES ---
                  _buildSessionList(state.sessions),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Widget del Gráfico Circular
  Widget _buildPieChart(int successes, int failures) {
    final double total = (successes + failures).toDouble();
    if (total == 0) return const SizedBox();

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 5,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: successes.toDouble(),
                    title: '${((successes / total) * 100).toInt()}%',
                    color: TEAColors.successPastel, // Verde pastel
                    radius: 50,
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    value: failures.toDouble(),
                    title: '${((failures / total) * 100).toInt()}%',
                    color: TEAColors.errorPastel, // Rojo pastel
                    radius: 50,
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          // Leyenda del gráfico
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendItem(color: TEAColors.successPastel, text: 'Aciertos'),
              SizedBox(height: 10),
              _LegendItem(color: TEAColors.errorPastel, text: 'Fallos'),
            ],
          )
        ],
      ),
    );
  }

  // Resto de componentes (SummaryCard y Lista)
  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionList(List sessions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        final double acc = session.totalAttempts == 0 ? 0 : (session.successes / session.totalAttempts) * 100;
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: acc > 70 ? TEAColors.successPastel.withValues(alpha: 0.3) : TEAColors.errorPastel.withValues(alpha: 0.3),
              child: Icon(Icons.history, color: acc > 70 ? Colors.green : Colors.red),
            ),
            title: Text(session.gameId.replaceAll('_', ' ').toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${session.date.day}/${session.date.month} - ${session.duration.inMinutes}m'),
            trailing: Text('${acc.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        );
      },
    );
  }
}

// Widget auxiliar para la leyenda
class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  const _LegendItem({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}