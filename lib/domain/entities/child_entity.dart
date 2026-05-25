
class Child {
  final String id;
  final String nombre;
  final String color;
  final bool tieneGafas;
  final List<String> tutorIds;
  final int recordEncaje;
  final int recordParejas;

  Child({
    required this.id,
    required this.nombre,
    required this.color,
    required this.tieneGafas,
    required this.tutorIds,
    this.recordEncaje = 0,
    this.recordParejas = 0,
  });
}