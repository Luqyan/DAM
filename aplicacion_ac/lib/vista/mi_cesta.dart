import 'package:aplicacion_ac/vista/Lista.dart';
import 'package:aplicacion_ac/vista/pagina11.dart';
import 'package:aplicacion_ac/vista/buscador.dart';
import 'package:flutter/material.dart';
import 'Lista.dart';
import 'inicio.dart';
import 'menugeneral.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';

// CLASE PRINCIPAL CREADORA DE 'HOME'
class Pagina8 extends StatefulWidget {
  const Pagina8({Key? key}) : super(key: key);

  // creamos la ista de listas a través del método

  @override
  State<Pagina8> createState() => _Pagina8();
}

/////////////////////////////////////1 ª PARTE//////////////////////////////////////////////
// CLASE ANIMADO
class _Pagina8 extends State<Pagina8> with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  final TextEditingController valor_introducido = TextEditingController();

  List<Lista> listas_confirmdas = List<Lista>.empty();

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
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Color.fromRGBO(240, 158, 111, 1), width: 5.0)),
              color: Color.fromARGB(255, 80, 184, 74),
              child: InkWell(
                onTap: () {
                  print('Pulsado "Guardar Lista"');

                  if (Lista.getProductos().isNotEmpty) {
                    guardar_lista();
                  } else {
                    _showDailog() {}
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
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Color.fromRGBO(240, 158, 111, 1), width: 5.0)),
              color: Color.fromARGB(255, 80, 184, 74),
              child: InkWell(
                onTap: () {
                  print('Pulsado "Confirmar Lista"');

                  // /// // // / /// / //// / / // /AQUI VER COMO HACEMOS PARA GENERAR RESULTADO / / // / / // //// / //// / / // // / // / // / / //
                  if (Lista.getProductos().length > 0) {
                    confirmar_lista(context);
                  } else {
                    _showDailog() {}
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
              child: Text("Aceptar"),
              onPressed: () {
                // SE GENERA UNA LISTA NUEVA Y SE AÑADE A LA LISTA DE LISTAS
                Lista lista1 = new Lista(valor_introducido.text);

                lista1.aniade_lista_productos(Lista.getProductos());
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
                child: Text("Cancelar"))
          ],
        ),
      );

  Future confirmar_lista(conte) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Lista confirmada!"),
          content:
              Text("Pulse aceptar para generar y visualizar el resultado."),
          actions: [
            TextButton(
                child: Text("Aceptar"),
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
                        MaterialPageRoute(builder: (conte) => Pagina11()));
                  });
                }),
          ],
        ),
      );

  void submit() {
    Navigator.of(context).pop();
  }

//////////////////////////////////////////////////////////////////////////////////////////
////////////////////// método de creación de appBaar personalizado/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

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

  ////////////////////////////////////////////////////////////////////////
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
          Divider(
            height: 20,
            thickness: 3,
            color: Colors.orangeAccent,
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Text("Centralizado"),
                ),
              ),
              Switch(
                value: centralizado,
                onChanged: (bool value) {
                  setState(() {
                    centralizado = value;
                    print(value);
                  });
                },
              ),
              Spacer(),
              Expanded(
                flex: 2,
                child: Container(
                  child: Text("Precio"),
                ),
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
          Divider(
            height: 30,
            thickness: 3,
            color: Colors.orangeAccent,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 30),
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
  ////////////////////////////////////////////////////////////////////////

  /// Metodo que genera una lista de widgets de listas favoritas (guardadas)
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

      listaObj.add(SizedBox(height: 20.0));
      pos += 1;
    }

    return listaObj;
  }

  // Metodo de conversión de los elementos de ListView a Draggable

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

  // Metodo constructor de contenedor de lista (ListTile)
  Widget _montar_contenedor(Producto p, context) {
    const snackBar = SnackBar(
        duration: Duration(seconds: 1),
        content: Text("El producto ha sido añadido a favoritos!"));
    final ThemeData theme = ThemeData();
    Color myColor = Theme.of(context).colorScheme.secondary;

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromRGBO(240, 158, 111, 1), width: 3.0),
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(226, 244, 250, 226)),
      child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: ListTile(
            contentPadding: EdgeInsets.all(10.0),
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
              icon: new Icon(
                Icons.star_border_rounded,
                size: 40.0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                setState(() {
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
