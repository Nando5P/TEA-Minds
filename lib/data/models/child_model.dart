import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/child_entity.dart';

class ChildModel extends Child {
  ChildModel({
    required super.id,
    required super.nombre,
    required super.tutorId,
    required super.color,
    required super.tieneGafas,
    super.recordEncaje = 0,
    super.recordParejas = 0,
  });

  factory ChildModel.fromMap(Map<String, dynamic> map, String id) {
    return ChildModel(
      id: id,
      nombre: map['nombre'] ?? '',
      tutorId: map['tutor_id'] ?? '',
      color: map['color'] ?? '#FFCC00',
      tieneGafas: map['tiene_gafas'] ?? false,
      recordEncaje: map['record_encaje'] ?? 0,
      recordParejas: map['record_parejas'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'tutor_id': tutorId,
      'color': color,
      'tiene_gafas': tieneGafas,
      'record_encaje': recordEncaje,
      'record_parejas': recordParejas,
      // Usamos serverTimestamp para que Firebase ponga la hora del servidor
      'updated_at': FieldValue.serverTimestamp(),
    };
  }
}