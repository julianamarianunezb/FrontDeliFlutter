import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_screen.dart';

class InsumosScreen extends StatefulWidget {
  const InsumosScreen({Key? key}) : super(key: key);

  @override
  State<InsumosScreen> createState() => _InsumosScreenState();
}

class _InsumosScreenState extends State<InsumosScreen> {
  List<dynamic> _insumos = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();
  final TextEditingController _unidadMedidaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchInsumos().then((insumos) {
      setState(() {
        _insumos = insumos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Insumos',
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'cerrar_sesion',
                child: Text('Cerrar sesión', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _insumos.length,
        itemBuilder: (context, index) {
          final insumo = _insumos[index];
          final id = insumo['_id'].toString();
          return Card(
            margin: const EdgeInsets.all(8.0),
            color: const Color.fromARGB(255, 189, 231, 241),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Text(insumo['nombre'], style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0))),
              subtitle: Text('Cantidad: ${insumo['cantidad']}, Unidad de Medida: ${insumo['unidadMedida']}', style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color.fromARGB(235, 0, 0, 0)),
                    onPressed: () {
                      editarInsumo(id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () {
                      mostrarConfirmacionEliminar(id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.visibility, color: Color.fromARGB(255, 0, 0, 0)),
                    onPressed: () {
                      verDetallesInsumo(insumo);
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
          _unidadMedidaController.clear();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Agregar Nuevo Insumo', style: TextStyle(color: Color.fromARGB(255, 99, 4, 77))),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nombreController,
                          decoration: const InputDecoration(labelText: 'Nombre', labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa el nombre del insumo';
                            }
                            if (!RegExp(r'^[a-zA-ZáéíóúñÑÁÉÍÓÚüÜ ]+$').hasMatch(value)) {
                              return 'El nombre solo puede contener letras';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _cantidadController,
                          decoration: const InputDecoration(labelText: 'Cantidad', labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa la cantidad';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Por favor, ingresa una cantidad válida';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                        TextFormField(
                          controller: _unidadMedidaController,
                          decoration: const InputDecoration(labelText: 'Unidad de Medida', labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                          style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese la cantidad unitaria y su unidad de medida';
                            }
                            if (!RegExp(r'^[0-9]+(\.[0-9]+)?\s*(mg|g|kg|ml|l)$', caseSensitive: false).hasMatch(value)) {
                              return 'Ingrese la cantidad unitaria y su unidad de medida válida (mg, g, kg, ml, l)';
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
                    child: const Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 193, 97, 97))),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        agregarInsumo();
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Agregar Insumo', style: TextStyle(color: Color.fromARGB(255, 18, 204, 46))),
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

  Future<List<dynamic>> fetchInsumos() async {
    final response = await http.get(Uri.parse('https://backendflutterdeli-1.onrender.com/api/insumos/'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load insumos');
    }
  }

  Future<void> agregarInsumo() async {
    final Map<String, dynamic> nuevoInsumo = {
      'nombre': _nombreController.text,
      'cantidad': int.parse(_cantidadController.text),
      'unidadMedida': _unidadMedidaController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('https://backendflutterdeli-1.onrender.com/api/insumos/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(nuevoInsumo),
      );

      if (response.statusCode == 201) {
        _nombreController.clear();
        _cantidadController.clear();
        _unidadMedidaController.clear();

        fetchInsumos().then((insumos) {
          setState(() {
            _insumos = insumos;
          });
        });
      } else {
        throw Exception('Failed to add insumo');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> editarInsumo(String id) async {
    final insumo = _insumos.firstWhere((element) => element['_id'] == id);
    _nombreController.text = '';
    _cantidadController.text = insumo['cantidad'].toString();
    _unidadMedidaController.text = insumo['unidadMedida'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Insumo', style: TextStyle(color: Color.fromARGB(255, 51, 5, 37))),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(labelText: 'Nombre', labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa el nombre del insumo';
                      }
                      if (!RegExp(r'^[a-zA-ZáéíóúñÑÁÉÍÓÚüÜ ]+$').hasMatch(value)) {
                        return 'El nombre solo puede contener letras';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(labelText: 'Cantidad', labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingresa la cantidad';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Por favor, ingresa una cantidad válida';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    controller: _unidadMedidaController,
                    decoration: const InputDecoration(labelText: 'Unidad de Medida', labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, ingrese la cantidad unitaria y su unidad de medida';
                      }
                      if (!RegExp(r'^[0-9]+(\.[0-9]+)?\s*(mg|g|kg|ml|l)$', caseSensitive: false).hasMatch(value)) {
                        return 'Ingrese una cantidad unitaria y su unidad de medida válida (mg, g, kg, ml, l)';
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
              child: const Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 99, 9, 9))),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  actualizarInsumo(id);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar Cambios', style: TextStyle(color: Color.fromARGB(255, 6, 140, 17))),
            ),
          ],
        );
      },
    );
  }

  Future<void> actualizarInsumo(String id) async {
    final Map<String, dynamic> datosActualizados = {
      'nombre': _nombreController.text,
      'cantidad': int.parse(_cantidadController.text),
      'unidadMedida': _unidadMedidaController.text,
    };

    try {
      final response = await http.put(
        Uri.parse('https://backendflutterdeli-1.onrender.com/api/insumos/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datosActualizados),
      );

      if (response.statusCode == 200) {
        _nombreController.clear();
        _cantidadController.clear();
        _unidadMedidaController.clear();

        fetchInsumos().then((insumos) {
          setState(() {
            _insumos = insumos;
          });
        });
      } else {
        throw Exception('Failed to update insumo');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> mostrarConfirmacionEliminar(String id) async {
    final confirmacion = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Insumo', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          content: const Text('¿Estás seguro de que deseas eliminar este insumo?', style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar', style: TextStyle(color: Color.fromARGB(255, 8, 102, 100))),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final response = await http.delete(
                    Uri.parse('https://backendflutterdeli-1.onrender.com/api/insumos/$id'),
                  );

                  

                  if (response.statusCode == 200) {
                    fetchInsumos().then((insumos) {
                      setState(() {
                        _insumos = insumos;
                      });
                    });
                  } else {
                    throw Exception('Failed to delete insumo');
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

    if (confirmacion != null && confirmacion) {}
  }

  void verDetallesInsumo(dynamic insumo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles del Insumo', style: TextStyle(color: Color.fromARGB(255, 51, 5, 37))),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nombre: ${insumo['nombre']}', style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                Text('Cantidad: ${insumo['cantidad']}', style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                Text('Unidad de Medida: ${insumo['unidadMedida']}', style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar', style: TextStyle(color: Color.fromARGB(255, 99, 9, 9))),
            ),
          ],
        );
      },
    );
  }
}
