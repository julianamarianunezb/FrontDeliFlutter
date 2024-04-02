import 'package:flutter/material.dart';

import 'login_screen.dart'; 
import 'menu_compras_screen.dart';
import 'ordenes_produccion_screen.dart';

class MenuPrincipalScreen extends StatelessWidget {
  const MenuPrincipalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Menú Principal',
          style: TextStyle(
            color: Colors.black87, 
            fontStyle: FontStyle.italic, 
          ),
          textAlign: TextAlign.center, 
        ),
        backgroundColor: const Color.fromARGB(255, 237, 226, 228), 
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.black87), 
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
                  MaterialPageRoute(builder: (context) => const OrdenesProduccionScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 189, 231, 241), 
                minimumSize: const Size(300, 70), 
                elevation: 5, 
              ),
              icon: const Icon(Icons.shopping_cart, color: Color.fromARGB(255, 0, 0, 0)), 
              label: const Text(
                'Módulo de Ventas',
                style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0), fontStyle: FontStyle.italic), 
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MenuModuloCompras()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 233, 171, 203), 
                minimumSize: const Size(300, 70), 
                elevation: 5, 
              ),
              icon: const Icon(Icons.shopping_bag, color: Color.fromARGB(255, 0, 0, 0)), 
              label: const Text(
                'Módulo de Compras',
                style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 0, 0, 0), fontStyle: FontStyle.italic), 
              ),
            ),
          ],
        ),
      ),
    );
  }
}
