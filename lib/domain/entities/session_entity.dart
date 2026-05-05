class GameSession {
  final String id;
  final String childId;
  final String gameId; // 'puzzle', 'memoria', 'mates'
  final DateTime date;
  final int score;
  final int totalAttempts;
  final int successes;
  final int failures;
  final Duration duration;

  GameSession({
    required this.id,
    required this.childId,
    required this.gameId,
    required this.date,
    this.score = 0,
    required this.totalAttempts,
    required this.successes,
    required this.failures,
    required this.duration,
  });
}