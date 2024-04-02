import 'package:flutter/material.dart';

import 'insumos_screen.dart';
import 'login_screen.dart';
import 'producto_terminado_screen.dart'; 

class MenuModuloCompras extends StatelessWidget {
  const MenuModuloCompras({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Módulo de Compras',
          style: TextStyle(
            color: Colors.black87, 
            fontStyle: FontStyle.italic, 
          ),
          textAlign: TextAlign.center, 
        ),
        backgroundColor: const Color.fromARGB(255, 237, 226, 228), 
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
                child: Text('Cerrar sesión'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InsumosScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 189, 231, 241), 
                minimumSize: const Size(300, 70),
                elevation: 5, 
              ),
              icon: const Icon(Icons.inventory, color: Colors.black), 
              label: const Text(
                'Insumos',
                style: TextStyle(fontSize: 20, color: Colors.black, fontStyle: FontStyle.italic), 
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductoTerminadoScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 233, 171, 203), 
                minimumSize: const Size(300, 70), 
                elevation: 5, 
              ),
              icon: const Icon(Icons.shopping_bag, color: Colors.black), 
              label: const Text(
                'Productos terminados',
                style: TextStyle(fontSize: 20, color: Colors.black, fontStyle: FontStyle.italic), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
