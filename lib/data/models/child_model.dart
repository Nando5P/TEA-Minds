import '../../domain/entities/child_entity.dart';

class ChildModel extends Child {
  ChildModel({
    required super.id,
    required super.idPublico,
    required super.nombre,
    required super.tutorPrincipal,
    required super.especialistas,
    required super.configAvatar,
  });

  /// Transforma un Documento de Firebase (Map) en un objeto ChildModel
  factory ChildModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ChildModel(
      id: documentId,
      idPublico: map['id_publico'] ?? '',
      nombre: map['nombre'] ?? '',
      tutorPrincipal: map['tutor_principal'] ?? '',
      // Convertimos el dynamic list de Firebase a una lista de Strings
      especialistas: List<String>.from(map['especialistas'] ?? []),
      // Convertimos el map de Firebase a nuestro mapa de strings
      configAvatar: Map<String, String>.from(map['config_avatar'] ?? {}),
    );
  }

  /// Transforma nuestro objeto en un Map para enviarlo a Firebase
  Map<String, dynamic> toMap() {
    return {
      'id_publico': idPublico,
      'nombre': nombre,
      'tutor_principal': tutorPrincipal,
      'especialistas': especialistas,
      'config_avatar': configAvatar,
    };
  }
}