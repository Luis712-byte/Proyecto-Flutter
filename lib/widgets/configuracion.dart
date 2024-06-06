import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfiguracionPage extends StatefulWidget {
  @override
  _ConfiguracionPageState createState() => _ConfiguracionPageState();
}

class _ConfiguracionPageState extends State<ConfiguracionPage> {
  String _defaultAvatarUrl =
      'https://th.bing.com/th/id/OIP.2g45FJQ43PSMJ-55a-n1yAAAAA?rs=1&pid=ImgDetMain';
  String _avatarImageUrl = '';
  String _userName = 'Usuario';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  void _loadUserProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String user = prefs.getString('usuario') ?? '';

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection("Usuarios")
              .where('usuario', isEqualTo: user)
              .where('logueado', isEqualTo: true)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> doc = querySnapshot.docs.first;
        Map<String, dynamic> userData = doc.data() ?? {};

        setState(() {
          _avatarImageUrl = userData['foto'] ?? _defaultAvatarUrl;
          _userName = userData['nombre'] ?? 'Usuario';
        });

        await prefs.setString('foto', _avatarImageUrl);
        await prefs.setString('nombre', _userName);

        _userName = 'Bienvenido $_userName';

        print(
            "User data loaded from Firestore: nombre = $_userName, foto = $_avatarImageUrl");
      } else {
        print(
            "User document not found or not logged in according to Firestore.");
      }
    } catch (error) {
      print("Error loading user profile: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_userName),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
           colors: [Color(0xFFC0C0C0), Color(0xFFFFFFFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20.0),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: _avatarImageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20.0),
                  _buildOptionButton(
                      context, 'Editar información', '/informacion'),
                  SizedBox(height: 10.0),
                  _buildOptionButton(context, 'Agregar libro', '/inventario'),
                  SizedBox(height: 10.0),
                  _buildOptionButton(context, 'Préstamos', '/prestamos'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String label, String route) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(route);
        },
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
