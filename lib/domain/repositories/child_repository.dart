import '../entities/child_entity.dart';

abstract class ChildRepository {
  Stream<List<Child>> getChildrenByTutor(String tutorId);
  Future<void> createChild(Child child);
  Future<void> updateRecordEncaje(String childId, int newRecord);
  Future<void> updateRecordParejas(String childId, int newRecord);
}
