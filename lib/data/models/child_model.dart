import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/child_entity.dart';

class ChildModel extends Child {
  ChildModel({
    required super.id,
    required super.nombre,
    required super.tutorId,
    required super.especialistas,
    required super.color,
    required super.tieneGafas,
    super.idPublico,
    super.recordEncaje = 0,
    super.createdAt,
  });

  factory ChildModel.fromMap(Map<String, dynamic> map, String id) {
    return ChildModel(
      id: id,
      nombre: map['nombre'] ?? '',
      tutorId: map['tutor_id'] ?? '',
      especialistas: List<String>.from(map['especialistas'] ?? []),
      color: map['color'] ?? '#FFCC00',
      tieneGafas: map['tiene_gafas'] ?? false,
      idPublico: map['id_publico'],
      recordEncaje: map['record_encaje'] ?? 0,
      createdAt: (map['created_at'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'tutor_id': tutorId,
      'especialistas': especialistas,
      'color': color,
      'tiene_gafas': tieneGafas,
      'id_publico': idPublico,
      'record_encaje': recordEncaje,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}