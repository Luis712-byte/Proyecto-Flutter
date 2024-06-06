import 'package:cloud_firestore/cloud_firestore.dart';


class Registro {
  final String id;
  final String user;
  final String password;
  final String role;
  final String nombre;
  final String ciudad;
  final String direccion;
  final String foto;
  final bool logueado;

  Registro({
    required this.id,
    required this.user,
    required this.password,
    required this.role,
    required this.nombre,
    required this.ciudad,
    required this.direccion,
    required this.foto,
    required this.logueado,
  });

  factory Registro.fromMap(DocumentSnapshot doc, Map<String, dynamic> data) {
    return Registro(
      id: doc.id,
      user: data['usuario'] ?? '',
      password: data['contraseña'] ?? '',
      role: data['rol'] ?? '',
      nombre: data['nombre'] ?? '',
      direccion: data['direccion'] ?? '',
      ciudad: data['ciudad'] ?? '',
      foto: data['foto'] ?? '',
      logueado: data['logueado'] ?? false,
    );
  }
}
