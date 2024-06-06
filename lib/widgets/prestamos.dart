import 'package:flutter/material.dart';
import 'package:rubrica/Data/productos.dart';
import 'package:rubrica/Data/serviciosPro.dart';

class PrestamosPage extends StatelessWidget {
  final ServiciosPro spro = ServiciosPro();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFC0C0C0), Color(0xFFFFFFFF)],
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
                  'Libros Reservados',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: StreamBuilder<List<Productos>>(
                  stream: spro.obtenerProductosPrestados(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.white),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text(
                        'No hay productos prestados.',
                        style: TextStyle(color: Colors.black),
                      );
                    } else {
                      List<Productos> prestamos = snapshot.data!;
                      return ListView.builder(
                        itemCount: prestamos.length,
                        itemBuilder: (context, index) {
                          Productos producto = prestamos[index];
                          if (!producto.estado) {
                            return SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          producto.imagenUrl,
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            producto.nombre,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            producto.descripcion,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            producto.precio,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.bookmark,
                                          color: producto.estado
                                              ? Colors.green
                                              : Colors.grey),
                                      onPressed: () {
                                        spro.devolverProducto(
                                            producto.id, false);
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
            ),
          ],
        ),
      ),
    );
  }
}
