import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rubrica/Data/productos.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class ServiciosPro {
  final FirebaseFirestore fs = FirebaseFirestore.instance;
  final FirebaseAuth fa = FirebaseAuth.instance;

  Future<String> subirImagen(File imageFile) async {
    try {
      String fileName = path.basename(imageFile.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('productos/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw e;
    }
  }

  Future<void> crearProducto(
    String nombre,
    String precio,
    String descripcion,
    String imageUrl,
  ) async {
    try {
      await fs.collection("Productos").add({
        'nombre': nombre,
        'precio': precio,
        'descripcion': descripcion,
        'imagenUrl': imageUrl,
        'estado': false,
      });
    } catch (e) {
      print("Error creating product: $e");
    }
  }

  Future<void> eliminarProducto(String id) async {
    try {
      await fs.collection("Productos").doc(id).delete();
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> editarProducto(String id, Map<String, dynamic> dato,
      [File? imageFile]) async {
    try {
      if (imageFile != null) {
        String imageUrl = await subirImagen(imageFile);
        dato['imagenUrl'] = imageUrl;
      }
      await fs.collection("Productos").doc(id).update(dato);
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> cambiarEstadoReserva(
      String id, String usuarioEmail, DateTime horaReserva, bool estado) async {
    try {
      await fs.collection("Productos").doc(id).update({
        'estado': estado,
        'horaReserva': horaReserva,
        'usuarioPrestamo': usuarioEmail,
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> devolverProducto(String id, bool estado) async {
    try {
      DateTime horaDevuelto = DateTime.now();
      await fs.collection("Productos").doc(id).update({
        'estado': estado,
        'horaDevuelto': horaDevuelto,
        'usuarioPrestamo': null,
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Stream<List<Productos>> listaProductos() {
    return fs.collection("Productos").snapshots().map((snap) =>
        snap.docs.map((doc) => Productos.fromMap(doc, doc.data())).toList());
  }

  Future<String> obtenerCorreoUsuarioActual() async {
    try {
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('Usuarios')
          .where('logueado', isEqualTo: true)
          .limit(1)
          .get();

      if (usersSnapshot.docs.isNotEmpty) {
        String? userEmail = usersSnapshot.docs.first['usuario'] as String?;
        if (userEmail != null && userEmail.isNotEmpty) {
          return userEmail;
        }
      }

      return '';
    } catch (e) {
      print('Error al obtener el correo electrónico del usuario: $e');
      return '';
    }
  }

 Stream<List<Productos>> obtenerProductosPrestados() async* {
    String usuarioEmail = await obtenerCorreoUsuarioActual();
    if (usuarioEmail.isEmpty) {
      yield [];
      return;
    }

    print('Usuario logueado: $usuarioEmail');

    try {
      Stream<QuerySnapshot> snapshotStream = fs
          .collection("Productos")
          .where('estado', isEqualTo: true)
          .where('usuarioPrestamo', isEqualTo: usuarioEmail)
          .snapshots();

      await for (var querySnapshot in snapshotStream) {
        List<Productos> productos = querySnapshot.docs.map((doc) {
          print('Producto encontrado: ${doc.data()}');
          return Productos.fromMap(doc, doc.data() as Map<String, dynamic>);
        }).toList();
        yield productos;
      }
    } catch (error) {
      print('Error al obtener los productos prestados: $error');
      yield [];
    }
  }
}