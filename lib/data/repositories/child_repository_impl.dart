import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/child_repository.dart';
import '../models/child_model.dart';

class ChildRepositoryImpl implements ChildRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createChild(ChildModel child) async {
    await _firestore.collection('children').add(child.toMap());
  }

  @override
  Stream<List<ChildModel>> getChildrenByTutor(String tutorId) {
    return _firestore
        .collection('children')
        .where('tutor_id', isEqualTo: tutorId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChildModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}