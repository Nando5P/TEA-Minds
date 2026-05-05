import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/entities/tutor_entity.dart';
import '../../domain/entities/session_entity.dart';
import '../../domain/repositories/child_repository.dart';

class ChildRepositoryImpl implements ChildRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==========================================
  // GESTIÓN DE NIÑOS
  // ==========================================

  @override
  Stream<List<Child>> getChildrenByTutor(String tutorId) {
    return _firestore
        .collection('children')
        .where('tutor_id', isEqualTo: tutorId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return Child(
                id: doc.id,
                nombre: data['nombre'] ?? '',
                color: data['color'] ?? '#FFFFFF',
                tieneGafas: data['tiene_gafas'] ?? false,
                tutorId: data['tutor_id'] ?? '', // Relación con el tutor
                recordEncaje: data['record_encaje'] ?? 0,
                recordParejas: data['record_parejas'] ?? 0,
              );
            }).toList());
  }

  @override
  Future<void> createChild(Child child) async {
    try {
      await _firestore.collection('children').add({
        'nombre': child.nombre,
        'color': child.color,
        'tiene_gafas': child.tieneGafas,
        'tutor_id': child.tutorId, // Guardamos la vinculación
        'record_encaje': 0,
        'record_parejas': 0,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al crear el perfil del niño: $e');
    }
  }

  @override
  Future<void> updateRecordEncaje(String childId, int nuevoRecord) async {
    await _firestore.collection('children').doc(childId).update({
      'record_encaje': nuevoRecord,
    });
  }

  @override
  Future<void> updateRecordParejas(String childId, int nuevoRecord) async {
    await _firestore.collection('children').doc(childId).update({
      'record_parejas': nuevoRecord,
    });
  }

  // ==========================================
  // GESTIÓN DE TUTOR (3ª Entidad)
  // ==========================================

  @override
  Future<void> createTutor(Tutor tutor) async {
    try {
      await _firestore.collection('tutors').doc(tutor.id).set({
        'nombre': tutor.nombre,
        'email': tutor.email,
        'especialidad': tutor.especialidad,
        'created_at': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Error al registrar datos del tutor: $e');
    }
  }

  @override
  Future<Tutor?> getTutorById(String tutorId) async {
    try {
      final doc = await _firestore.collection('tutors').doc(tutorId).get();
      if (!doc.exists) return null;
      
      final data = doc.data()!;
      return Tutor(
        id: doc.id,
        nombre: data['nombre'] ?? '',
        email: data['email'] ?? '',
        especialidad: data['especialidad'] ?? '',
      );
    } catch (e) {
      return null;
    }
  }

  // ==========================================
  // GESTIÓN DE SESIONES (Estadísticas)
  // ==========================================

  @override
  Future<void> saveGameSession(GameSession session) async {
    try {
      await _firestore.collection('sessions').add({
        'child_id': session.childId,
        'game_id': session.gameId, // 'puzzle', 'memoria', 'mates'
        'date': Timestamp.fromDate(session.date),
        'total_attempts': session.totalAttempts,
        'successes': session.successes,
        'failures': session.failures,
        'duration_ms': session.duration.inMilliseconds,
      });
    } catch (e) {
      print('Error al guardar sesión: $e');
    }
  }

  @override
  Stream<List<GameSession>> getSessionsByChild(String childId) {
    return _firestore
        .collection('sessions')
        .where('child_id', isEqualTo: childId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
              final d = doc.data();
              return GameSession(
                id: doc.id,
                childId: d['child_id'],
                gameId: d['game_id'],
                date: (d['date'] as Timestamp).toDate(),
                totalAttempts: d['total_attempts'],
                successes: d['successes'],
                failures: d['failures'],
                duration: Duration(milliseconds: d['duration_ms']),
              );
            }).toList());
  }
}