import 'package:aplicacion_ac/vista/Producto.dart';
import 'package:aplicacion_ac/vista/Lista.dart';
import 'package:aplicacion_ac/vista/pagina11.dart';
import 'package:aplicacion_ac/vista/pagina7.dart';
import 'package:flutter/material.dart';
import 'Lista.dart';
import 'Lista.dart';
import 'pagina1.dart';
import 'menugeneral.dart';

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
    List<Widget> listaListas = crearListas(Lista.getProductos());

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

                  if (Lista.getProductos().length > 0) {
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
                Lista lista1 =
                    new Lista(valor_introducido.text, "Lista guardada");
                lista1.productos = Lista.getProductos();
                Lista.addLista();
             
                print((Lista.listas).length);

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
          content: Text("Pulse aceptar para generar visualizar el resultado."),
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
    bool activado = false;

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
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      child: Text("Centralizado"),
                    )),
                Switch(
                  value: activado,
                  onChanged: (bool value) {
                    setState(() {
                      value = activado;

                      print(value);
                    });
                  },
                ),
                Spacer(),
                Expanded(
                    flex: 2,
                    child: Container(
                      child: Text("Precio"),
                    )),
                Switch(
                  value: activado,
                  onChanged: (bool value) {
                    setState(() {
                      value = activado;

                      print(value);
                    });
                  },
                ),
              ],
            ),
            Divider(),
            Expanded(

                ///////////////////////////////////////////////////vrlodicdad
                child: ListView(
              controller: ScrollController(initialScrollOffset: 2),
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
  List<Widget> crearListas(List<Producto> productos) {
    final List<Widget> listaObj = [];

    // Por cada objeto Producto encontrado se monta un contenedor y se añade a
    // la lista de widgets que va dentro de un LIST VIEW
    int pos = 0;
    for (Producto pro in productos) {
      final objetoTemporal = _montar_contenedor(pro);
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
  Widget _montar_contenedor(Producto p) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromRGBO(240, 158, 111, 1), width: 5.0),
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(226, 244, 250, 226)),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 0.0),
          minLeadingWidth: 100.0,
          dense: false,
          onTap: () => () {},
          leading: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 70.0,
                minHeight: 100.0,
                maxWidth: 300.0,
                maxHeight: 300.0),
            child: Image.asset(
              p.imagenProducto,
              width: 50.0,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.centerLeft,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            p.nombreProducto,
          ),
          trailing: Icon(
            Icons.star_border_rounded,
            size: 40.0,
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