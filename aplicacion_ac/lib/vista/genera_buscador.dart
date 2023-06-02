import 'package:aplicacion_ac/vista/Alergenos.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';
import 'package:aplicacion_ac/vista/buscador.dart';
import 'package:aplicacion_ac/vista/mi_cesta.dart';
import 'package:aplicacion_ac/modelo/Tienda.dart';
import 'package:aplicacion_ac/vista/Lista.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../modelo/base_datos.dart';
import 'menugeneral.dart';
import 'dart:math';
import 'Item.dart';

/// Estado de la página "Pagina7".
///
/// La clase [Pagina7] es el estado de la página "Pagina7" y extiende la clase [State]
/// con el mixin [SingleTickerProviderStateMixin]. Este estado contiene variables y métodos
/// relacionados con la funcionalidad y el comportamiento de la página.
class Pagina7 extends State<buscador> with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;
  int valor_actual = 1;

  String _valorIntroducido = "";
  bool productoEncontrado = false;
  Producto productoE =
      Producto(nombreProducto: "", precio: 0, hrefProducto: "");
  bool visible = false;
  late List<Producto> lista_productos;
  bool aniadir_a_cesta_pulsado = false;
  bool pulsado_buscar = false;
  String nombre_tienda = "";
  late List<Tienda> _resultado_busqueda;
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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

  /// Construye la estructura principal de la página.
  ///
  /// El método [build] se llama al construir la página y devuelve un widget [Scaffold]
  /// que define la estructura principal de la página. El fondo de la página se establece
  /// en un color específico, la barra de aplicación se crea utilizando [_buildAppBar],
  /// el contenido de la página se coloca encima del cajón lateral utilizando un [Stack],
  /// y el cajón lateral se crea utilizando [_buildDrawer]. El contenido de la página
  /// se construye utilizando [_buildContent].
  ///
  /// Retorna un widget [Scaffold] que representa la estructura principal de la página.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(254, 239, 188, 1),
      appBar: _buildAppBar(),
      body: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            _buildContent(context),
            _buildDrawer(),
          ],
        ),
      ),
    );
  }

  /// Construye la barra de aplicación.
  ///
  /// El widget [_buildAppBar] construye y devuelve la barra de aplicación de la página.
  /// Incluye un logo en la parte izquierda, un título en el centro y un botón de menú
  /// en la parte derecha para controlar el cajón lateral.
  ///
  /// Retorna un objeto [PreferredSizeWidget] que representa la barra de aplicación construida.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const Image(
        image: AssetImage('assets/logo4.png'),
        filterQuality: FilterQuality.high,
      ),
      title: const Text(
        'Selector de productos',
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
  /// El widget [_buildContent] construye y devuelve el contenido principal de la página.
  /// Contiene varios elementos, como el botón "Mi cesta", la barra deslizante de filtrado
  /// y la visualización del producto buscado. También incluye la construcción de unidades
  /// del producto y divisores entre los elementos.
  ///
  /// Recibe el parámetro [conte] que representa el contexto de la página.
  /// Retorna un objeto [SingleChildScrollView] que contiene el contenido construido.

  Widget _buildContent(conte) {
    List<bool> abierto = [];
    bool filtros = false;
    abierto.add(filtros);
    bool contenido = false;
    abierto.add(contenido);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // BOTÓN "MI CESTA"
          SizedBox(
            height: 50.0,
            width: 120.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    conte,
                    // nos pide el widget a utilizar que es de tipo materialpageroute
                    // creando una ruta de la pagina
                    MaterialPageRoute(builder: (conte) => const mi_cesta()));
              },
              child: const Text(
                'Mi cesta',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // BARRA DESLIZANTE 'FILTRADO'
          Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
            color: const Color.fromARGB(255, 120, 205, 130),
            alignment: AlignmentDirectional.topStart,
            width: MediaQuery.of(context).size.width,
            constraints: const BoxConstraints(
              maxHeight: double.infinity,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Divider(height: 50.0),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                //  _contenidoFiltrado(),
                                const Divider(
                                  height: 50,
                                ),
                                buscaProducto(),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),

                    const Divider(height: 40.0),

                    // mostramos producto buscado en caso de que exista
                    if (productoEncontrado || aniadir_a_cesta_pulsado)
                      _construye_producto(),
                    _construye_unidades(productoE, context),

                    const Divider(
                      height: 40,
                    ),
                  ]),
            ),
          ),
        ],
      )),
    );
  }

  /// Widget de búsqueda de producto.
  ///
  /// El widget [buscaProducto] muestra un campo de texto donde el usuario puede introducir
  /// el nombre de un producto para buscarlo. Al presionar Enter o enviar el formulario, se
  /// realiza una consulta en la base de datos para buscar el producto en las diferentes tiendas.
  /// Si se encuentra el producto, se muestra un mensaje de éxito y se establece la información
  /// del producto encontrado en la instancia de la clase [Producto]. Si no se encuentra el producto,
  /// se muestra un mensaje indicando que no se encontró.
  ///
  /// Este widget retorna un objeto [Container] que contiene el campo de texto de búsqueda.

  Widget buscaProducto() {
    Random random = Random();
    int aleatorio;
    List<Tienda> resultado_busqueda_producto =
        List<Tienda>.empty(growable: true);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Buscar producto',
            hintText: "Nombre del producto",
            filled: true,
            fillColor: Colors.white60,
          ),
          onSubmitted: (value) async {
            setState(() {
              productoEncontrado=!productoEncontrado;
              visible=!visible;
              pulsado_buscar = !pulsado_buscar;
              _valorIntroducido = value;
              
            });

            if (pulsado_buscar) {
              List<String> tablas = [];
              for (var i = 0; i < Tienda.obtenerTiendas.length; i++) {
                String tiendaEnDondeSeRealizaSelect =
                    Tienda.obtenerTiendas[i].nombre;
                tablas.add(tiendaEnDondeSeRealizaSelect);
              }

              await BD.consultaProductosTienda(_valorIntroducido).then((lista) {
                resultado_busqueda_producto = lista;

                _resultado_busqueda =
                    resultado_busqueda_producto as List<Tienda>;

                for (Tienda tienda in _resultado_busqueda) {
                  if (tienda.lista_busqueda.isNotEmpty) {
                    aleatorio = random.nextInt(tienda.lista_busqueda.length);
                    nombre_tienda = tienda.nombre;
                    productoE.imagen(tienda
                        .lista_busqueda[aleatorio].hrefProducto
                        .toString());
                    productoE.nombre(_valorIntroducido);
                    productoEncontrado = true;

                    break;
                  }
                }

                if (productoEncontrado) {
                  visible = true;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    backgroundColor: Color.fromARGB(255, 31, 85, 34),
                    content: Text("Producto encontrado!"),
                  ));

                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(milliseconds: 1000),
                    backgroundColor: Color.fromARGB(255, 31, 85, 34),
                    content: Text("Mostrando producto genérico..."),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(milliseconds: 1500),
                    backgroundColor: Colors.deepOrangeAccent,
                    content: Text("Producto no encontrado!"),
                  ));
                }
              });

              pulsado_buscar = !pulsado_buscar;
              _valorIntroducido = "";
            }
          }),
    );
  }

  /// Añade el producto a la cesta de la compra.
  ///
  /// El método [aniadir_a_cesta] se encarga de establecer la cantidad de unidades del producto actual
  /// utilizando el valor almacenado en la variable [valor_actual].
  ///
  /// Luego, realiza una verificación para determinar si el producto ya existe en la lista de productos de la cesta.
  /// Para ello, recorre la lista de productos [Lista.lista_productos] y compara el nombre del producto actual
  /// con los nombres de los productos existentes en la lista. Si se encuentra una coincidencia, se establece la
  /// variable [existe] como verdadera y se muestra una [SnackBar] en la interfaz para informar al usuario que
  /// el producto ya existe en la cesta. El mensaje de la [SnackBar] indica que el producto ya está en la cesta
  /// y tiene una duración de 1500 milisegundos. El fondo de la [SnackBar] tiene un color naranja intenso.
  ///
  /// Si la lista de productos de la cesta está vacía o el producto no existe en la lista, se llama al método
  /// [_aniadir_a_static] para añadir el producto a la cesta de forma definitiva.
  ///
  /// Finalmente, se restablece el valor de [valor_actual] a 1.
  ///
  /// Este método no retorna ningún valor.
  void aniadir_a_cesta() {
    productoE.setUnidades = valor_actual;
    bool existe = false;
    List<Producto> lista_p = List.empty(growable: true);

    for (Producto p in Lista.lista_productos) {
      lista_p.add(p);
    }

    for (Producto p in lista_p) {
      if (productoE.nombreProducto.replaceAll(' ', '') ==
          p.nombreProducto.replaceAll(' ', '')) {
        existe = !existe;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(milliseconds: 1500),
          backgroundColor: Colors.deepOrangeAccent,
          content: Text("Producto ya existente en la cesta!"),
        ));
        break;
      }
    }
    if (Lista.lista_productos.isEmpty || !existe) {
      _aniadir_a_static();
    }

    valor_actual = 1;
  }

  /// Añade el producto actual a una lista estática y actualiza las tiendas asociadas.
  ///
  /// El método [_aniadir_a_static] crea un nuevo objeto [Producto] utilizando los datos del producto actual.
  /// Luego, añade este nuevo producto a la lista estática [Lista.lista_productos].
  ///
  /// Muestra una [SnackBar] en la interfaz para informar al usuario que el producto ha sido añadido a la cesta.
  /// El mensaje de la [SnackBar] indica que el producto ha sido añadido correctamente y tiene una duración de 1200
  /// milisegundos. El fondo de la [SnackBar] tiene un color verde oscuro.
  ///
  /// Por último, recorre la lista de tiendas [_resultado_busqueda] y añade el producto o productos asociados
  /// a cada tienda utilizando el método [Tienda.anadirproductoOproductosATienda].
  ///
  /// Este método no retorna ningún valor.
  void _aniadir_a_static() {
    Producto producto_nuevo = Producto(
        nombreProducto: productoE.nombreProducto,
        precio: 0,
        hrefProducto: productoE.hrefProducto,
        unidades: productoE.unidades);
    Lista.lista_productos.add(producto_nuevo);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(milliseconds: 1200),
        backgroundColor: Color.fromARGB(255, 31, 85, 34),
        content: Text("Producto añadido a la cesta!")));

    for (Tienda t in _resultado_busqueda) {
      Tienda.anadirproductoOproductosATienda(t.nombre, t.lista_x_busqueda);
    }
  }

  /// Construye el widget para mostrar un producto.
  ///
  /// El método [_construye_producto] retorna un widget [Visibility] que contiene un [Container].
  /// El [Container] muestra la información del producto, incluyendo su imagen, nombre y un botón para
  /// añadirlo a la cesta.
  ///
  /// La visibilidad del [Container] se controla mediante la variable [visible], que determina si el
  /// producto debe mostrarse o no en la interfaz.
  ///
  /// El widget construido tiene un diseño de caja con bordes redondeados y un color de fondo.
  /// Contiene una fila ([Row]) que contiene la imagen del producto y un contenedor con el nombre del
  /// producto. El contenedor del nombre tiene un color de fondo y un ancho proporcional al tamaño de la
  /// pantalla. Además, incluye un botón para añadir el producto a la cesta.
  ///
  /// Retorna el widget construido para mostrar el producto.
  Widget _construye_producto() {
    // devolvemos si existe el producto buscado dentro de un CONTAINER
    return Visibility(
      visible: visible,
      child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(5.0),
          margin: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 7,
                blurRadius: 9,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(12),
            color: const Color.fromRGBO(239, 237, 254, 0.898),
            border: Border.all(
                color: const Color.fromARGB(255, 220, 230, 247), width: 4.0),
          ),
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 9,
              child: Row(
                  //mainAxisSize: MainAxisSize.min,

                  children: [
                    // Imagen del producto
                    Image.network(
                      productoE.hrefProducto,
                      height: MediaQuery.of(context).size.height,
                      width: 70.0,
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

                    // Nombre del producto
                    Container(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(241, 238, 238, 0.498)),
                      width: MediaQuery.of(context).size.width / 2.1,
                      height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 9,
                              child: Text(
                                productoE.nombreProducto.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                            // Boton AÑADIR A LISTA
                            SizedBox.fromSize(
                              size: const Size(60, 60),
                              child: ClipOval(
                                child: Material(
                                  color:
                                      const Color.fromARGB(255, 190, 224, 169),
                                  child: InkWell(
                                    splashColor: Colors.green,
                                    onTap: () {
                                      setState(() {
                                        visible = false;
                                        aniadir_a_cesta_pulsado = true;
                                        //valor_actual = 1;
                                        aniadir_a_cesta();
                                      });

                                      // Navigator.push(context,Pagina8(productos: productos),
                                      // cesta_productos);
                                    },
                                    child: const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(Icons.shopping_cart), // <-- Icon
                                        Text(
                                          "Añadir a cesta",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 8,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold),
                                        ), // <-- Text
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ),
                  ]))),
    );
  }

  /// Construye el widget para seleccionar las unidades del producto.
  ///
  /// El método [_construye_unidades] crea un widget [Center] que contiene un [CupertinoButton]
  /// con el texto "Unidades: $valor_actual". Al presionar el botón, se muestra un [CupertinoPicker]
  /// en forma de modal que permite al usuario seleccionar el número de unidades del producto.
  /// El rango de unidades disponibles se define en la lista [unidades].
  ///
  /// El valor seleccionado se almacena en la variable [valor_actual] y se actualiza mediante la función
  /// [onSelectedItemChanged] del [CupertinoPicker].
  ///
  /// Retorna el widget construido para seleccionar las unidades del producto.
  Widget _construye_unidades(Producto p, context) {
    final growableList =
        List<int>.generate(20, (int index) => index + 1, growable: true);

    List<Widget> textWidgets = growableList.map((int numero) {
      return Text(
        numero.toString(),
        style: TextStyle(
          color: valor_actual == numero ? Colors.blue : Colors.black,
        ),
      );
    }).toList();

    return Center(
      child: CupertinoButton.filled(
        child: Text("Unidades: $valor_actual"),
        onPressed: () {
          showCupertinoModalPopup(
              context: context,
              builder: (_) => SizedBox(
                    width: double.infinity,
                    height: 120,
                    child: CupertinoPicker(
                        useMagnifier: true,
                        magnification: 1.35,
                        squeeze: 1,
                        scrollController: FixedExtentScrollController(
                            initialItem: valor_actual),
                        backgroundColor:
                            const Color.fromARGB(255, 241, 239, 230),
                        itemExtent: 25,
                        onSelectedItemChanged: (int value) {
                          setState(() {
                            valor_actual = value + 1;
                            //       productoE.setUnidades(valor_actual);
                          });
                        },
                        children: [
                          //         List<Widget>.generate(unidades.length, (int index) {
                          //   return Center(child: Text(unidades[index] as String));
                          // }),
                          ...textWidgets,
                        ]),
                  ));
        },
      ),
    );
  }

  /// Construye el contenido filtrado desplegable.
  ///
  /// El método [_contenidoFiltrado] retorna un widget [ExpansionPanelList] que muestra una lista
  /// de paneles expansibles. Cada panel contiene un encabezado estático y un cuerpo con opciones filtradas.
  /// La lista de paneles se construye a partir de la lista [_listaItems], donde cada elemento es un objeto [Item].
  ///
  /// Al desplegar o contraer un panel, se actualiza el estado del item correspondiente para reflejar su estado.
  ///
  /// Retorna el widget construido para el contenido filtrado desplegable.
  Widget _contenidoFiltrado() {
    return ExpansionPanelList(
      animationDuration: const Duration(seconds: 1),
      dividerColor: Colors.green,
      elevation: 1,
      expandedHeaderPadding: const EdgeInsets.all(8),
      expansionCallback: (int index, bool isExpanded) {
        // actualizamos el estado del item (desplegado o no)
        setState(() {
          //guardamos el caso contrario al actual
          _listaItems[index].isExpanded = !isExpanded;
        });
      },
      children: _listaItems.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return const ListTile(title: Text('Filtrado'));
          },
          body: SizedBox(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Container(
                padding: const EdgeInsets.all(15.0),
                color: const Color.fromARGB(255, 226, 203, 181),
                child: eligeOpciones()),
          ),
          isExpanded: item.isExpanded!,
        );
      }).toList(),
    );
  }

  /// Construye un widget para elegir alérgenos.
  ///
  /// El método [eligeAlergenos] retorna un widget [SizedBox] que contiene una columna de elementos.
  /// Muestra un título "Elegir alérgenos" seguido de una lista de [CheckboxListTile]
  /// generados a partir de la lista [_opcionesAlergenos].
  ///
  /// Retorna el widget construido para elegir alérgenos.
  Widget tiendasPref() {
    return SizedBox(
      child: Column(
          //padding: EdgeInsets.all(15.0),

          children: [
            const Text(
              "Elegir tiendas favoritas:",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const Divider(height: 15),
            Column(
              children: _opcionesTiendas
                  .map<CheckboxListTile>(
                      (Tienda t) => construyeCheckboxTienda(t))
                  .toList(),
            )
          ]),
    );
  }

  /// Construye un widget para elegir alérgenos.
  ///
  /// El método [eligeAlergenos] retorna un widget [SizedBox] que contiene una columna de elementos.
  /// Muestra un título "Elegir alérgenos" seguido de una lista de [CheckboxListTile]
  /// generados a partir de la lista [_opcionesAlergenos].
  ///
  /// Retorna el widget construido para elegir alérgenos.
  Widget eligeAlergenos() {
    return SizedBox(
        child: Column(children: [
      const Text(
        "Elegir alérgenos:",
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 20),
      ),
      const Divider(height: 15),
      Column(
        //padding: EdgeInsets.all(15.0),

        children: _opcionesAlergenos
            .map<CheckboxListTile>(
                (Alergenos a) => construyeCheckboxAlergenos(a))
            .toList(),
      ),
    ]));
  }

  /// Construye un widget [CheckboxListTile] para una tienda dada.
  ///
  /// El método [construyeCheckboxTienda] retorna un widget [CheckboxListTile]
  /// que muestra un checkbox junto con el nombre y una imagen de la tienda.
  ///
  /// - [tienda]: El objeto [Tienda] que representa la tienda.
  ///
  /// Retorna el widget construido para la tienda dada.
  CheckboxListTile construyeCheckboxTienda(Tienda tienda) {
    return CheckboxListTile(
      activeColor: const Color.fromARGB(255, 122, 214, 16),
      checkColor: const Color.fromARGB(255, 0, 0, 0),
      title: Text(tienda.nombre),
      value: tienda.clickado,
      controlAffinity: ListTileControlAffinity.platform,
      onChanged: (value) {
        setState(() {
          tienda.clickado = value!;
        });
      },
      secondary: Image.asset(
        tienda.img,
        height: MediaQuery.of(context).size.height / 2,
        width: 35.0,
        alignment: Alignment.center,
      ),
    );
  }

  /// Construye un widget [CheckboxListTile] para un alérgeno dado.
  ///
  /// El método [construyeCheckboxAlergenos] retorna un widget [CheckboxListTile]
  /// que muestra un checkbox junto con el nombre y una imagen del alérgeno.
  ///
  /// - [alergeno]: El objeto [Alergenos] que representa el alérgeno.
  ///
  /// Retorna el widget construido para el alérgeno dado.
  CheckboxListTile construyeCheckboxAlergenos(Alergenos alergeno) {
    return CheckboxListTile(
      activeColor: const Color.fromARGB(255, 122, 214, 16),
      checkColor: const Color.fromARGB(255, 0, 0, 0),
      title: Text(alergeno.nombre),
      value: alergeno.clickado,
      controlAffinity: ListTileControlAffinity.platform,
      onChanged: (value) {
        setState(() {
          alergeno.clickado = value!;
        });
      },
      secondary: Image.asset(
        alergeno.img,
        height: MediaQuery.of(context).size.height / 2,
        width: 35.0,
        alignment: Alignment.center,
      ),
      // ALTERNATIVA
      // const Icon(Icons.water_outlined),
    );
  }

  /// Construye el widget para elegir opciones.
  ///
  /// El método [eligeOpciones] retorna un widget [SizedBox] que contiene una columna
  /// con varias opciones para elegir. El widget tiene una altura fija de 100.0 y
  /// contiene dos elementos separados por barras divisoras ([Divider]).
  ///
  /// - [tiendasPref]: Un widget que representa las tiendas preferidas del usuario.
  /// - [eligeAlergenos]: Un widget para que el usuario elija alérgenos.
  ///
  /// Retorna el widget construido para elegir opciones.
  Widget eligeOpciones() {
    return SizedBox(
        height: 100.0,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // BARRAS SEPARADORAS
          const Divider(
            height: 30,
          ),
          tiendasPref(),
          const Divider(
            height: 30,
          ),
          eligeAlergenos(),
        ]));
  }

  /// Construye el widget del cajón lateral (drawer).
  ///
  /// El método [_buildDrawer] retorna un widget animado que representa el cajón
  /// lateral de la aplicación. Utiliza un [AnimatedBuilder] para animar la
  /// transición del cajón desde el borde derecho de la pantalla. El controlador
  /// [_drawerSlideController] se utiliza para controlar la animación.
  ///
  /// - [context]: El contexto de la construcción del widget.
  ///
  /// Retorna el widget del cajón lateral construido.
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

/// Lista para determinar el numero de Items de la seccion desplegable 'Filtrado'
List<Item> _listaItems = generaItems(1);

List<Tienda> tiendas = List.empty(growable: true);

final _opcionesTiendas = [
  Tienda(nombre: "Carrefour", imagen: "assets/carrefour.png"),
  Tienda(nombre: "Ahorramas", imagen: "assets/ahorramas.jpg"),
  Tienda(nombre: "Supercor", imagen: "assets/supercor.png")
];
final _opcionesAlergenos = [
  Alergenos(nombre: "Gluten", imagen: "assets/trigo.jpg"),
  Alergenos(nombre: "Lactosa", imagen: "assets/lactose.png"),
  Alergenos(nombre: "Frutos secos", imagen: "assets/images.jpg")
];
