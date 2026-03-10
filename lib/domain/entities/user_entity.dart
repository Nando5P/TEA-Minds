
enum UserRole { tutor, especialista }

class UserApp {
  final String uid;
  final String nombreCompleto;
  final String email;
  final UserRole rol;
  final String pinSeguridad;      // El hash del PIN
  final List<String> listaNinos;  // IDs de los pollitos vinculados

  UserApp({
    required this.uid,
    required this.nombreCompleto,
    required this.email,
    required this.rol,
    required this.pinSeguridad,
    required this.listaNinos,
  });
}