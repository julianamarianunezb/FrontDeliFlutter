import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login_screen.dart'; 

class OrdenesProduccionScreen extends StatefulWidget {
  const OrdenesProduccionScreen({Key? key}) : super(key: key);

  @override
  State<OrdenesProduccionScreen> createState() =>
      _OrdenesProduccionScreenState();
}

class _OrdenesProduccionScreenState extends State<OrdenesProduccionScreen> {
  List<dynamic> _ordenesProduccion = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreClienteController =
      TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _numeroOrdenPedidoController =
      TextEditingController();
  final TextEditingController _productoController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _valorAPagarController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchOrdenesProduccion().then((ordenes) {
      setState(() {
        _ordenesProduccion = ordenes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Órdenes de Producción/Pedidos',
          style: TextStyle(fontStyle: FontStyle.italic, color: Color.fromARGB(255, 0, 0, 0))
        ),
        backgroundColor: const Color.fromARGB(255, 237, 226, 228), 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'cerrar_sesion',
                child: Text('Cerrar sesión', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _ordenesProduccion.length,
        itemBuilder: (context, index) {
          final orden = _ordenesProduccion[index];
          final id = orden['_id'].toString();
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            color: const Color.fromARGB(255, 189, 231, 241),
            child: ListTile(
              title: Text(orden['numeroOrdenPedido'],
                  style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
              subtitle: Text(orden['nombreCliente'],
                  style: const TextStyle(fontSize: 14.0, color: Colors.black)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                      editarOrdenProduccion(id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black),
                    onPressed: () {
                      eliminarOrdenProduccion(id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Colors.black),
                    onPressed: () {
                      visualizarOrdenProduccion(id);
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
          
          _nombreClienteController.clear();
          _telefonoController.clear();
          _cedulaController.clear();
          _numeroOrdenPedidoController.clear();
          _productoController.clear();
          _cantidadController.clear();
          _valorAPagarController.clear();
          
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Crear Nueva Orden de Producción',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black)),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nombreClienteController,
                          decoration: const InputDecoration(
                              labelText: 'Nombres y Apellidos del Cliente',
                              labelStyle: TextStyle(color: Colors.black)),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa el nombre del cliente';
                            }
                            if (!RegExp(r'^[a-zA-ZáéíóúñÑÁÉÍÓÚüÜ ]+$').hasMatch(value)) {
                              return 'El nombre solo puede contener letras';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _telefonoController,
                          decoration: const InputDecoration(
                              labelText: 'Teléfono',
                              labelStyle: TextStyle(color: Colors.black)),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa el teléfono';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'El teléfono solo puede contener números';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _cedulaController,
                          decoration: const InputDecoration(
                              labelText: 'Cédula',
                              labelStyle: TextStyle(color: Colors.black)),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa la cédula';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'La cédula solo puede contener números';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _numeroOrdenPedidoController,
                          decoration: const InputDecoration(
                              labelText: 'Número de Orden/Pedido',
                              labelStyle: TextStyle(color: Colors.black)),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa el número de orden/pedido';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _productoController,
                          decoration: const InputDecoration(
                              labelText: 'Producto',
                              labelStyle: TextStyle(color: Colors.black)),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa el producto';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _cantidadController,
                          decoration: const InputDecoration(
                              labelText: 'Cantidad',
                              labelStyle: TextStyle(color: Colors.black)),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa la cantidad';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'La cantidad solo puede contener números';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _valorAPagarController,
                          decoration: const InputDecoration(
                              labelText: 'Valor a Pagar',
                              labelStyle: TextStyle(color: Colors.black)),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa el valor a pagar';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'El valor a pagar solo puede contener números';
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
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        crearOrdenProduccion();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Crear Orden', style: TextStyle(color: Colors.green)),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Future<List<dynamic>> fetchOrdenesProduccion() async {
    final response =
        await http.get(Uri.parse('https://backdeliflutter.onrender.com/api/ordenes-produccion/'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load ordenes de producción');
    }
  }

  Future<void> visualizarOrdenProduccion(String id) async {
    final orden =
        _ordenesProduccion.firstWhere((element) => element['_id'] == id);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text
          ('Detalles de la Orden de Producción',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black)),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre Cliente: ${orden['nombreCliente']}',
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.black)),
                Text('Teléfono: ${orden['telefono']}',
                    style: const TextStyle(fontSize: 14.0, color: Colors.black)),
                Text('Cédula: ${orden['cedula']}',
                    style: const TextStyle(fontSize: 14.0, color: Colors.black)),
                Text('Número de Orden de Pedido: ${orden['numeroOrdenPedido']}',
                    style: const TextStyle(fontSize: 14.0, color: Colors.black)),
                Text('Producto: ${orden['producto']}',
                    style: const TextStyle(fontSize: 14.0, color: Colors.black)),
                Text('Cantidad: ${orden['cantidadRequerida']}',
                    style: const TextStyle(fontSize: 14.0, color: Colors.black)),
                Text('Valor a Pagar: ${orden['valorAPagar']}',
                    style: const TextStyle(fontSize: 14.0, color: Colors.black)),
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

  Future<void> crearOrdenProduccion() async {
    final Map<String, dynamic> nuevaOrden = {
      'nombreCliente': _nombreClienteController.text,
      'telefono': _telefonoController.text,
      'cedula': _cedulaController.text,
      'numeroOrdenPedido': _numeroOrdenPedidoController.text,
      'producto': _productoController.text,
      'cantidadRequerida': int.parse(_cantidadController.text),
      'valorAPagar': double.parse(_valorAPagarController.text),
    };

    try {
      final response = await http.post(
        Uri.parse('https://backdeliflutter.onrender.com/api/ordenes-produccion/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(nuevaOrden),
      );

      if (response.statusCode == 201) {
        fetchOrdenesProduccion().then((ordenes) {
          setState(() {
            _ordenesProduccion = ordenes;
          });
        });
      } else {
        throw Exception('Failed to add orden de producción');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> editarOrdenProduccion(String id) async {
    final orden = _ordenesProduccion.firstWhere((element) => element['_id'] == id);
    _nombreClienteController.text = orden['nombreCliente'];
    _telefonoController.text = orden['telefono'];
    _cedulaController.text = orden['cedula'];
    _numeroOrdenPedidoController.text = orden['numeroOrdenPedido'];
    _productoController.text = orden['producto'];
    _cantidadController.text = orden['cantidadRequerida'].toString();
    _valorAPagarController.text = orden['valorAPagar'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Orden de Producción', style: TextStyle(color: Colors.black)),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nombreClienteController,
                    decoration: const InputDecoration(
                      labelText: 'Nombres y Apellidos del Cliente',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el nombre del cliente';
                      }
                      if (!RegExp(r'^[a-zA-ZáéíóúñÑÁÉÍÓÚüÜ ]+$').hasMatch(value)) {
                        return 'El nombre solo puede contener letras';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el número de teléfono';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'El número de teléfono solo puede contener números';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _cedulaController,
                    decoration: const InputDecoration(
                      labelText: 'Cédula',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el número de cédula';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'La cédula solo puede contener números';
                      }                    
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _numeroOrdenPedidoController,
                    decoration: const InputDecoration(
                      labelText: 'Número de Orden de Pedido',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el número de orden de pedido';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'La orden solo puede contener números';
                      }                      
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _productoController,
                    decoration: const InputDecoration(
                      labelText: 'Producto',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el nombre del producto';
                      }
                      if (!RegExp(r'^[a-zA-ZáéíóúñÑÁÉÍÓÚüÜ ]+$').hasMatch(value)) {
                        return 'El producto solo puede contener letras';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa la cantidad';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'La cantidad solo puede contener números';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _valorAPagarController,
                    decoration: const InputDecoration(
                      labelText: 'Valor a Pagar',
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el valor a pagar';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'El valor a pagar solo puede contener números';
                      }               
                      return null;
                    },
                    keyboardType: TextInputType.number,
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
                if (_formKey.currentState!.validate()) {
                  actualizarOrdenProduccion(id);
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

  Future<void> actualizarOrdenProduccion(String id) async {
    final Map<String, dynamic> datosActualizados = {
      'nombreCliente': _nombreClienteController.text,
      'telefono': _telefonoController.text,
      'cedula': _cedulaController.text,
      'numeroOrdenPedido': _numeroOrdenPedidoController.text,
      'producto': _productoController.text,
      'cantidadRequerida': int.parse(_cantidadController.text),
      'valorAPagar': double.parse(_valorAPagarController.text),
    };

    try {
      final response = await http.put(
        Uri.parse('https://backdeliflutter.onrender.com/api/ordenes-produccion/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datosActualizados),
      );

      if (response.statusCode == 200) {
        fetchOrdenesProduccion().then((ordenes) {
          setState(() {
            _ordenesProduccion = ordenes;
          });
        });
      } else {
        throw Exception('Failed to update orden de producción');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> eliminarOrdenProduccion(String id) async {
  final confirmacion = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Eliminar Orden de Producción',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.black)),
        content: const Text('¿Estás seguro de que deseas eliminar esta orden de producción?',
            style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              try {
                final response =
                    await http.delete(Uri.parse('https://backdeliflutter.onrender.com/api/ordenes-produccion/$id'));

                if (response.statusCode == 200) {
                  fetchOrdenesProduccion().then((ordenes) {
                    setState(() {
                      _ordenesProduccion = ordenes;
                    });
                  });
                } else {
                  throw Exception('Failed to delete orden de producción');
                }
              } catch (error) {
                print(error);
              }
              Navigator.of(context).pop(true);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.green)),
          ),
        ],
      );
    },
  );

  if (confirmacion != null && confirmacion) {

  }
}
}
