import 'package:flutter/material.dart';
import 'package:rubrica/Data/registro.dart'; 
import 'package:rubrica/Data/servicioRegistro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListaUsuariosPage extends StatefulWidget {
  @override
  _ListaUsuariosPageState createState() => _ListaUsuariosPageState();
}

class _ListaUsuariosPageState extends State<ListaUsuariosPage> {
  final ServicioRegistro serviciosUsuarios = ServicioRegistro();

  late String currentUserEmail; 

  @override
  void initState() {
    super.initState();
    obtenerUsuarioActual(); 
  }

  Future<void> obtenerUsuarioActual() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserEmail = prefs.getString('usuario') ?? ''; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
      ),
      body: Center(
        child: StreamBuilder<List<Registro>>(
          stream: serviciosUsuarios.listaUsuarios(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Registro> usuarios = snapshot.data!;
              List<Registro> filteredUsers = usuarios.where((usuario) => usuario.user != currentUserEmail).toList();
              return ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  Registro usuario = filteredUsers[index];
                  return ListTile(
                    title: Text(usuario.nombre),
                    subtitle: Text(usuario.user),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _eliminarUsuario(usuario.id);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _eliminarUsuario(String userId) async {
    try {
      await serviciosUsuarios.eliminarUsuario(userId);
    } catch (e) {
      print('Error al eliminar usuario: $e');
    }
  }
}
