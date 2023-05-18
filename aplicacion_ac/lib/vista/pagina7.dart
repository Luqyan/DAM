import 'package:aplicacion_ac/vista/Alergenos.dart';
import 'package:aplicacion_ac/vista/Item.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';
import 'package:aplicacion_ac/modelo/Tienda.dart';
import 'package:aplicacion_ac/vista/Lista.dart';
import 'package:aplicacion_ac/vista/pagina8.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../modelo/base_datos.dart';
import 'pagina1.dart';
import 'menugeneral.dart';
import 'Item.dart';
import 'package:aplicacion_ac/controlador/GestionDatosTablas.dart';
// Creamos un objeto de clase 'Lista' para usar el atributo lista_productos
// que representará la cesta de productos añadidos después de la busqueda

// Lista para determinar el numero de Items de la seccion desplegable 'Filtrado'
List<Item> _listaItems = generaItems(1);
Producto prod0 = Producto(
    nombreProducto: 'pan',
    precio: 1.10,
    hrefProducto: 'assets/pan.jpg');

Producto prod1 = Producto(
    nombreProducto: 'pan integral',
    precio: 1.60,
    hrefProducto: 'assets/pan_integral.jpg');
Producto prod2 = Producto(
    nombreProducto:
        'leche sin lactosa semidesnatada marca Puleva bajo contenido en grasa',
    precio: 1.20,
    hrefProducto: 'assets/leche_sin_lactosa.png');
Producto prod3 = Producto(
    nombreProducto: 'cerveza',
    precio: 0.70,
    hrefProducto: 'assets/mahou.jpg');
Producto prod4 = Producto(
    nombreProducto: 'huevos',
    precio: 2.60,
    hrefProducto: 'assets/huevos_eco.jpg');
Producto prod5 = Producto(
    nombreProducto: 'helado hägen dasz',
    precio: 4.80,
    hrefProducto: 'assets/helado_haagen.jpg');
Producto prod6 = Producto(
    nombreProducto: 'yogur griego',
    precio: 0.60,
    hrefProducto: 'assets/yogur_griego.jpg');
Producto prod7 = Producto(
    nombreProducto: 'Arroz',
    precio: 0.90,
    hrefProducto: 'assets/arroz.jpg');

// Lista contenedora de productos
Set<Producto> _productos = Set<Producto>()
  ..addAll([prod0, prod1, prod2, prod3, prod4, prod5, prod6, prod7]);

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






// CLASE PRINCIPAL CREADORA DE 'HOME'
class Pagina7 extends StatefulWidget {
  const Pagina7({
    super.key,
  });

  @override
  State<Pagina7> createState() => _Pagina7();
}

/////////////////////////////////////1 ª PARTE//////////////////////////////////////////////
// CLASE ANIMADO
class _Pagina7 extends State<Pagina7> with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;
  int valor_actual = 1;
  List<int> unidades = [1,2,3,4,5,6,7,8,9,10];
  String _valorIntroducido = "";
  bool _productoEncontrado = false;
  Producto _productoE =
      new Producto(nombreProducto: "", precio: 0, hrefProducto: "");

  // Lista de productos que surge al buscar productos y añadirlos a la cesta
  List<Producto> _cesta_productos = List<Producto>.empty(growable: true);

  List<Tienda> tiendas = Tienda.obtenerTiendas as List<Tienda>;

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

  // metodo creacion Scaffold
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      //backgroundColor: Colors.transparent,
      appBar: _buildAppBar(),
      body: Container(
          height: double.infinity,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(image: DecorationImage(
          image: AssetImage('assets/carts.jpg'), 
          opacity: 0.9,
          invertColors: true,
          fit: BoxFit.fill),
          ),
          child: Stack(
            children: [
              
              _buildContent(context),
              _buildDrawer(),
            ],
          ),
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
        'Selector de productos',
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

  /////////////////////////////////////////////////////
  // AQUI AÑADIMOS EL CONTENIDO DE LA PAGINA (BODY)////
  // METODO QUE DEVUELVE UN SIZED BOX CON SUS VALORES//
  Widget _buildContent(conte) {
    List<bool> _abierto = [];
    bool filtros = false;
    _abierto.add(filtros);
    bool contenido = false;
    _abierto.add(contenido);

    return SingleChildScrollView(
      padding: EdgeInsets.all(15.0),
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
                print("Numero productos en cesta: " +
                    Lista.getProductos().length.toString());
                Navigator.push(
                    conte,
                    // nos pide el widget a utilizar que es de tipo materialpageroute
                    // creando una ruta de la pagina
                    MaterialPageRoute(builder: (conte) => Pagina8()));
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
            color: Color(0xFFFAF482),
            alignment: AlignmentDirectional.topStart,
            width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height * 1.2,
            constraints: BoxConstraints(
              maxHeight: double.infinity,
            ),

            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Divider(height: 50.0),

                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                _contenidoFiltrado(),
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
                    if (_productoEncontrado)  _construye_producto(_productoE),
                    _construye_unidades(_productoE, context),

                  //   if(_productoEncontrado) _construye_unidades(_productoE, context),

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


  



  // Barra de busqueda de productos
  Widget buscaProducto() {
    int cantidad_prod = 0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: TextField(
        onSubmitted: (value) {
          setState(() {
            _valorIntroducido = value;

           
           


            // SELECT * IN carrefour => List()




            // carrefour.productos(BD.consultaProductos([carrefour.nombreLista], value));


            // SELECT * IN ahorramas => List()






            for (Producto p in _productos) {
              if ((p.nombreProducto.toString())
                  .toLowerCase()
                  .startsWith(_valorIntroducido.toLowerCase())) {
                _productoE = p;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////

                ////////////////////////////////////////////////////////////////////////////////////////////////////////
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    duration: Duration(seconds: 1),
                    backgroundColor: Color.fromARGB(255, 31, 85, 34),
                    content: Text("Producto encontrado!")));
                _productoEncontrado = true;

                // CONTROLAMOS EL NUMERO DE COINCIDENCIAS
                cantidad_prod += 1;
                break;
              } else {
                _productoEncontrado = false;
              }
            }
            if (cantidad_prod > 0) {
              // MOSTRAMOS ALGO ..........................
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(milliseconds: 1000),
                  backgroundColor: Color.fromARGB(255, 31, 85, 34),
                  content: Text("Mostrando producto genérico...")));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(milliseconds: 1500),
                  backgroundColor: Colors.deepOrangeAccent,
                  content: Text("Producto no encontrado!")));
            }
            //_valorIntroducido = "";
          });
        },

        // decoramos la barra introduciendo el texto informativo,
        // activando la funcion de rellenado y dandole color al fondo de la barra de texto
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Buscar producto',
            hintText: "Nombre del producto",
            filled: true,
            fillColor: Colors.white60),
            
      ),
    );
  }

  // MÉTODO CONTRUCTOR DE PRODUCTO BUSCADO Y ENCONTRADO
  Widget _construye_producto(Producto prod) {
    // devolvemos si existe el producto buscado dentro de un CONTAINER
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5.0),
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
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
                  Image.asset(
                    prod.hrefProducto,
                    height: MediaQuery.of(context).size.height,
                    width: 70.0,
                    alignment: Alignment.center,
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
                              prod.nombreProducto.toString(),
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
                                color: Color.fromARGB(255, 190, 224, 169),
                                child: InkWell(
                                  splashColor: Colors.green,
                                  onTap: () {
                                    setState(() {
                                      _productoE.setUnidades = valor_actual;
                                      // SE CONSERVA EL DATO INTRODUCIDO EN EL NOMBRE DEL PRODUCTO
                                      // PARA REALIZAR UNA BUSQUEDA SOBRE EL DURANTE EL PROCESO DE FILTRADO
                                      // DE LA PAGINA 11 (CUANDO EN LA PAGINA 8 SE PULSA 'CREAR LISTA' INMEDIATAMENTE DESPUÉS)

                                      // _productoE.nombreProducto(prod.nombreProducto.toString()); 

                                      aniadir_a_cesta(_productoE);
                                      valor_actual = 1;


                                        ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              duration: Duration(milliseconds: 1200),
                                              backgroundColor: Color.fromARGB(255, 31, 85, 34),
                                              content: Text(
                                                  "Producto añadido a la cesta!")));
                                    
                                    
                                    
                                    });

                                    // Navigator.push(context,Pagina8(productos: productos),
                                    // cesta_productos);
                                  },
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                ])));
  }

  Widget _construye_unidades(Producto p, context) {
   
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

                        scrollController:
                            FixedExtentScrollController(initialItem: valor_actual),
                        backgroundColor: Color.fromARGB(255, 133, 127, 109),
                        itemExtent: 25,
                        onSelectedItemChanged: (int value) {
                          
                          setState(() {
                            valor_actual = value+1;
                           //       _productoE.setUnidades(valor_actual);
                          });
                        },
                        children:  [
                          
                    //         List<Widget>.generate(unidades.length, (int index) {
                    //   return Center(child: Text(unidades[index] as String));
                    // }),



                          Text('1', style: TextStyle(color: valor_actual == 1 ? Colors.blue : Colors.black),),
                          Text('2', style: TextStyle(color: valor_actual == 2 ? Colors.blue : Colors.black),),
                          Text('3', style: TextStyle(color: valor_actual == 3 ? Colors.blue : Colors.black),),
                          Text('4', style: TextStyle(color: valor_actual == 4 ? Colors.blue : Colors.black),),
                          Text('5', style: TextStyle(color: valor_actual == 5 ? Colors.blue : Colors.black),),
                          Text('6', style: TextStyle(color: valor_actual == 6 ? Colors.blue : Colors.black),),
                          Text('7', style: TextStyle(color: valor_actual == 7 ? Colors.blue : Colors.black),),
                          Text('8', style: TextStyle(color: valor_actual == 8 ? Colors.blue : Colors.black),),
                          Text('9', style: TextStyle(color: valor_actual == 9 ? Colors.blue : Colors.black),),
                          Text('10', style: TextStyle(color: valor_actual == 109 ? Colors.blue : Colors.black),),
                      
                        
                        
                        
                        ]),
                  ));
        },
      ),
    );
  }

  void aniadir_a_cesta(prod) {
    
    // print(prod.toString());
    Lista.addProducto(prod);
  }

  /////////////////////////////////////////////////////
  /////////////////////////////////////////////////////

  ///Método que construye la parte extensible y el resto de contenido

  Widget _contenidoFiltrado() {
    return ExpansionPanelList(
      animationDuration: Duration(seconds: 1),
      dividerColor: Colors.green,
      elevation: 1,
      expandedHeaderPadding: EdgeInsets.all(8),
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
                padding: EdgeInsets.all(15.0),
                color: Color.fromARGB(255, 226, 203, 181),
                child: eligeOpciones()),
          ),
          isExpanded: item.isExpanded!,
        );
      }).toList(),
    );
  }

// SECCIÓN DE TIENDAS FAVORITAS
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

// SECCIÓN DE ALÉRGENOS
  Widget eligeAlergenos() {
    return SizedBox(
        child: Column(
            //padding: EdgeInsets.all(15.0),

            children: [
          const Text(
            "Elegir alérgenos:",
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 20),
          ),
          Divider(height: 15),
          Column(
            //padding: EdgeInsets.all(15.0),

            children: _opcionesAlergenos
                .map<CheckboxListTile>(
                    (Alergenos a) => construyeCheckboxAlergenos(a))
                .toList(),
          ),
        ]));
  }

  // CONSTRUYE CHECKBOX DE TIENDAS
  CheckboxListTile construyeCheckboxTienda(Tienda tienda) {
    return CheckboxListTile(
      activeColor: Color.fromARGB(255, 122, 214, 16),
      checkColor: Color.fromARGB(255, 0, 0, 0),
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

  // CONSTRUYE CHECKBOX DE ALÉRGENOS
  CheckboxListTile construyeCheckboxAlergenos(Alergenos alergeno) {
    return CheckboxListTile(
      activeColor: Color.fromARGB(255, 122, 214, 16),
      checkColor: Color.fromARGB(255, 0, 0, 0),
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

  /// Widget para elegir tiendas favoritas
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

// Generador de una lista de Items
List<Item> generaItems(int tamanio) {
  return List.generate(
    tamanio,
    (int index) => Item(
      expanded: '$index',
      title: 'Item $index',
      isExpanded: false,
    ),
  );
}
