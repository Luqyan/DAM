import 'package:flutter/material.dart';
import '../main.dart';
import 'buscador.dart';
import 'dart:async';

class Pagina1State extends State<inicio> with TickerProviderStateMixin {
  /// Clase de estado asociada a la pantalla de inicio.
  ///
  /// Esta clase de estado contiene la lógica y los componentes que se utilizan en
  /// la pantalla de inicio. Implementa la clase State y también utiliza el mixin
  /// TickerProviderStateMixin para proporcionar un controlador de animación a la
  /// animación utilizada en la pantalla.
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(_animationController);
    _animationController.forward();
    Timer(const Duration(seconds: 4), () {
      setState(() {
        _animationController.dispose();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /*
  /// Método que construye el contenido principal de la pantalla.
  ///
  /// Retorna un Widget que contiene un Container con un margen y alineación
  /// específicos. Dentro del Container se encuentra una Columna que contiene dos
  /// ElevatedButton. El primer botón muestra el texto "Nueva Lista" y tiene un
  /// estilo personalizado. Al hacer clic en este botón, se navegará a la página
  /// Pagina7. El segundo botón muestra un mensaje y también tiene un estilo
  /// personalizado. Al hacer clic en este botón, se navegará a la página Pagina2.
  ///
  /// El contenido se ajusta horizontalmente al inicio y se alinea verticalmente
  /// al centro.
  ///
  /// Retorna el Widget construido.
  /// */
  Widget _buildContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 100.0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 170, 90),
              minimumSize: const Size(250, 200),
            ),
            child: const Text(
              "Nueva Lista",
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const buscador()),
              );
            },
          ),
          const SizedBox(height: 120),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: const Color.fromARGB(255, 201, 215, 202),
          //     minimumSize: const Size(300, 80),
          //   ),
          //   child: const Text(
          //     "Mensaje: Regístrate para elegir tus propias listas y obtener más funcionalidades",
          //     style: TextStyle(
          //       fontSize: 12.0,
          //       fontWeight: FontWeight.w600,
          //       color: Colors.black87,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => const Pagina2()),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  /// Método que construye la interfaz de usuario de la pantalla.
  ///
  /// Utiliza un Scaffold como estructura base y configura el fondo, la barra de
  /// aplicación y el cuerpo de la pantalla. El cuerpo consiste en un Stack con
  /// una animación y contenido adicional.
  ///
  /// Retorna el Scaffold construido.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(254, 239, 188, 1),
      appBar: AppBar(
        leading: Image.asset(
          'assets/logo4.png',
          filterQuality: FilterQuality.high,
        ),
        title: const Text(
          'AveriCarro',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color.fromARGB(0, 44, 81, 246),
        elevation: 3,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Opacity(
                opacity: _animation.value,
                child: _animation.value == 1
                    ? const SizedBox.shrink()
                    : Center(child: child),
              );
            },
            child: Image.asset('assets/logo4.png'),
          ),
          if (_animation.isCompleted) _buildContent(context),
        ],
      ),
    );
  }
}
