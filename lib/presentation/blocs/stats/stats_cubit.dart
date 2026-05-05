import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/session_entity.dart';
import '../../../domain/repositories/child_repository.dart';

class StatsState {
  final List<GameSession> sessions;
  final bool isLoading;
  final Map<String, double> accuracyByGame;
  final String strength;
  final String weakness;

  StatsState({
    required this.sessions, 
    this.isLoading = false, 
    this.accuracyByGame = const {},
    this.strength = 'Calculando...',
    this.weakness = 'Calculando...',
  });
}

class StatsCubit extends Cubit<StatsState> {
  final ChildRepository _repository;

  StatsCubit(this._repository) : super(StatsState(sessions: [], isLoading: true));

  void loadChildStats(String childId) {
    _repository.getSessionsByChild(childId).listen((sessions) {
      if (sessions.isEmpty) {
        emit(StatsState(sessions: [], isLoading: false, strength: 'Sin datos', weakness: 'Sin datos'));
        return;
      }

      final accuracyMap = _calculateAccuracy(sessions);
      
      // Encontrar el mejor y peor juego
      String best = 'Ninguno';
      String worst = 'Ninguno';
      double maxAcc = -1.0;
      double minAcc = 101.0;

      accuracyMap.forEach((game, acc) {
        if (acc > maxAcc) { maxAcc = acc; best = _formatGameName(game); }
        if (acc < minAcc) { minAcc = acc; worst = _formatGameName(game); }
      });

      emit(StatsState(
        sessions: sessions,
        isLoading: false,
        accuracyByGame: accuracyMap,
        strength: best,
        weakness: worst,
      ));
    });
  }

  String _formatGameName(String id) {
    return id.replaceAll('mates_', '').toUpperCase();
  }

  Map<String, double> _calculateAccuracy(List<GameSession> sessions) {
    Map<String, List<int>> totals = {}; 

    for (var s in sessions) {
      if (!totals.containsKey(s.gameId)) totals[s.gameId] = [0, 0];
      totals[s.gameId]![0] += s.successes;
      totals[s.gameId]![1] += s.totalAttempts;
    }

    return totals.map((key, val) => MapEntry(key, val[1] == 0 ? 0 : (val[0] / val[1]) * 100));
  }
}