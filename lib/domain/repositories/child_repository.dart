import '../entities/child_entity.dart';
import '../entities/tutor_entity.dart';
import '../entities/session_entity.dart';

abstract class ChildRepository {
  Stream<List<Child>> getChildrenByTutor(String tutorId);
  Future<void> createChild(Child child);

  // Añadimos ambos métodos de récords
  Future<void> updateRecordEncaje(String childId, int nuevoRecord);
  Future<void> updateRecordParejas(String childId, int nuevoRecord);

  Future<void> createTutor(Tutor tutor);
  Future<Tutor?> getTutorById(String tutorId);

  Future<void> saveGameSession(GameSession session);
  Stream<List<GameSession>> getSessionsByChild(String childId);
}
