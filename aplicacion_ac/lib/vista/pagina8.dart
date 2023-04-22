import 'package:aplicacion_ac/vista/Producto.dart';
import 'package:aplicacion_ac/vista/pagina7.dart';
import 'package:flutter/material.dart';
import 'Lista.dart';
import 'Lista.dart';
import 'pagina1.dart';
import 'menugeneral.dart';




Producto prod1 = new Producto('pan integral', 2.40, 'assets/pan_integral.jpg');
Producto prod2 =
    new Producto('leche sin lactosa', 1.20, 'assets/leche_sin_lactosa.png');
Producto prod3 = new Producto('cerveza', 0.70, 'assets/mahou.jpg');
// Lista contenedora de productos
Set<Producto> _productos = Set<Producto>()..addAll([prod1, prod2, prod3]);



// CLASE PRINCIPAL CREADORA DE 'HOME'
class Pagina8 extends StatefulWidget {
  
final Set<Producto> productos;

  Pagina8( {
    super.key,  required this.productos
  });
  // creamos la ista de listas a través del método

  @override
  State<Pagina8> createState() => _Pagina8();
  
}

/////////////////////////////////////1 ª PARTE//////////////////////////////////////////////
// CLASE ANIMADO
class _Pagina8 extends State<Pagina8> with SingleTickerProviderStateMixin {
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
///////////////////////////////////////////////generamos la lista de elementos
  
    //Set<Producto> productos = ModalRoute.of(context)!.settings.arguments as Set<Producto>;
Set<Producto> productos = ModalRoute.of(context)!.settings.arguments as Set<Producto>;
  List<Widget> listaListas = crearListas(productos);

    

    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 239, 188, 1),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(context, listaListas),
          _buildDrawer(),
        ],
      ),
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////
////////////////////// método de creación de appBar personalizado/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const Icon(
        Icons.shopping_basket_sharp,
        color: Color.fromARGB(255, 3, 122, 44),
      ),
      title: const Text(
        'Cesta productos',
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

  /////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////AQUI AÑADIMOS EL CONTENIDO DE LA PAGINA (BODY)/////////////
  /////////////////////// METODO QUE DEVUELVE UN SIZED BOX CON SU CONTENIDO////////////
  /////////////////////////////////////////////////////////////////////////////////////

  Widget _buildContent(conte, productos) {
    // Indicador si se ha arrastrado y soltado algo
    bool pasadoOnaccept = false;

  
   
    return Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
      //color: Color(0xFFFAF482),
      alignment: AlignmentDirectional.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: ListView(
              //shrinkWrap: true,
              children: productos,
            )),
            const SizedBox(
              height: 20,
            ),
          ]),
    );
  }
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////

  /// Metodo que genera una lista de widgets de listas favoritas (guardadas)
  List<Widget> crearListas(Set<Producto> productos) {

    
    """
    Lista lis1 = Lista('Lista semanal', 'Lista de compras que se realizan todas las semanas.');
    Lista lis2 = Lista('Lista productos igiéne','Productos necesarios para la igiene personal.');
    Lista lis3 = Lista('Lista productos cosmeticos','Productos necesarios para la imágen personal.');

    List<Lista> ejemplos = [];
    ejemplos.add(lis1);
    ejemplos.add(lis2);
    ejemplos.add(lis3);
    """;

    final List<Widget> listaObj = [];

    // Por cada objeto Producto encontrado se monta un contenedor y se añade a
    // la lista de widgets que va dentro de un LIST VIEW

    for (Producto pro in productos) {
      final objetoTemporal = _montar_contenedor(pro);
      // y despues lo convertimos a un objeto draggable
      final objetoFinal = _generaDraggable(objetoTemporal);
      listaObj.add(objetoFinal);

      listaObj.add(SizedBox(height: 20.0));
    }

    return listaObj;
  }

  // Metodo de conversión de los elementos de ListView a Draggable
  Widget _generaDraggable(Widget w) {
    const snackBar = SnackBar(
      duration: Duration(seconds: 2),
      
      content: Text("El producto ha sido eliminado!"));

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(left: 20.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40.0,
        ),
      ),
      key: ValueKey(w),
      onDismissed: (_) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: SizedBox(
        height: 150.0,
        width: MediaQuery.of(context).size.width,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: w,
        ),
      ),
    );
  }

  void handleDragEnd(BuildContext context, List lista, int index) {
    setState(() {
      lista.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Elemento eliminado")),
    );
  }

  // Contenedor que se muestra detrás del que se arrastra
  Widget _monta_contenedor_vacio() {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: const Color.fromARGB(255, 220, 230, 247), width: 3.0),
            borderRadius: BorderRadius.circular(12),
            color: const Color.fromARGB(226, 188, 179, 241)),
        child: const SizedBox(
          width: 300,
          height: 150,
        ));
  }

  // Metodo constructor de contenedor de lista (ListTile)
  Widget _montar_contenedor(Producto p) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 220, 230, 247), width: 40.0),
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(239, 237, 254, 0.898)),
      child: SizedBox(
        width: 300,
        height: 150,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: -4),
          minLeadingWidth: 100.0,
          dense: false,
          onTap: () => () {},
          leading: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 70.0,
                minHeight: 100.0,
                maxWidth: 300.0,
                maxHeight: 200.0),
            child: Image.asset(
              p.imagenProducto,
              width: 80.0,
              height: 100,
              alignment: Alignment.centerLeft,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(p.nombreProducto),
          subtitle: Text(p.precio.toString()),
        ),
      ),
    );
  }

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
