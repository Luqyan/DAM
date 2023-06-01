// Clase separada que contiene los métodos de Pagina11
import 'package:flutter/material.dart';

class EstadoUtils extends ChangeNotifier implements Listenable {
  late AnimationController _drawerSlideController;

  /// Inicializa el controlador de animación del drawer.
  void iniciaControladorDeslizante(TickerProvider vsync) {
    _drawerSlideController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 150),
    );
  }


  double get valorControlador => _drawerSlideController.value;


  /// Libera los recursos utilizados por la clase antes de ser destruida.
  @override
  void dispose() {
    super.dispose();
    _drawerSlideController.dispose();
  }

  /// Verifica si el drawer está abierto.
  bool isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  /// Verifica si el drawer está abriendo.
  bool isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  /// Verifica si el drawer está cerrado.
  bool isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  /// Alterna la apertura/cierre del drawer.
  void toggleDrawer() {
    if (isDrawerOpen() || isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }
}