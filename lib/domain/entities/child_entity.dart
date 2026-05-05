class Child {
  final String id;
  final String nombre;
  final String tutorId;
  final List<String> especialistas;
  final String color;
  final bool tieneGafas; 
  final String? idPublico;
  final int recordEncaje; 
  final DateTime? createdAt; 

  Child({
    required this.id,
    required this.nombre,
    required this.tutorId,
    required this.especialistas,
    required this.color,
    required this.tieneGafas,
    this.idPublico,
    this.recordEncaje = 0, // Por defecto empieza en 0
    this.createdAt,
  });
}