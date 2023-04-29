import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'Lista.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';
import 'pagina1.dart';
import 'menugeneral.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/////////////////// MIRAR POR QUE NO FUNCIONAN LOS SETTERS DE LA CLASE /////////////////////

Producto prod1 = Producto('pan integral', 1.60, 'assets/pan_integral.jpg');
Producto prod2 =
    Producto('leche sin lactosa', 1.20, 'assets/leche_sin_lactosa.png');
Producto prod3 = Producto('cerveza', 0.80, 'assets/mahou.jpg');
Producto prod4 = Producto('huevos', 2.60, 'assets/huevos_eco.jpg');
Producto prod5 =
    Producto('helado hägen dasz', 4.80, 'assets/helado_haagen.jpg');

// Lista contenedora de productos de Careffour
Set<Producto> _Careffour = Set<Producto>()
  ..addAll([prod1, prod2, prod3, prod4, prod5]);

Producto prod6 = Producto('pan integral', 1.30, 'assets/pan_integral.jpg');
Producto prod7 =
    Producto('leche sin lactosa', 1.30, 'assets/leche_sin_lactosa.png');
Producto prod8 = Producto('cerveza', 0.80, 'assets/mahou.jpg');
Producto prod9 = Producto('huevos', 2.40, 'assets/huevos_eco.jpg');
Producto prod10 = Producto('yogur griego', 0.60, 'assets/yogur_griego.jpg');
Producto prod11 = Producto('Arroz', 0.90, 'assets/arroz.jpg');

// Lista contenedora de productos de Ahorramás
Set<Producto> _Ahorramas = Set<Producto>()
  ..addAll([prod6, prod7, prod8, prod9, prod10, prod11]);

// CLASE PRINCIPAL CREADORA DE 'HOME'
class Pagina11 extends StatefulWidget {
  const Pagina11({
    super.key,
  });
  // creamos la ista de listas a través del método

  @override
  State<Pagina11> createState() => _Pagina11();
}

/////////////////////////////////////1 ª PARTE//////////////////////////////////////////////
// CLASE ANIMADO
class _Pagina11 extends State<Pagina11> with SingleTickerProviderStateMixin {
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
        'Listas favoritas',
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

  Widget _buildContent(conte) {
    // Indicador si se ha arrastrado y soltado algo
    bool pasadoOnaccept = false;
    List<List<Producto>> listas = _devuelve_listas_por_precio();
  
 
    //  List<Widget> lista = List.from(listaListas);

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
            _montar_contenedor(listas),
            const SizedBox(
              height: 20,
            ),
            _generarCards(listas)

        ]),
    );
  }
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////

  // Metodo constructor de contenedor de lista (ListTile)
  Widget _montar_contenedor(listas) {

  Widget wid = _generarCards(listas);

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 220, 230, 247), width: 10.0),
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(239, 237, 254, 0.898)),
      child: SizedBox(
        width: 300,
        height: 100,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 3),
          minLeadingWidth: 100.0,
          dense: false,
          onTap: () => () {},
          leading: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 70.0,
                minHeight: 70.0,
                maxWidth: 300.0,
                maxHeight: 200.0),
            child: Image.asset(
              'assets/logo_cart.png',
              width: 80.0,
              height: 80,
              alignment: Alignment.centerLeft,
              fit: BoxFit.cover,
            ),
          ),
          title: Text("Lista de compra"),
          subtitle: Text("Total productos:  ${Lista.getProductos().length}"),
          trailing: Tooltip(
            message: "Guardar lista.",
            child: OutlinedButton(
              onPressed: () =>setState(() {
               generatePDF(wid as pw.Widget);
              }),
              // MOSTRAMOS CONFIRMACIÓN DE QUE SE HA GUARDADO ..........................
              
            child: const Icon(
              Icons.summarize_rounded,
              size: 50.0,
            ),
          ),
          ),
        ),
      ),
    );
  }

  ////// Función que coge los productos de la lista de clase introducidos previamente
  /// y los busca en cada tienda para devolvernos las opciones más baratas
  ///  que en este caso se generarán 2 ya que solo tenemos datos de 2 tiendas
  /// tabien si algúnb producto se encuentra en una sola tienda se escogera directamente ese

  /// NOS TENDRÁ QUE DEVOLVER UNA LISTA DE LISTVIEWS ??????
  /// mirar Pagina7 fila 460

  List<List<Producto>> _devuelve_listas_por_precio() {
    // Objeto que nos devuelve que incluye las listas generadas en base al precio más barato
    List<List<Producto>> listasGeneradas = List.empty(growable: true);

    Lista listaCarrefour =
        Lista("Carrefour", "Resultado busqueda por criterio 'precio'");
    Lista listaAhorramas =
        Lista("Ahorramas", "Resultado busqueda por criterio 'precio'");

    // Por cada elemento de nuestra lista creada cargamos el nombre y precio
    Lista.getProductos().forEach((element) {
      
      Producto productoAhorr = Producto("",100.0,"");
      Producto productoCarr = Producto("",90.0,"");

      // se busca en la lista de productos de Carrefour
      for (Producto prod_car in _Careffour) {
        // Si se encuentra un producto con nombre similar
        if (prod_car.nombreProducto
            .toString()
            .contains(element.nombreProducto.toString())) {
          productoCarr = prod_car;
          print(
              "Se ha encontrado el producto ${element.nombreProducto} en Carrefour");
        } 
      }

      // Se pasa a buscar en la lista de productos de Ahorramas
      for (Producto prod_ahor in _Ahorramas) {
        if (prod_ahor.nombreProducto
            .toString()
            .contains(element.nombreProducto.toString())) {
          productoAhorr = prod_ahor;
          print(
              "Se ha encontrado el producto ${element.nombreProducto} en Ahorramás");
        } 
      }

      // Se comparan los precios y nos quedamos con el más barato añadiendolo a la lista correspondiente
      // Para despues mostrarla por pantalla

      if (productoAhorr.precio > productoCarr.precio) {
        listaCarrefour.aniadir_producto(productoCarr);
      } else if (productoAhorr.precio < productoCarr.precio) {
        listaAhorramas.aniadir_producto(productoAhorr);

        // Si se han encontrado en las dos tiendas y los precios son iguales
        // miramos cual de las dos tiendas tienen un numero inferior de productos
        // encontrados y lo añadimos a esa para equilibrar las cantidades
      } else if (productoAhorr.precio == productoCarr.precio) {
        if (listaAhorramas.productos.length >
            listaCarrefour.productos.length) {

          listaCarrefour.aniadir_producto(productoCarr);

        } else if (listaAhorramas.productos.length <
            listaCarrefour.productos.length) {
          listaAhorramas.aniadir_producto(productoAhorr);
        } else {
           listaCarrefour.aniadir_producto(productoCarr);
        }
      }
    });


    print(listaAhorramas.productos.toString());
    print(listaCarrefour.productos.toString());
    listasGeneradas
        .addAll([listaCarrefour.productos, listaAhorramas.productos]);

    print("Carrefour: ${listaCarrefour.productos.length}");
    print("Ahorramás: ${listaAhorramas.productos.length}");
    print(listasGeneradas.length);

    return listasGeneradas;
  }

// Widget _generarCards(List<List<Producto>> lista) {
//   List<Widget> cards = [];
//   for (int i = 0; i < lista.length; i++) {
    
//     List<Producto> productos = lista[i];

//     for (int j = 0; j < productos.length; j++) {
//       Producto producto = productos[j];
//       Widget card = Card(
//         color: Colors.amber,
//         child: Column(
          
//           children: <Widget>[
//             Text("Producto ${producto.nombreProducto}"),
//             Text("Precio: ${producto.precio.toString()} €"),
//           ],
//         ),
//       );
//       cards.add(card);
//     }
//   }
//   return Column(children: cards);
// }
  


// Widget createCard(List<Producto> productos) {
//   return Card(
//     child: ListView.builder(
//       itemCount: productos.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(productos[index].nombreProducto),
//           subtitle: Text(productos[index].descripcion),
//         );
//       },
//     ),
//   );
// }







Widget _generarCards(List<List<Producto>> lista) {
  
  
  List<Widget> cards = [];


  for (int i = 0; i < lista.length; i++) {
    List<Producto> productos = lista[i];
    var total = 0.0;
    for(Producto p in productos){

      total += p.precio;


    }


    Widget card = Card( 
        ////////////////////////////////////// TEXT PRODUCTOS TYPE (CARREFOUR / AHORRAMAS)
        color: Color.fromARGB(255, 188, 177, 144),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            
            children:
         
             productos.map((producto) =>
             
              Column(
                
                children: <Widget>[
                  Divider(),
                  Text("Producto ${producto.nombreProducto}", textAlign: TextAlign.justify, style: TextStyle(fontSize: 18, ),),
                  Text("Precio: ${producto.precio.toStringAsFixed(2)}€", style: TextStyle(fontSize: 18, ),),
                  Divider(),
                ],
              )
            ).toList(),
            
          ),
          
        ),
      );



      cards.add(Divider(height: 35.0,));
      if(i==0){
        cards.add(Text("Carrefour",style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),));
        cards.add(Text("Productos encontrados: ${productos.length}"));
        makePdf(productos);
      }else{
        cards.add(Text("Ahorramás",style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),));
        cards.add(Text("Productos encontrados: ${productos.length}",style: TextStyle(fontSize: 24, fontStyle:FontStyle.italic)));
        makePdf(productos);
     
      }

      cards.add(card);

      cards.add(Text("TOTAL: ${total.toStringAsFixed(2)}€", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),));


    
    }
     return SingleChildScrollView(
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: cards,
      ),
    ),
  );
}



// En este código, creamos un nuevo documento PDF y luego usamos el método _generaCards para generar el contenido 
//del PDF. Luego, convertimos el contenido a una lista de widgets PDF y lo agregamos a una nueva página en el documento PDF.

// Finalmente, guardamos el PDF como un archivo en el sistema de archivos local con el nombre example.pdf. 
//Debes asegurarte de especificar un nombre de archivo único y diferente cada vez que llames a la función para evitar sobrescribir archivos existentes.


Future<void> generatePDF(pw.Widget content) async {
  print("Pasamos a generar el pdf...");
  final pdf = pw.Document();
  final page = pw.Page(
    build: (context) => content,
  );
  pdf.addPage(page);
  print("Se ha añadido una pagina en el pdf...");


  // Guardamos el archivo PDF como bytes en memoria.
  final output = await pdf.save();

  // Escribimos los bytes del archivo PDF a un archivo en disco.
  final file = File('ejemplo.pdf');
  await file.writeAsBytes(output);
}


void guardaPDF( pdf){

  pdf.save();
  print("Lista guardada.");
}






Future<Uint8List> makePdf(List contenido) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Column(
           children: (contenido as List<Producto>)
            .map<pw.Row>((Producto p) => construyeFila(p))
            .toList(),
        )
],
    )
  );
  return pdf.save();
 }
    


pw.Row construyeFila(Producto producto) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: <pw.Widget>[
        pw.Text(producto.nombreProducto),
        pw.Text("${producto.precio}€"),
      ],
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
