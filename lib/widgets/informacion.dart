import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rubrica/Data/servicioRegistro.dart';
import 'package:rubrica/widgets/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoForm extends StatefulWidget {
  @override
  _UserInfoFormState createState() => _UserInfoFormState();
}

class _UserInfoFormState extends State<UserInfoForm> {
  final ServicioRegistro _serRegis = ServicioRegistro();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _dirreccionController = TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();
  String _sexo = '';
  String _foto = '';
  bool _radiosHabilitados = true;
  bool _camposEditables = false;

  void _handleRadioValueChanged(String? value) {
    setState(() {
      _sexo = value!;
      _foto = _sexo == 'Masculino'
          ? 'https://th.bing.com/th/id/OIP.qCep1eHD4bA4X8-esW_X8QHaHa?rs=1&pid=ImgDetMain'
          : 'https://th.bing.com/th/id/R.b30826e589f4cfdb80225daf0720b9aa?rik=mNHekyFfArFSTw&riu=http%3a%2f%2fth36.st.depositphotos.com%2f1007566%2f13310%2fv%2f450%2fdepositphotos_133109886-stock-illustration-young-woman-profile-in-black.jpg&ehk=9RuGraXi1RwNH21FhOpiTSOEN4AdsnjlLqebo9Gd86c%3d&risl=&pid=ImgRaw&r=0';
    });
  }

  @override
  void initState() {
    super.initState();
    cargarInformacionUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFC0C0C0), Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Perfil de Usuario',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://th.bing.com/th/id/R.2042303200ef4e54b29b3845920142b1?rik=vyTMMinGP%2bAK9g&riu=http%3a%2f%2fwww.archaeology.wiki%2fwp-content%2fuploads%2f2014%2f01%2fBiblioteca-Real-Gabinete-de-Leitura-Rio-De-Janeiro-BRASILE_0016_EN.jpg&ehk=QdL22wHc3t2KHPcWfGecIQcSQy8Y2EKap6LZf4zfoR4%3d&risl=&pid=ImgRaw&r=0',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 4),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: _foto,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                enabled: _camposEditables,
                controller: _nombreController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Sexo',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Row(
                children: _radiosHabilitados
                    ? [
                        Radio(
                          value: 'Masculino',
                          groupValue: _sexo,
                          onChanged: _handleRadioValueChanged,
                        ),
                        Text(
                          'Masculino',
                          style: TextStyle(color: Colors.black),
                        ),
                        Radio(
                          value: 'Femenino',
                          groupValue: _sexo,
                          onChanged: _handleRadioValueChanged,
                        ),
                        Text(
                          'Femenino',
                          style: TextStyle(color: Colors.black),
                        ),
                      ]
                    : [
                        Text(
                          _sexo,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
              ),
              SizedBox(height: 20),
              TextField(
                enabled: _camposEditables,
                controller: _dirreccionController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Dirección',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                enabled: _camposEditables,
                controller: _ciudadController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Ciudad',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _crearInformacion();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _editarInformacion();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  'Editar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _crearInformacion() async {
    String foto = _foto;
    String nombre = _nombreController.text.trim();
    String sexo = _sexo;
    String direccion = _dirreccionController.text.trim();
    String ciudad = _ciudadController.text.trim();

    if (foto.isNotEmpty &&
        nombre.isNotEmpty &&
        sexo.isNotEmpty &&
        direccion.isNotEmpty &&
        ciudad.isNotEmpty) {
      try {
        await _serRegis.informacionUsuario(
            foto, nombre, sexo, direccion, ciudad);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('foto', foto);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('FELICIDADES!!!'),
            content: Text('Información guardada exitosamente'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('ERROR!!!'),
            content: Text(error.toString()),
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
          content: Text('Diligencie todos los campos'),
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

  void cargarInformacionUsuario() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('usuario') ?? '';
      Map<String, dynamic> userData =
          await _serRegis.obtenerInformacionUsuario(user);
      setState(() {
        _nombreController.text = userData['nombre'] ?? '';
        _dirreccionController.text = userData['direccion'] ?? '';
        _ciudadController.text = userData['ciudad'] ?? '';
        _sexo = userData['sexo'] ?? '';
        _foto = userData['foto'] ?? '';
        _radiosHabilitados = false;
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('ERROR!!!'),
          content: Text(error.toString()),
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

  void _editarInformacion() {
    setState(() {
      _camposEditables = true;
      _radiosHabilitados = true;
    });
  }
}
