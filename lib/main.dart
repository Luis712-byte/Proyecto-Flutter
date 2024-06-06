import 'package:flutter/material.dart';
import 'widgets/home.dart';
import 'widgets/prestamos.dart';
import 'widgets/inventario.dart';
import 'widgets/login.dart';
import 'widgets/configuracion.dart';
import 'widgets/acerca_de.dart';
import 'widgets/Registro.dart';
import 'widgets/informacion.dart';
import 'widgets/inicio.dart';
import 'widgets/adminHome.dart';
import 'widgets/lista_libros.dart';
import 'widgets/lista_usuarios.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? initialRoute = await determineInitialRoute();
  runApp(MyApp(initialRoute: initialRoute));
}

Future<String?> determineInitialRoute() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? usuario = prefs.getString('usuario');
  String? rol = prefs.getString('rol');

  if (usuario != null && rol == 'admin') {
    return '/adminHome';
  } else {
    return '/';
  }
}

class MyApp extends StatelessWidget {
  final String? initialRoute;

  MyApp({this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Biblioteca',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute ?? '/',
      routes: {
        '/': (context) => InicioPage(),
        '/home': (context) => HomePage(),
        '/adminHome': (context) => AdminHomePage(),
        '/prestamos': (context) => PrestamosPage(),
        '/informacion': (context) => UserInfoForm(),
        '/lista': (context) => ListaUsuariosPage(),
        '/libros': (context) => ListaLibros(),
        '/inventario': (context) => InventarioPage(),
        '/usuarios': (context) => UsuariosPage(),
        '/configuracion': (context) => ConfiguracionPage(),
        '/acerca_de': (context) => AcercaDePage(),
        '/registro': (context) => RegistroPage(),
      },
    );
  }
}
