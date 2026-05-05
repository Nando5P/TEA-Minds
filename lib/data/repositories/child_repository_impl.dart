import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/repositories/child_repository.dart';
import '../models/child_model.dart';

class ChildRepositoryImpl implements ChildRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> createChild(Child child) async {
    // Convertimos la entidad recibida a modelo para poder usar toMap()
    // Si ya es un ChildModel, hacemos un cast, si no, creamos uno nuevo.
    final model = ChildModel(
      id: child.id,
      nombre: child.nombre,
      tutorId: child.tutorId,
      especialistas: child.especialistas,
      color: child.color,
      tieneGafas: child.tieneGafas,
      recordEncaje: child.recordEncaje,
      createdAt: child.createdAt ?? DateTime.now(),
    );

    await _firestore.collection('children').add(model.toMap());
  }

  @override
  Stream<List<Child>> getChildrenByTutor(String tutorId) {
    return _firestore
        .collection('children')
        .where('tutor_id', isEqualTo: tutorId)
        .orderBy('created_at', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ChildModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  @override
  Future<void> updateRecordEncaje(String childId, int newRecord) async {
    try {
      await _firestore.collection('children').doc(childId).update({
        'record_encaje': newRecord,
      });
    } catch (e) {
      throw Exception('Error al actualizar el récord: $e');
    }
  }

  @override
  Future<void> updateRecordParejas(String childId, int newRecord) async {
    try {
      await _firestore.collection('children').doc(childId).update({
        'record_parejas': newRecord,
      });
    } catch (e) {
      throw Exception('Error al actualizar récord de parejas: $e');
    }
  }
}
