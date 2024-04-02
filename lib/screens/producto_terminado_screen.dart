import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';

class ProductoTerminadoScreen extends StatefulWidget {
  const ProductoTerminadoScreen({Key? key}) : super(key: key);

  @override
  _ProductoTerminadoScreenState createState() =>
      _ProductoTerminadoScreenState();
}

class _ProductoTerminadoScreenState extends State<ProductoTerminadoScreen> {
  List<dynamic> _productosTerminados = [];

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _precioUnitarioController =
      TextEditingController();

  final GlobalKey<FormState> _agregarFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _editarFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchProductosTerminados().then((productos) {
      setState(() {
        _productosTerminados = productos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Productos Terminados',
          style: TextStyle(fontStyle: FontStyle.italic, color: Color.fromARGB(255, 0, 0, 0)),
        ),
        backgroundColor: const Color.fromARGB(255, 237, 226, 228), 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 171, 21, 126)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'cerrar_sesion') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'cerrar_sesion',
                child: Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _productosTerminados.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _productosTerminados.length,
              itemBuilder: (context, index) {
                final producto = _productosTerminados[index];
                final id = producto['_id'].toString();
                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  color: const Color.fromARGB(255, 189, 231, 241),
                  child: ListTile(
                    title: Text(
                      producto['nombre'] ?? 'Nombre no disponible',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    subtitle: Text(
                      'Cantidad: ${producto['cantidad']}, Precio: \$${producto['precioUnitario']}',
                      style: TextStyle(fontSize: 14.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 0, 0)),
                          onPressed: () {
                            editarProducto(id);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Color.fromARGB(255, 0, 0, 0)),
                          onPressed: () {
                            eliminarProducto(id);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.visibility, color: Color.fromARGB(255, 0, 0, 0)),
                          onPressed: () {
                            verDetalles(producto);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          _nombreController.clear();
          _cantidadController.clear();
          _precioUnitarioController.clear();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Crear producto Terminado',
                  style: TextStyle(fontStyle: FontStyle.italic, color: Color.fromARGB(255, 0, 0, 0)),
                ),
                content: SingleChildScrollView(
                  child: Form(
                    key: _agregarFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa el nombre';
                            }
                            if (!RegExp(r'^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$').hasMatch(value)) {
                              return 'El nombre solo puede contener letras, espacios y tildes';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _cantidadController,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          decoration: const InputDecoration(
                            labelText: 'Cantidad',
                            labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa la cantidad';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'La cantidad solo puede contener números';
                            }
                            if (value.length > 4) {
                              return 'La cantidad no puede tener más de 4 dígitos';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _precioUnitarioController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Precio Unitario',
                            labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa el precio unitario';
                            }
                            if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                              return 'Ingresa un precio unitario válido';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_agregarFormKey.currentState!.validate()) {
                        agregarProducto();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Agregar Producto', style: TextStyle(color: Colors.green)),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Color.fromARGB(255, 0, 0, 0)),
      ),
    );
  }

  Future<List<dynamic>> fetchProductosTerminados() async {
    final response =
        await http.get(Uri.parse('https://backdeliflutter.onrender.com/api/productos-terminados/'));

    if (response.statusCode == 200) {
      final List<dynamic> productos = jsonDecode(response.body);
      return productos;
    } else {
      throw Exception('Failed to load productos terminados');
    }
  }

  Future<void> agregarProducto() async {
    final Map<String, dynamic> nuevoProducto = {
      'nombre': _nombreController.text,
      'cantidad': int.parse(_cantidadController.text),
      'precioUnitario': _precioUnitarioController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('https://backdeliflutter.onrender.com/api/productos-terminados/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(nuevoProducto),
      );

      if (response.statusCode == 201) {
        fetchProductosTerminados().then((productos) {
          setState(() {
            _productosTerminados = productos;
          });
        });
      } else {
        throw Exception('Failed to add producto terminado');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> editarProducto(String id) async {
    final producto =
        _productosTerminados.firstWhere((element) => element['_id'] == id);
    _nombreController.text = producto['nombre'] ?? '';
    _cantidadController.text = producto['cantidad'].toString();
    _precioUnitarioController.text = producto['precioUnitario'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Editar Producto Terminado',
            style: TextStyle(fontStyle: FontStyle.italic, color: Color.fromARGB(255, 171, 21, 126)),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _editarFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el nombre';
                      }
                      if (!RegExp(r'^[a-zA-ZñÑáéíóúÁÉÍÓÚ\s]+$').hasMatch(value)) {
                        return 'El nombre solo puede contener letras, espacios y tildes';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cantidadController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa la cantidad';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'La cantidad solo puede contener números';
                      }
                      if (value.length > 4) {
                        return 'La cantidad no puede tener más de 4 dígitos';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _precioUnitarioController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Precio Unitario',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el precio unitario';
                      }
                      if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                        return 'Ingresa un precio unitario válido';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                if (_editarFormKey.currentState!.validate()) {
                  actualizarProducto(id);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar Cambios', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  Future<void> actualizarProducto(String id) async {
    final Map<String, dynamic> datosActualizados = {
      'nombre': _nombreController.text,
      'cantidad': int.parse(_cantidadController.text),
      'precioUnitario': _precioUnitarioController.text,
    };

    try {
      final response = await http.put(
        Uri.parse('https://backdeliflutter.onrender.com/api/productos-terminados/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datosActualizados),
      );

      if (response.statusCode == 200) {
        fetchProductosTerminados().then((productos) {
          setState(() {
            _productosTerminados = productos;
          });
        });
      } else {
        throw Exception('Failed to update producto terminado');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> eliminarProducto(String id) async {
  final confirmacion = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Eliminar Producto Terminado', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        content: const Text('¿Estás seguro de que deseas eliminar este producto terminado?', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 8, 102, 100))),
          ),
          TextButton(
            onPressed: () async {
              try {
                final response = await http.delete(
                  Uri.parse('https://backdeliflutter.onrender.com/api/productos-terminados/$id'),
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                );

                if (response.statusCode == 200) {
                  fetchProductosTerminados().then((productos) {
                    setState(() {
                      _productosTerminados = productos;
                    });
                  });
                } else {
                  throw Exception('Failed to delete producto terminado');
                }
              } catch (error) {
                print(error);
              }
              Navigator.of(context).pop(true);
            },
            child: const Text('Eliminar', style: TextStyle(color: Color.fromARGB(255, 95, 9, 9))),
          ),
        ],
      );
    },
  );

  if (confirmacion != null && confirmacion) {

  }
}


  void verDetalles(dynamic producto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del Producto', style: TextStyle(fontStyle: FontStyle.italic, color: Color.fromARGB(255, 171, 21, 126))),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombre: ${producto['nombre']}',
                  style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                ),
                Text(
                  'Cantidad: ${producto['cantidad']}',
                  style: const TextStyle(fontSize: 14.0, color: Color.fromARGB(255, 0, 0, 0)),
                ),
                Text(
                  'Precio Unitario: \$${producto['precioUnitario']}',
                  style: const TextStyle(fontSize: 14.0, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
