import 'package:aplicacion_ac/vista/Lista.dart';
import 'package:aplicacion_ac/vista/genera_inicio.dart';
import 'package:aplicacion_ac/modelo/base_datos.dart';
import 'package:aplicacion_ac/modelo/Tienda.dart';
import 'package:flutter/material.dart';

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

  // Generación de tiendas
  await Tienda.generarTiendas();

  // Carga de listas favoritas
  Lista.cargarListasFavoritas = await BD.cargaProductosListasFavoritas();

  // Carga de productos favoritos
  Lista.productos_favoritos = await BD.devuelveProductosFavoritos();

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

/*
/// Clase StatefulWidget que representa la pantalla de inicio.
/// 
/// Esta clase es responsable de crear el estado mutable asociado a la pantalla de
/// inicio. Extiende la clase StatefulWidget y proporciona la implementación del
/// método `createState()` que devuelve una instancia de la clase _Pagina1State,
/// que es la clase de estado asociada a esta pantalla.
*/
class inicio extends StatefulWidget {
  const inicio({Key? key}) : super(key: key);

  @override
  State<inicio> createState() => Pagina1State();
}
