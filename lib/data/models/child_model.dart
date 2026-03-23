import '../../domain/entities/child_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildModel extends Child {
  ChildModel({
    required super.id,
    required super.nombre,
    required super.tutorId,
    required super.especialistas,
    required super.color,
    required super.tieneGafas,
    super.idPublico,
  });

  factory ChildModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ChildModel(
      id: documentId,
      idPublico: map['id_publico'] ?? '',
      nombre: map['nombre'] ?? '',
      tutorId: map['tutor_id'] ?? '',
      especialistas: List<String>.from(map['especialistas'] ?? []),
      color: map['color'] ?? '#FFF9C4',
      // Mapeamos el booleano desde Firebase
      tieneGafas: map['tiene_gafas'] ?? false, 
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id_publico': idPublico,
      'nombre': nombre,
      'tutor_id': tutorId,
      'especialistas': especialistas,
      'color': color,
      'tiene_gafas': tieneGafas, // Guardamos true/false
      'created_at': FieldValue.serverTimestamp(),
    };
  }
}