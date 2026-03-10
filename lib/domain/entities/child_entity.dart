// lib/domain/entities/child_entity.dart

class Child {
  final String id;                         // ID interno de Firebase
  final String idPublico;                  // El código tipo #1aVt77aJ
  final String nombre;                     // Nombre del niño/pollito
  final String tutorPrincipal;             // UID del padre/madre
  final List<String> especialistas;        // UIDs de los profesionales
  final Map<String, String> configAvatar;  // {color: 'verde', accesorio: 'gafas'}

  Child({
    required this.id,
    required this.idPublico,
    required this.nombre,
    required this.tutorPrincipal,
    required this.especialistas,
    required this.configAvatar,
  });
}