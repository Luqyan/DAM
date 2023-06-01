import 'package:aplicacion_ac/vista/vista_resultado.dart';
import 'package:flutter/material.dart';
import '../modelo/base_datos.dart';
import '../modelo/Producto.dart';
import 'menugeneral.dart';
import 'mi_cesta.dart';
import 'Lista.dart';

/// Clase que representa la página 8 de la aplicación.
///
/// Esta clase utiliza el mixin `SingleTickerProviderStateMixin` para proporcionar
/// un controlador de animación para la apertura y cierre del menú lateral.
class Pagina8 extends State<mi_cesta> with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  // ignore: non_constant_identifier_names
  final TextEditingController valor_introducido = TextEditingController();
  // ignore: non_constant_identifier_names
  List<Lista> listas_confirmdas = List<Lista>.empty();

  @override
  void initState() {
    super.initState();

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

  /// Verifica si el menú lateral está abierto.
  ///
  /// - [@return] `true` si el menú lateral está abierto, de lo contrario retorna `false`.
  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  /// Verifica si el menú lateral se está abriendo.
  ///
  /// - [@return] `true` si el menú lateral se está abriendo, de lo contrario retorna `false`.
  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  /// Verifica si el menú lateral está cerrado.
  ///
  /// - [@return] `true` si el menú lateral está cerrado, de lo contrario retorna `false`.
  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  /// Alterna entre abrir y cerrar el menú lateral.
  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  /// Construye la interfaz de usuario de la página principal.
  ///
  /// El [context] parámetro es el contexto de la aplicación.
  ///
  /// Retorna un Widget de tipo Scaffold que representa la interfaz de usuario
  /// de la página principal.
  @override
  Widget build(BuildContext context) {
    // Cogemos los Productos de la lista atributo de la clase Lista
    List<Widget> listaListas = crearListas(Lista.getProductos(), context);

    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 239, 188, 1),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(context, listaListas),
          _buildDrawer(),
        ],
      ),

      // LOS DOS BOTONES QUE SE ENCUENTRAN EN LA PARTE INFERIOR DE LA PÁGINA
      bottomNavigationBar: Row(
        children: [
          Expanded(
            flex: 2,
            child: Material(
              shape: const RoundedRectangleBorder(
                  side: BorderSide(
                      color: Color.fromRGBO(240, 158, 111, 1), width: 5.0)),
              color: const Color.fromARGB(255, 80, 184, 74),
              child: InkWell(
                onTap: () {
                  if (Lista.getProductos().isNotEmpty) {
                    guardar_lista();
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title:
                                const Text("No tienes ningúna lista generada."),
                            content: const Text(
                                "Para generar listas accede a la página 'Selector de productos' desde el menú "),
                            actions: [
                              ElevatedButton(
                                  child: const Text("Cerrar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ],
                          );
                        });
                  }
                },
                child: const SizedBox(
                  height: kToolbarHeight,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Guardar lista',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Material(
              shape: const RoundedRectangleBorder(
                  side: BorderSide(
                      color: Color.fromRGBO(240, 158, 111, 1), width: 5.0)),
              color: const Color.fromARGB(255, 80, 184, 74),
              child: InkWell(
                onTap: () {
                  if (Lista.getProductos().isNotEmpty) {
                    confirmar_lista(context);
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("No hay listas por confirmar"),
                            content: const Text(
                                "Para generar listas accede a la página 'Selector de productos' desde el menú "),
                            actions: [
                              ElevatedButton(
                                  child: const Text("Cerrar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  })
                            ],
                          );
                        });
                  }
                  //  / //  ///     //  / / //  /// /// / ///   /   / /   / / //  / / //  //  / //  //  / / / /   / / //  /

                  /// /// / //  / //  ////  //  / ///   /// / / / / /       / / / /   / / / / //  / ////  / / //  /
                },
                child: const SizedBox(
                  height: kToolbarHeight,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Confirmar lista',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Muestra un diálogo para guardar una lista y retorna un Future.
  ///
  /// Retorna un Future que se resuelve cuando se cierra el diálogo.
  Future guardar_lista() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Introducir nombre lista:"),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(hintText: "Nombre lista"),
            controller: valor_introducido,
          ),
          actions: [
            TextButton(
              child: const Text("Aceptar"),
              onPressed: () {
                // SE GENERA UNA LISTA NUEVA Y SE AÑADE A LA LISTA DE LISTAS
                Lista lista1 = Lista(valor_introducido.text);

                lista1.aniade_lista_productos(Lista.getProductos());

                BD.insertListaFavorita(lista1);

                Lista.addLista(lista1);

                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(milliseconds: 1500),
                  backgroundColor: Color.fromARGB(255, 70, 213, 97),
                  content: Text("Lista guardada con éxito!"),
                ));

                submit();
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar"))
          ],
        ),
      );

  /// Muestra un diálogo de confirmación de lista y retorna un Future.
  ///
  /// El [conte] parámetro es el contexto de la aplicación.
  ///
  /// Retorna un Future que se resuelve cuando se cierra el diálogo.
  Future confirmar_lista(conte) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Lista confirmada!"),
          content: const Text(
              "Pulse aceptar para generar y visualizar el resultado."),
          actions: [
            TextButton(
                child: const Text("Aceptar"),
                onPressed: () {
                  // LA LISTA CREADA SE CONSERVA EN LA VARIABLE STATIC '_lista_productos'
                  // CUYOS VALORES SE UTILIZAN EN LA SIGUIENTE PÁGINA DONDE SE GENERAN
                  // LOS RESULTADOS

                  // print( (Lista.listas).length);

                  submit();

                  setState(() {
                    Navigator.push(
                        conte,
                        // nos pide el widget a utilizar que es de tipo materialpageroute
                        // creando una ruta de la pagina
                        MaterialPageRoute(
                            builder: (conte) => const genera_resultado()));
                  });
                }),
          ],
        ),
      );

  void submit() {
    Navigator.of(context).pop();
  }

  /// Construye la barra de aplicación (AppBar).
  ///
  /// Retorna un Widget de tipo [PreferredSizeWidget] que representa la barra de
  /// aplicación con el logo, título, botón de menú y animación de apertura
  /// y cierre del menú lateral.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const Image(
        image: AssetImage('assets/logo4.png'),
        filterQuality: FilterQuality.high,
      ),
      title: const Text(
        'Cesta productos',
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

  /// Construye el contenido principal de la interfaz de usuario.
  ///
  /// El [conte] parámetro representa un valor de contenido.
  /// El [productos] parámetro es una lista de widgets de productos.
  ///
  /// Retorna un Widget de tipo Container que contiene el contenido principal.
  Widget _buildContent(conte, productos) {
    // Indicador si se ha arrastrado y soltado algo
    bool centralizado = false;
    bool precio = true;

    return Container(
      margin: const EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      alignment: AlignmentDirectional.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          const Divider(
            height: 20,
            thickness: 3,
            color: Colors.orangeAccent,
          ),
          Row(
            children: [
              const Expanded(
                flex: 2,
                child: Text("Centralizado"),
              ),
              Switch(
                value: centralizado,
                onChanged: (bool value) {
                  setState(() {
                    centralizado = value;
                  });
                },
              ),
              const Spacer(),
              const Expanded(
                flex: 2,
                child: Text("Precio"),
              ),
              Switch(
                value: precio,
                onChanged: (bool value) {
                  setState(() {
                    precio = !value;
                    print(value);
                  });
                },
              ),
            ],
          ),
          const Divider(
            height: 30,
            thickness: 3,
            color: Colors.orangeAccent,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 30),
              controller: ScrollController(initialScrollOffset: 2),
              itemCount: productos.length,
              itemBuilder: (BuildContext context, int index) =>
                  productos[index],
            ),
          ),
        ],
      ),
    );
  }

  /// Genera una lista de Widgets a partir de una lista de productos.
  ///
  /// El [productos] parámetro es la lista de productos a mostrar.
  /// El [context] parámetro es el contexto de la aplicación.
  ///
  /// Retorna una lista de Widgets que representan los productos.
  List<Widget> crearListas(List<Producto> productos, context) {
    final List<Widget> listaObj = [];

    // Por cada objeto Producto encontrado se monta un contenedor y se añade a
    // la lista de widgets que va dentro de un LIST VIEW
    int pos = 0;
    for (Producto pro in productos) {
      final objetoTemporal = _montar_contenedor(pro, context);
      // y despues lo convertimos a un objeto draggable
      final objetoFinal = _generaDraggable(objetoTemporal, pos);
      listaObj.add(objetoFinal);

      listaObj.add(const SizedBox(height: 20.0));
      pos += 1;
    }

    return listaObj;
  }

  /// Genera un Widget arrastrable (Draggable) que permite eliminar un elemento.
  ///
  /// El [w] parámetro es el Widget que se desea hacer arrastrable.
  /// El [pos] parámetro indica la posición del elemento en la lista.
  ///
  /// Retorna un Widget de tipo Dismissible que envuelve al Widget arrastrable.
  /// Al arrastrar y soltar el elemento, se muestra una Snackbar de confirmación
  /// de eliminación y se actualiza la lista de productos.
  Widget _generaDraggable(Widget w, int pos) {
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
          Lista.borrarProductoPorPosicion(pos);
        });
      },
      child: SizedBox(
        height: 80.0,
        width: MediaQuery.of(context).size.width,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: w,
        ),
      ),
    );
  }

  /// Construye y retorna un Widget de tipo Container que muestra un producto.
  ///
  /// El [p] parámetro representa el producto a mostrar.
  /// El [context] parámetro es el contexto de la aplicación.
  ///
  /// Retorna un Widget de tipo Container que contiene la representación visual
  /// del producto, incluyendo su imagen, nombre y un botón de añadir a favoritos.
  Widget _montar_contenedor(Producto p, context) {
    const snackBar = SnackBar(
        duration: Duration(seconds: 1),
        content: Text("El producto ha sido añadido a favoritos!"));

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromRGBO(240, 158, 111, 1), width: 3.0),
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(226, 244, 250, 226)),
      child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: ListTile(
            contentPadding: const EdgeInsets.all(10.0),
            visualDensity: const VisualDensity(vertical: 0.0),
            minLeadingWidth: 70.0,
            dense: false,
            leading: ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: 70.0,
                  minHeight: 100.0,
                  maxWidth: 200.0,
                  maxHeight: 200.0),
              child: Image.network(
                p.hrefProducto,
                height: MediaQuery.of(context).size.height,
                width: 70.0,
                alignment: Alignment.center,
                scale: 1,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stacktrace) {
                  return Image.asset("assets/image_producto_no_encontrada.jpg",
                      height: MediaQuery.of(context).size.height,
                      width: 50.0,
                      alignment: Alignment.center,
                      fit: BoxFit.contain);
                },
              ),
            ),
            title: Text(
              p.nombreProducto,
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.star_border_rounded,
                size: 40.0,
              ),
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                setState(() {
                  BD.insertProductoFavorito(p);
                  aniadir_favorito(p);
                });
              },
            ),
          )),
    );
  }

  void aniadir_favorito(Producto p) {
    Lista.aniadir_favorito(p);
  }

  /// Construye el Drawer animado.
  ///
  /// Este método devuelve un widget de tipo Builder animado que controla la animación del Drawer.
  /// Utiliza el controlador de animación [_drawerSlideController] para controlar la transición del Drawer.
  /// La animación se aplica mediante la transformación [FractionalTranslation], desplazando el Drawer
  /// hacia la derecha según el valor actual del controlador.
  ///
  /// Si el Drawer está cerrado, se muestra un widget [SizedBox] vacío. De lo contrario, se muestra
  /// el widget [Menu].
  ///
  /// Retorna el widget que representa el Drawer animado.
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
