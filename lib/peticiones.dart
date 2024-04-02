import 'dart:convert';
import 'package:http/http.dart' as http;

class Peticiones {
  static const String baseUrl = 'https://backdeliflutter.onrender.com/api';

  static Future<void> _manejarErrores(http.Response response) async {
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error en la solicitud: ${response.statusCode}');
    }
  }

  // CRUD de Comprobantes de Venta
  static Future<List<dynamic>> obtenerComprobantesVenta() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/comprobantes-venta'));
      _manejarErrores(response);
      return json.decode(response.body);
    } catch (e) {
      print('Error al obtener los comprobantes de venta: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> obtenerComprobanteVentaPorNumeroPedido(String numeroPedido) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/comprobantes-venta/$numeroPedido'));
      _manejarErrores(response);
      return json.decode(response.body);
    } catch (e) {
      print('Error al obtener el comprobante de venta por número de pedido: $e');
      rethrow;
    }
  }

  // CRUD de Insumos
  static Future<void> crearInsumo(Map<String, dynamic> insumo) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/insumos'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(insumo),
      );
      _manejarErrores(response);
    } catch (e) {
      print('Error al crear el insumo: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> obtenerInsumos() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/insumos'));
      _manejarErrores(response);
      return json.decode(response.body);
    } catch (e) {
      print('Error al obtener los insumos: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> obtenerInsumoPorId(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/insumos/$id'));
      _manejarErrores(response);
      return json.decode(response.body);
    } catch (e) {
      print('Error al obtener el insumo por ID: $e');
      rethrow;
    }
  }

  static Future<void> actualizarInsumoPorId(String id, Map<String, dynamic> datos) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/insumos/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datos),
      );
      _manejarErrores(response);
    } catch (e) {
      print('Error al actualizar el insumo: $e');
      rethrow;
    }
  }

  static Future<void> eliminarInsumoPorId(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/insumos/$id'));
      _manejarErrores(response);
    } catch (e) {
      print('Error al eliminar el insumo: $e');
      rethrow;
    }
  }

  // CRUD de Ordenes de Producción
  static Future<void> crearOrdenProduccion(Map<String, dynamic> ordenProduccion) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ordenes-produccion'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(ordenProduccion),
      );
      _manejarErrores(response);
    } catch (e) {
      print('Error al crear la orden de producción: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> obtenerOrdenesProduccion() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ordenes-produccion'));
      _manejarErrores(response);
      return json.decode(response.body);
    } catch (e) {
      print('Error al obtener las ordenes de producción: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> obtenerOrdenProduccionPorId(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/ordenes-produccion/$id'));
      _manejarErrores(response);
      return json.decode(response.body);
    } catch (e) {
      print('Error al obtener la orden de producción por ID: $e');
      rethrow;
    }
  }

  // CRUD de Productos Terminados
  static Future<void> crearProductoTerminado(Map<String, dynamic> productoTerminado) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/productos-terminados'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(productoTerminado),
      );
      _manejarErrores(response);
    } catch (e) {
      print('Error al crear el producto terminado: $e');
      rethrow;
    }
  }

  static Future<List<dynamic>> obtenerProductosTerminados() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/productos-terminados'));
      _manejarErrores(response);
      return json.decode(response.body);
    } catch (e) {
      print('Error al obtener los productos terminados: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> obtenerProductoTerminadoPorId(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/productos-terminados/$id'));
      _manejarErrores(response);
      return json.decode(response.body);
    } catch (e) {
      print('Error al obtener el producto terminado por ID: $e');
      rethrow;
    }
  }

  static Future<void> actualizarProductoTerminadoPorId(String id, Map<String, dynamic> datos) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/productos-terminados/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(datos),
      );
      _manejarErrores(response);
    } catch (e) {
      print('Error al actualizar el producto terminado: $e');
      rethrow;
    }
  }

  static Future<void> eliminarProductoTerminadoPorId(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/productos-terminados/$id'));
      _manejarErrores(response);
    } catch (e) {
      print('Error al eliminar el producto terminado: $e');
      rethrow;
    }
  }
}
