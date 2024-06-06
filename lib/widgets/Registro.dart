import 'package:flutter/material.dart';
import 'package:rubrica/Data/servicioRegistro.dart';
import 'login.dart';
import 'dart:core';

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    caseSensitive: false,
    multiLine: false,
  );
  return emailRegex.hasMatch(email);
}

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ServicioRegistro _serRegis = ServicioRegistro();
  String _selectedRole = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
               colors: [Color(0xFFC0C0C0), Color(0xFFFFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(top: 150.0, left: 20.0, right: 20.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 7.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '¡Ven y Registrate!',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Este es el formulario de registro de GoService',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextField(
                              controller: _userController,
                              decoration: InputDecoration(
                                labelText: 'EMAIL',
                                labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: 10.0),
                            TextField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'PASSWORD ',
                                labelStyle: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                              obscureText: true,
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'Selecciona tu rol:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            RadioListTile(
                              title: Text('Estudiante'),
                              value: 'estudiante',
                              groupValue: _selectedRole,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value.toString();
                                });
                              },
                            ),
                            RadioListTile(
                              title: Text('Admin'),
                              value: 'admin',
                              groupValue: _selectedRole,
                              onChanged: (value) {
                                setState(() {
                                  _selectedRole = value.toString();
                                });
                              },
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              height: 40.0,
                              width: double.infinity,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.blue,
                                elevation: 7.0,
                                child: InkWell(
                                  onTap: () {
                                    _crearUsuario();
                                  },
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Center(
                                    child: Text(
                                      'Registrarme',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              height: 40.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                borderRadius: BorderRadius.circular(20.0),
                                child: Center(
                                  child: Text(
                                    '¿Ya tienes cuenta?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/logo.jpeg'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _crearUsuario() async {
    String user = _userController.text.trim();
    String password = _passwordController.text.trim();
    String rol = _selectedRole;

    if (user.isEmpty || password.isEmpty || rol.isEmpty) {
      _mostrarAlerta('ERROR!!!', 'Diligencie todos los campos');
      return;
    }

    if (!isValidEmail(user)) {
      _mostrarAlerta(
          'ERROR!!!', 'El correo electrónico ingresado no es válido');
      return;
    }

    try {
      bool existe = await _serRegis.emailExiste(user);
      if (existe) {
        _mostrarAlerta('ERROR!!!', 'El correo electrónico ya está registrado');
      } else {
        await _serRegis.crearUsuario(user, password, rol);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('FELICIDADES!!!'),
                  content: Text('Usuario creado exitosamente'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsuariosPage()),
                        );
                      },
                      child: Text('OK'),
                    )
                  ],
                ));
      }
    } catch (error) {
      _mostrarAlerta('ERROR!!!', 'Error al verificar email: $error');
    }
  }

  void _mostrarAlerta(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );

    void _limpiarCampos() {
      _userController.clear();
      _passwordController.clear();
    }
  }
}
