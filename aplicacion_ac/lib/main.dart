import 'dart:math';

import 'package:aplicacion_ac/modelo/TiendaJson.dart';
import 'package:aplicacion_ac/vista/Lista.dart';
import 'package:flutter/material.dart';
import 'package:aplicacion_ac/vista/pagina1.dart';
import 'controlador/GestionDatosTablas.dart';
import 'modelo/Tienda.dart';
import 'vista/menugeneral.dart';
import 'package:aplicacion_ac/modelo/base_datos.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BD.openBD();
  // getDatabasesPath().then((value) => print(value));
  //await BD.borrarTabla("ahorramas");
  print("Hola");
  //  print(await BD.consultaPrimerProducto("ahorramas", "Ternera a la jardinera Carretilla 300g"));
  print("adioos");
  
  var p = await BD.consultaPrimerProducto("ahorramas", "Ternera a la jardinera Carretilla 300g");
  print(p.runtimeType.toString());
  print(p.toString());
  



  // Recoger nombres tablas desde la base de datos
  List<Tienda> tiendas = await GestionDatos.devuelveTiendas();
  tiendas.forEach((element) {Tienda.aniadir_lista_resultado(element); print("Nombre tabla: ${element.nombre}");});






  final ThemeData theme = ThemeData();
  runApp(
    
    MaterialApp(
       theme: theme.copyWith(
    colorScheme: theme.colorScheme.copyWith(secondary: Colors.greenAccent),
  ),

      home: MiAplicacion(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

// CLASE PRINCIPAL CREADORA DE 'HOME'
class MiAplicacion extends StatefulWidget {
  const MiAplicacion({
    super.key,
  });

  @override
  State<MiAplicacion> createState() => _MiAplicacion();
}

/////////////////////////////////////1 ª PARTE//////////////////////////////////////////////
// CLASE ANIMADO
class _MiAplicacion extends State<MiAplicacion>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  // metodos controladores de estados
  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  // metodo creacion Scaffold
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 239, 188, 1),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(context),
          _buildDrawer(),
        ],
      ),
    );
  }

  // hay que acceder
//////////////////////////////////////////////////////////////////////////////////////////
  // método de creación de appBar personalizado
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const Image(image: 
        AssetImage('assets/logo4.png'),
        filterQuality: FilterQuality.high,
      ),
      
      
      title: const Text(
        'AveriCarro',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Color.fromARGB(0, 44, 202, 246),
      elevation: 3,
      automaticallyImplyLeading: false,
      actions: [
        AnimatedBuilder(
          animation: _drawerSlideController,
          builder: (context, child) {
            return IconButton(
              onPressed: _toggleDrawer,
              icon: _isDrawerOpen() || _isDrawerOpening()
                  ? const Icon(
                      Icons.clear,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
            );
          },
        ),
      ],
    );
  }

  ///////////////////////////////////////////////////////////////////////////////////
  ////////////////// AQUI AÑADIMOS EL CONTENIDO DE LA PAGINA (BODY)//////////////////
  //////////////////METODO QUE DEVUELVE UN SIZED BOX CON SUS VALORES/////////////////
  ///////////////////////////////////////////////////////////////////////////////////

  Widget _buildContent(conte) {
    // Put page content here.

    return SizedBox(
      child: Container(
        margin: EdgeInsets.only(left: 50.0, right: 50.0, top: 200.0),
        alignment: AlignmentDirectional.center,
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width / 1.2,
       
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Ink.image(
              image: const AssetImage('assets/logo4.png'),
              fit: BoxFit.cover,
              
            ),
            onTap: () => {
                  Navigator.push(conte,
                      MaterialPageRoute(builder: (conte) => (Pagina1()))),
                }),
      ),
    );
  }
  /////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////

  // METODO QUE DEVUELVE UN BUILDER ANIMADO
  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1.0 - _drawerSlideController.value, 0.0),
          child: _isDrawerClosed() ? const SizedBox() : const Menu(),
        );
      },
    );
  }
}
