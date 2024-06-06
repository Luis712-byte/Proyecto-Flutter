import 'package:cloud_firestore/cloud_firestore.dart';

class Productos {
  final String id;
  final String nombre;
  final String precio;
  final String descripcion;
  final DateTime? horaReserva;
  final DateTime? horaDevuelto;
  final String usuarioPrestamo;
  final String imagenUrl;
  final bool estado;

  Productos({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.horaReserva,
    required this.horaDevuelto,
    required this.usuarioPrestamo,
    required this.imagenUrl,
    required this.estado,
  });

  factory Productos.fromMap(DocumentSnapshot doc, Map<String, dynamic> data) {
    Timestamp? horaReservaTimestamp = data['horaReserva'] as Timestamp?;
    DateTime? horaReserva;
    if (horaReservaTimestamp != null) {
      horaReserva = horaReservaTimestamp.toDate();
    }

    Timestamp? horaDevueltoTimestamp = data['horaDevuelto'] as Timestamp?;
    DateTime? horaDevuelto;
    if (horaDevueltoTimestamp != null) {
      horaDevuelto = horaDevueltoTimestamp.toDate();
    }

    return Productos(
      id: doc.id,
      nombre: data['nombre'] ?? '',
      precio: data['precio'] ?? '',
      descripcion: data['descripcion'] ?? '',
      horaReserva: horaReserva,
      horaDevuelto: horaDevuelto,
      usuarioPrestamo: data['usuarioPrestamo'] ?? '',
      imagenUrl: data['imagenUrl'] ?? '',
      estado: data['estado'] ?? false,
    );
  }
}
