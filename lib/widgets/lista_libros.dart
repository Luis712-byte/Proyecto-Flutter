import 'package:flutter/material.dart';
import 'package:rubrica/Data/productos.dart';
import 'package:rubrica/Data/serviciosPro.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListaLibros extends StatelessWidget {
  final ServiciosPro spro = ServiciosPro();

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              color: Colors.brown, 
              child: Center(
                child: Text(
                  'Libros Disponibles',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Productos>>(
                stream: spro.listaProductos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Productos> libros = snapshot.data ?? [];
                    libros = libros.where((libro) => !libro.estado).toList();
                    return ListView.builder(
                      itemCount: libros.length,
                      itemBuilder: (context, index) {
                        Productos libro = libros[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 4.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: SizedBox(
                                      width: 100,
                                      height: 120,
                                      child: libro.imagenUrl.isNotEmpty &&
                                              Uri.tryParse(libro.imagenUrl)
                                                      ?.isAbsolute ==
                                                  true
                                          ? CachedNetworkImage(
                                              imageUrl: libro.imagenUrl,
                                              placeholder: (context, url) =>
                                                  CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(Icons.image_not_supported,
                                              size: 50),
                                    ),
                                  ),
                                  SizedBox(width: 16.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nombre: ${libro.nombre}',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Precio: ${libro.precio}',
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Descripción: ${libro.descripcion}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.bookmark,
                                        color:
                                            libro.estado ? Colors.green : null),
                                    onPressed: () {
                                      final horaReserva = DateTime.now();
                                      _mostrarDialogoReservarProducto(
                                          context, libro.id, horaReserva);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _mostrarDialogoReservarProducto(
      BuildContext context, String productoId, DateTime horaReserva) async {
    try {
      String usuarioEmail = await spro.obtenerCorreoUsuarioActual();

      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reservar Producto'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('¿Está seguro de que desea reservar este producto?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Reservar'),
                onPressed: () {
                  spro.cambiarEstadoReserva(
                      productoId, usuarioEmail, horaReserva, true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error al obtener el correo electrónico del usuario: $e');
    }
  }
}
