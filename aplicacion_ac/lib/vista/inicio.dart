import 'package:aplicacion_ac/modelo/base_datos.dart';
import 'package:aplicacion_ac/vista/buscador.dart';
import 'package:aplicacion_ac/modelo/Tienda.dart';
import 'package:flutter/material.dart';
import 'pagina2.dart';
import 'dart:async';

/// Función principal del programa.
/// 
/// Esta función es el punto de entrada del programa y es ejecutada al iniciar
/// la aplicación. Es asíncrona y no retorna ningún valor. Realiza las siguientes
/// tareas:
/// 
/// - Asegura la inicialización de FlutterBinding para la aplicación.
/// - Inicializa la base de datos llamando al método [openBD()] de la clase BD.
/// - Genera las tiendas llamando al método [generarTiendas()] de la clase Tienda.
/// - Configura el tema de la aplicación.
/// - Crea una instancia de MaterialApp con el tema configurado y establece la
///   pantalla de inicio como la clase [inicio()].
/// - Ejecuta la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicialización de la base de datos
  await BD.openBD();

  //Generación de tiendas
  await Tienda.generarTiendas();

  final ThemeData theme = ThemeData();
  runApp(
    MaterialApp(
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.greenAccent),
      ),
      home: const inicio(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

/// Clase StatefulWidget que representa la pantalla de inicio.
/// 
/// Esta clase es responsable de crear el estado mutable asociado a la pantalla de
/// inicio. Extiende la clase StatefulWidget y proporciona la implementación del
/// método `createState()` que devuelve una instancia de la clase _Pagina1State,
/// que es la clase de estado asociada a esta pantalla.

class inicio extends StatefulWidget {
  const inicio({Key? key}) : super(key: key);

  @override
  State<inicio> createState() => _Pagina1State();
}
/// Clase de estado asociada a la pantalla de inicio.
/// 
/// Esta clase de estado contiene la lógica y los componentes que se utilizan en
/// la pantalla de inicio. Implementa la clase State y también utiliza el mixin
/// TickerProviderStateMixin para proporcionar un controlador de animación a la
/// animación utilizada en la pantalla.

class _Pagina1State extends State<inicio> with TickerProviderStateMixin {
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
                MaterialPageRoute(builder: (context) => const Pagina7()),
              );
            },
          ),
          const SizedBox(height: 120),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 201, 215, 202),
              minimumSize: const Size(300, 80),
            ),
            child: const Text(
              "Mensaje: Regístrate para elegir tus propias listas y obtener más funcionalidades",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Pagina2()),
              );
            },
          ),
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
                    ? SizedBox.shrink()
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
