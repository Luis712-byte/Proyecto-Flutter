import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'registro.dart';

class ServicioRegistro {
  static String? userRole;
  final FirebaseFirestore fs = FirebaseFirestore.instance;

  Future<void> crearUsuario(String user, String password, String role) async {
    try {
      await fs.collection("Usuarios").add({
        'usuario': user,
        'contraseña': password,
        'rol': role,
        'logueado': false
      });
    } catch (e) {
      print("Error creating user: $e");
    }
  }

  Future<void> informacionUsuario(String foto, String nombre, String sexo,
      String direccion, String ciudad) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usuario = prefs.getString('usuario');

    if (usuario == null) {
      print("Error: No se ha logueado ningún usuario.");
      return;
    }

    try {
      QuerySnapshot query = await fs
          .collection("Usuarios")
          .where('usuario', isEqualTo: usuario)
          .get();
      if (query.docs.isNotEmpty) {
        var doc = query.docs.first;
        await doc.reference.update({
          'foto': foto,
          'nombre': nombre,
          'sexo': sexo,
          'direccion': direccion,
          'ciudad': ciudad,
        });
      } else {
        print("Error: No se encontró el usuario.");
      }
    } catch (e) {
      print("Error updating user information: $e");
    }
  }

  Future<void> eliminarUsuario(String id) async {
    try {
      await fs.collection("Usuarios").doc(id).delete();
    } catch (e) {
      print("Error $e");
    }
  }
  Stream<List<Registro>> listaUsuarios() {
    return fs.collection('Usuarios').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Registro.fromMap(doc, doc.data())).toList();
    });
  }

  Future<void> iniciarSesion(String user, String password) async {
  try {
    QuerySnapshot query = await fs
        .collection("Usuarios")
        .where('usuario', isEqualTo: user)
        .where('contraseña', isEqualTo: password)
        .get();
    if (query.docs.isNotEmpty) {
      var doc = query.docs.first;
      await doc.reference.update({'logueado': true});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('usuario', user);
      String? userRole = doc['rol']; 
      print('Rol del usuario: $userRole');
      ServicioRegistro.userRole = userRole; 
    } else {
      throw Exception('Usuario o contraseña incorrectos');
    }
  } catch (e) {
    throw Exception('Error al iniciar sesión: $e');
  }
}


  Future<void> logout(String user) async {
    var querySnapshot =
        await fs.collection('Usuarios').where('usuario', isEqualTo: user).get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      await doc.reference.update({'logueado': false});
    }
  }

  Future<bool> isUserLoggedIn(String email) async {
    var querySnapshot = await fs
        .collection('Usuarios')
        .where('usuario', isEqualTo: email)
        .where('logueado', isEqualTo: true)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<Map<String, dynamic>> obtenerInformacionUsuario(String user) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await fs
          .collection("Usuarios")
          .where('usuario', isEqualTo: user)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> doc = querySnapshot.docs.first;
        return doc.data() ?? {};
      } else {
        return {};
      }
    } catch (error) {
      throw Exception("Error al obtener la información del usuario: $error");
    }
  }

  Future<bool> emailExiste(String user) async {
    try {
      final querySnapshot = await fs
          .collection('Usuarios')
          .where('usuario', isEqualTo: user)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error al verificar el email: $e');
      throw e;
    }
  }
}
