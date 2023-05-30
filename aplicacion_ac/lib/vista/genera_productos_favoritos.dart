import 'package:aplicacion_ac/modelo/base_datos.dart';
import 'package:aplicacion_ac/vista/productos_favoritos.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Item.dart';
import 'menugeneral.dart';
import 'Lista.dart';


/// Estado de la página 4, que extiende [State] y utiliza [SingleTickerProviderStateMixin].
class Pagina4 extends State<productos_favoritos> with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  /// Libera los recursos del controlador de animación al destruir el estado.
  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  /// Comprueba si el panel lateral está completamente abierto.
  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  /// Comprueba si el panel lateral se está abriendo.
  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  /// Comprueba si el panel lateral está completamente cerrado.
  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  /// Alterna la apertura y cierre del panel lateral.
  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  /// Genera y devuelve el widget principal de la página.
  ///
  /// Devuelve un widget [Scaffold] que representa la estructura básica de la página.
  /// Contiene una barra de aplicación [AppBar], un contenido principal [_buildContent],
  /// y un panel lateral [_buildDrawer].
  @override
  Widget build(BuildContext context) {
    // Ordenar los productos ascendentemente por los precios

    // Coger los Productos de la lista atributo de la clase Lista
    List<Widget> listaListas = crearListas(Lista.getFavoritos().toList());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 69, 190, 140),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(context, listaListas),
          _buildDrawer(),
        ],
      ),
    );
  }

  /// Construye la barra de aplicación (AppBar) de la página.
  ///
  /// Devuelve un widget [PreferredSizeWidget] que representa la barra de aplicación.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const Image(
        image: AssetImage('assets/logo4.png'),
        filterQuality: FilterQuality.high,
      ),
      title: const Text(
        'Productos favoritos',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: const Color.fromARGB(0, 44, 202, 246),
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

  /// Construye el contenido principal de la página.
  ///
  /// El parámetro [conte] es el contexto de la aplicación.
  /// El parámetro [productos] es una lista de widgets que representan los productos.
  ///
  /// Devuelve un widget [SizedBox] que contiene el contenido principal de la página.
  Widget _buildContent(conte, productos) {
    return SizedBox(
      child: Container(
          margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 20.0),
          //color: Color(0xFFFAF482),
          alignment: AlignmentDirectional.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 50.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 220, 230, 247),
                        width: 3.0),
                  ),
                  child: const Expanded(
                    child: Text(
                      "Productos favoritos",
                      style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 30),
                    controller: ScrollController(initialScrollOffset: 2),
                    itemCount: productos.length,
                    itemBuilder: (BuildContext context, int index) =>
                        productos[index],
                  ),
                )
              ])),
    );
  }

  /// Construye un widget que representa un producto.
  ///
  /// El parámetro [p] es el objeto [Producto] que se va a representar.
  ///
  /// Devuelve un widget [Container] que contiene la representación visual del producto.
  Widget _construye_producto(Producto p) {
    // esto es el objeto por cada producto favorito...
    return Container(
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.only(bottom: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromRGBO(239, 237, 254, 0.898),
          border: Border.all(
              color: const Color.fromARGB(255, 220, 230, 247), width: 3.0),
        ),
        child: SizedBox(
            width: 250,
            height: 140,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Image.network(
                p.hrefProducto,
                height: MediaQuery.of(context).size.height,
                width: 100.0,
                alignment: Alignment.center,
                scale: 1,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stacktrace) {
                  return Image.asset(
                    "assets/image_producto_no_encontrada.jpg",
                    height: MediaQuery.of(context).size.height,
                    width: 70.0,
                    alignment: Alignment.center,
                  );
                },
              ),
              Container(
                decoration: const BoxDecoration(
                    //border: Border.all(color: Colors.blueAccent)
                    color: Color.fromRGBO(255, 255, 255, 0.5)),
                width: MediaQuery.of(context).size.width / 2.2,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(3.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 9,
                        child: Center(
                          child: Text(
                            p.nombreProducto.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ]),
              ),
            ])));
  }

  /// Genera un widget [Dismissible] que permite arrastrar y eliminar un widget dado.
  ///
  /// El parámetro [w] es el widget que se puede arrastrar y eliminar.
  /// El parámetro [pos] es la posición del elemento en la lista.
  ///
  /// Devuelve un widget [Dismissible] configurado con la dirección de desplazamiento,
  /// el fondo de eliminación, la clave, el controlador de deslizamiento, la acción de eliminación
  /// y el widget hijo.
  Widget _generaDraggable(Widget w, int pos, Producto prod) {
    const snackBar = SnackBar(
        duration: Duration(seconds: 1),
        content: Text("El producto ha sido eliminado!"));

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
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
        setState(() {
          Lista.quitarFavorito(pos);
          BD.deleteProductoFavorito(prod);
        });
      },
      child: SizedBox(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: w,
        ),
      ),
    );
  }

  /// Metodo que genera una lista de widgets de listas favoritas (guardadas)
  List<Widget> crearListas(List<Producto> productos) {
    final List<Widget> listaObj = [];

    // Por cada objeto Producto encontrado se monta un contenedor y se añade a
    // la lista de widgets que va dentro de un LIST VIEW
    int pos = 0;
    for (Producto pro in productos) {
      final objetoTemporal = _construye_producto(pro);
      // y despues lo convertimos a un objeto draggable
      final objetoFinal = _generaDraggable(objetoTemporal, pos, pro);
      listaObj.add(objetoFinal);

      listaObj.add(const SizedBox(height: 20.0));
      pos += 1;
    }

    return listaObj;
  }

  /// METODO QUE DEVUELVE UN BUILDER ANIMADO
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