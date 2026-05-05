class Tutor {
  final String id; // El mismo UID de Firebase Auth
  final String nombre;
  final String email;
  final String especialidad; 

  Tutor({required this.id, required this.nombre, required this.email, required this.especialidad});
}