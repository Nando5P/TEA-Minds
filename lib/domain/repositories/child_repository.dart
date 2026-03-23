import '../../data/models/child_model.dart';

abstract class ChildRepository {
  Future<void> createChild(ChildModel child);
  Stream<List<ChildModel>> getChildrenByTutor(String tutorId);
}