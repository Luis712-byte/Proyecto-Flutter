import 'package:flutter/material.dart';
import 'package:rubrica/Data/servicioRegistro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final ServicioRegistro _serRegis = ServicioRegistro();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool logueado = false;

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
                    padding: EdgeInsets.only(
                        top: 180.0, left: 20.0, right: 20.0, bottom: 50.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 7.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
                        child: Column(
                          children: <Widget>[
                            Text(
                              '¡Hola Bienvenido!',
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Inicia sesión en tu biblioteca',
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
                                    _iniciarSesion();
                                  },
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Center(
                                    child: Text(
                                      'Iniciar Sesión',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '¿No tienes una cuenta?',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                SizedBox(width: 5.0),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed('/registro');
                                  },
                                  child: Text(
                                    '¡Regístrate!',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
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
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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

  void _iniciarSesion() async {
    String email = _userController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await _serRegis.iniciarSesion(email, password);
        SharedPreferences prefs = await SharedPreferences.getInstance();

        String? storedEmail = prefs.getString('usuario');
        if (storedEmail == null || storedEmail == email) {
          prefs.setBool('logueado', true);
          prefs.setString('usuario', email);
          setState(() {
            logueado = true;
          });
          Map<String, dynamic> userInfo =
              await _serRegis.obtenerInformacionUsuario(email);
          String? rol = userInfo['rol'];

          if (rol != null) {
            // Aquí estableces el rol en las preferencias compartidas
            prefs.setString('rol', rol);

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('¡Felicidades!'),
                content: Text('Has iniciado sesión exitosamente'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (rol == 'admin') {
                        Navigator.pushReplacementNamed(context, '/adminHome');
                      } else if (rol == 'estudiante') {
                        Navigator.pushReplacementNamed(context, '/home');
                      } else {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          } else {}
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('ERROR!!!'),
              content: Text('Correo electrónico no autorizado'),
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
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('ERROR!!!'),
            content: Text(e.toString()),
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
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ERROR!!!'),
          content: Text('Por favor complete todos los campos'),
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
    }
  }
}
