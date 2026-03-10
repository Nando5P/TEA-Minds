import '../../domain/entities/user_entity.dart';

class UserModel extends UserApp {
  UserModel({
    required super.uid,
    required super.nombreCompleto,
    required super.email,
    required super.rol,
    required super.pinSeguridad,
    required super.listaNinos,
  });

  /// Transforma un Documento de Firebase (Map) en un objeto UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      nombreCompleto: map['nombre_completo'] ?? '',
      email: map['email'] ?? '',
      // Convertimos el String de la BD al Enum de nuestra Entidad
      rol: map['rol'] == 'especialista' 
          ? UserRole.especialista 
          : UserRole.tutor,
      pinSeguridad: map['pin_seguridad'] ?? '',
      listaNinos: List<String>.from(map['lista_ninos'] ?? []),
    );
  }

  /// Transforma nuestro objeto en un Map para enviarlo a Firebase
  Map<String, dynamic> toMap() {
    return {
      'nombre_completo': nombreCompleto,
      'email': email,
      // Guardamos el enum como un string sencillo en la base de datos
      'rol': rol == UserRole.especialista ? 'especialista' : 'tutor',
      'pin_seguridad': pinSeguridad,
      'lista_ninos': listaNinos,
    };
  }
}