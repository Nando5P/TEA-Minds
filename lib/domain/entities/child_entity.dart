class Child {
  final String id;
  final String nombre;
  final String color;
  final bool tieneGafas;
  final String tutorId; // Campo obligatorio para la relación
  final int recordEncaje;
  final int recordParejas;

  Child({
    required this.id,
    required this.nombre,
    required this.color,
    required this.tieneGafas,
    required this.tutorId,
    this.recordEncaje = 0,
    this.recordParejas = 0,
  });
}