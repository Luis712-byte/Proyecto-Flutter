import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rubrica/Data/servicioRegistro.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ServicioRegistro _serRegis = ServicioRegistro();
  String? usuario;
  bool logueado = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: _buildAppBarActions(),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            color: Colors.grey,
            child: Center(
              child: Text(
                'Categorias',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              children: [
                _buildCategoriesSlider(),
              ],
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (_currentIndex == 1) {
              Navigator.pushReplacementNamed(context, '/informacion');
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (logueado) {
      return [
        Padding(
          padding: EdgeInsets.only(right: 300.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _showExplorationMenu(context);
                },
              ),
              Text(usuario ?? ''),
            ],
          ),
        ),
      ];
    } else {
      return [];
    }
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('usuario');

    if (user != null) {
      bool isLoggedIn = await _serRegis.isUserLoggedIn(user);
      setState(() {
        usuario = user;
        logueado = isLoggedIn;
      });
    } else {
      setState(() {
        logueado = false;
      });
    }
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('usuario');
    if (user != null) {
      await _serRegis.logout(user);
      prefs.remove('usuario');
      setState(() {
        usuario = null;
        logueado = false;
      });
      Navigator.pushReplacementNamed(context, '/usuarios');
    }
  }

  void _showExplorationMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.receipt),
                title: Text('Reservar Libro'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/libros');
                },
              ),
              ListTile(
                leading: Icon(Icons.book),
                title: Text('Libros Reservados'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/prestamos');
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Cerrar Sesión'),
                onTap: () {
                  _logout();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesSlider() {
    List<Map<String, dynamic>> categories = [
      {
        'name': 'Suspenso',
        'description':
            'Descubre las emocionantes historias llenas de misterio y tensión.',
        'imageURL':
            'https://th.bing.com/th/id/OIG2.mEzPsbGDsZEtgKESLkyx?w=1024&h=1024&rs=1&pid=ImgDetMain',
      },
      {
        'name': 'Comics',
        'description':
            'Explora el mundo de los cómics con personajes y aventuras únicas.',
        'imageURL':
            'https://th.bing.com/th/id/OIG4.KpM.2clZkIScTRdLXI_H?w=1024&h=1024&rs=1&pid=ImgDetMain',
      },
      {
        'name': 'Criminales',
        'description':
            'Sumérgete en el mundo del crimen con intrigantes historias y giros inesperados.',
        'imageURL':
            'https://th.bing.com/th/id/OIG3.ZSqXzsZXI0j1UR7VcqOP?w=1024&h=1024&rs=1&pid=ImgDetMain',
      },
    ];

    return Container(
      color: Colors.grey,
      width: 200,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryCard(categories[index]);
        },
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                image: NetworkImage(category['imageURL']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            category['name'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            category['description'], // Agregar descripción aquí
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
