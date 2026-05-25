import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/child_entity.dart';

class ChildModel extends Child {
  ChildModel({
    required super.id,
    required super.nombre,
    required List<String> tutorIds,
    required super.color,
    required super.tieneGafas,
    super.recordEncaje = 0,
    super.recordParejas = 0,
  }) : super(tutorIds: tutorIds);

  factory ChildModel.fromMap(Map<String, dynamic> map, String id) {
    return ChildModel(
      id: id,
      nombre: map['nombre'] ?? '',
      tutorIds: List<String>.from(map['tutor_ids'] ?? []),
      color: map['color'] ?? '#FFCC00',
      tieneGafas: map['tiene_gafas'] ?? false,
      recordEncaje: map['record_encaje'] ?? 0,
      recordParejas: map['record_parejas'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'tutor_ids': tutorIds,
      'color': color,
      'tiene_gafas': tieneGafas,
      'record_encaje': recordEncaje,
      'record_parejas': recordParejas,
      'updated_at': FieldValue.serverTimestamp(),
    };
  }
}