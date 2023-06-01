import 'package:aplicacion_ac/modelo/base_datos.dart';
import 'package:flutter/material.dart';
import 'listas_favoritas.dart';
import 'menugeneral.dart';
import 'Lista.dart';

/// Clase privada que extiende [State] y utiliza [SingleTickerProviderStateMixin]
/// para manejar la animación del cajón (drawer).
class Pagina3 extends State<listas_favoritas>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();
// Inicialización del controlador de animación del drawer.
    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  /// Libera los recursos utilizados por la clase antes de ser destruida.

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  /// Devuelve verdadero si el cajón está completamente abierto.

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  /// Devuelve verdadero si el cajón se está abriendo.

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  /// Devuelve verdadero si el cajón está completamente cerrado.

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  /// Alterna la apertura y cierre del cajón.

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  /// Anulación del método [build] de la clase [StatefulWidget].
  /// Construye la interfaz de usuario de la página.
  /// Recibe el [context] como parámetro.
  @override
  Widget build(BuildContext context) {
    List<Widget> listaListas = crearListas();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(254, 239, 188, 1),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(context, listaListas),
          _buildDrawer(),
        ],
      ),
    );
  }

  /// Método que construye la barra de la aplicación.
  /// Retorna un [AppBar] como una instancia de [PreferredSizeWidget].
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const Icon(
        Icons.shopping_basket_sharp,
        color: Color.fromARGB(255, 3, 122, 44),
      ),
      title: const Text(
        'Listas favoritas',
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

  /// Método que construye el contenido principal de la página.
  /// Recibe como parámetros el contexto [conte] y una lista de [listaListas].
  Widget _buildContent(conte, listaListas) {
    // Indicador si se ha arrastrado y soltado algo

    List<Widget> lista = List.from(listaListas);

    return Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
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
              children: lista,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

  /// Metodo que genera una lista de widgets de listas favoritas (guardadas)
  List<Widget> crearListas() {
    final List<Widget> listaObj = [];

    // Por cada objeto lista encontrado se monta un contenedor y se añade a
    // la lista de widgets que va dentro de un LIST VIEW
    for (Lista li in Lista.listas) {
      final objetoTemporal = _montar_contenedor(li);
      // y después lo convertimos a un objeto draggable
      final objetoFinal = _generaDraggable(objetoTemporal, li.nombreLista);
      listaObj.add(objetoFinal);

      listaObj.add(const SizedBox(height: 20.0));
    }

    return listaObj;
  }

  /// Función que genera un Widget arrastrable y deslizable para eliminar una lista.
  /// Recibe como parámetros el Widget a mostrar y el nombre de la lista.
  Widget _generaDraggable(Widget w, String nombreLista) {
    const snackBar = SnackBar(content: Text("La lista ha sido eliminada!"));

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(left: 20.0),
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white, size: 40.0),
      ),
      key: ValueKey(w),
      onDismissed: (_) {
        Lista.borrarListaPorNombre(nombreLista);
        BD.deleteListaFavorita(nombreLista);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  /// Función que retorna un Widget de contenedor personalizado para una lista.
  /// Recibe como parámetro una instancia de la clase Lista.
  Widget _montar_contenedor(Lista li) {
    List<String> nombresProductos = [];

    for (var element in li.productos) {
      nombresProductos.add(element.nombreProducto);
    }

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                li.nombreLista,
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: nombresProductos
                      .map((nombre) => RichText(
                                  text: TextSpan(
                                      text: '\u2022 ',
                                      style: const TextStyle(
                                          fontSize: 21,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      children: [
                                    TextSpan(
                                        text: nombre,
                                        style: const TextStyle(
                                            fontSize: 21,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal))
                                  ]))

                          // Text(nombre, style: TextStyle(fontSize: 21),)).toList(),
                          )
                      .toList(),
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Volver"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 220, 230, 247),
            width: 20.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 7,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(25),
          color: const Color.fromRGBO(239, 237, 254, 0.898),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListTile(
            visualDensity: const VisualDensity(vertical: 3),
            minLeadingWidth: 50.0,
            dense: false,
            onTap: () {},
            leading: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 70.0,
                minHeight: 70.0,
                maxWidth: 200.0,
                maxHeight: 200.0,
              ),
              child: Image.asset(
                'assets/logo_cart.png',
                width: 80.0,
                height: 80.0,
                alignment: Alignment.centerLeft,
                fit: BoxFit.fill,
              ),
            ),
            title: Text(li.nombreLista, style: const TextStyle(fontSize: 20)),
          ),
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
