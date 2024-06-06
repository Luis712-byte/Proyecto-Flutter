import 'package:flutter/material.dart';
import 'dart:io';
import 'package:rubrica/Data/productos.dart';
import 'package:rubrica/Data/serviciosPro.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class InventarioPage extends StatefulWidget {
  @override
  _InventarioPageState createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  final ServiciosPro spro = ServiciosPro();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  late TextEditingController _filterController;
  File? _imageFile;

  String usuarioEmail = '';

  double filtroPrecio = 100000;

  @override
  void initState() {
    super.initState();
    _filterController = TextEditingController(text: filtroPrecio.toString());
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              color: Colors.brown,
              child: Center(
                child: Text(
                  'Inventario',
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
                  stream: spro.listaProductos(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      List<Productos> productos = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.filter_list,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _filterController,
                                            keyboardType: TextInputType.number,
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              hintText: 'Precio máximo',
                                              hintStyle: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.8),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 20.0,
                                                  right: 0.0),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.transparent),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      filtroPrecio =
                                          double.parse(_filterController.text);
                                    });
                                  },
                                  child: Text('Filtrar'),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 500),
                              child: ListView.builder(
                                key: UniqueKey(),
                                itemCount: productos.length,
                                itemBuilder: (context, index) {
                                  Productos producto = productos[index];
                                  if (producto.estado ||
                                      double.parse(producto.precio) >
                                          filtroPrecio) {
                                    return SizedBox.shrink();
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Card(
                                        elevation: 4.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: SizedBox(
                                                  width: 100,
                                                  height: 120,
                                                  child: producto.imagenUrl
                                                              .isNotEmpty &&
                                                          Uri.tryParse(producto
                                                                      .imagenUrl)
                                                                  ?.isAbsolute ==
                                                              true
                                                      ? CachedNetworkImage(
                                                          imageUrl: producto
                                                              .imagenUrl,
                                                          placeholder: (context,
                                                                  url) =>
                                                              CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Icon(Icons.error),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Icon(
                                                          Icons
                                                              .image_not_supported,
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
                                                      'Nombre: ${producto.nombre}',
                                                      style: TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(height: 8.0),
                                                    Text(
                                                      'Precio: ${producto.precio}',
                                                    ),
                                                    SizedBox(height: 8.0),
                                                    Text(
                                                      'Descripción: ${producto.descripcion}',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      _mostrarDialogoEliminarProducto(
                                                          context, producto.id);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      _mostrarDialogoEditarProducto(
                                                          context, producto);
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.bookmark,
                                                        color: producto.estado
                                                            ? Colors.green
                                                            : null),
                                                    onPressed: () {
                                                      final horaReserva =
                                                          DateTime.now();
                                                      _mostrarDialogoReservarProducto(
                                                          producto.id,
                                                          horaReserva);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoAgregarProducto(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _mostrarDialogoAgregarProducto(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Producto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _precioController,
                  decoration: InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'descripcion'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(labelText: 'URL de la Imagen'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                _limpiarCampos();
              },
            ),
            TextButton(
              child: Text('Agregar'),
              onPressed: () {
                String imageUrl = _imageUrlController.text;
                if (imageUrl.isNotEmpty) {
                  spro.crearProducto(
                      _nombreController.text,
                      _precioController.text,
                      _descripcionController.text,
                      imageUrl);
                } else if (_imageFile != null) {
                  spro.subirImagen(_imageFile!).then((imageUrl) {
                    spro.crearProducto(
                        _nombreController.text,
                        _precioController.text,
                        _descripcionController.text,
                        imageUrl);
                  });
                } else {
                  print(
                      'Por favor selecciona una imagen o proporciona una URL');
                }
                Navigator.of(context).pop();
                _limpiarCampos();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarDialogoEditarProducto(
      BuildContext context, Productos producto) async {
    _nombreController.text = producto.nombre;
    _precioController.text = producto.precio;
    _descripcionController.text = producto.descripcion;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Producto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: _precioController,
                  decoration: InputDecoration(labelText: 'Precio'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(labelText: 'Descripcion'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                _limpiarCampos();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                Map<String, dynamic> data = {
                  'nombre': _nombreController.text,
                  'precio': _precioController.text,
                  'descripcion': _descripcionController.text
                };
                if (_imageFile != null) {
                  spro.editarProducto(producto.id, data);
                } else {
                  spro.editarProducto(producto.id, data);
                }
                Navigator.of(context).pop();
                _limpiarCampos();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarDialogoEliminarProducto(
      BuildContext context, String productId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Producto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Está seguro de que desea eliminar este producto?'),
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
              child: Text('Eliminar'),
              onPressed: () {
                spro.eliminarProducto(productId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _mostrarDialogoReservarProducto(
      String productoId, DateTime horaReserva) async {
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

  void _limpiarCampos() {
    _nombreController.clear();
    _precioController.clear();
    _descripcionController.clear();
    _imageUrlController.clear();
    setState(() {
      _imageFile = null;
    });
  }
}
