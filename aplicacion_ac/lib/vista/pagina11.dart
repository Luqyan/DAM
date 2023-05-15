import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'Lista.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';
import 'pagina1.dart';
import 'menugeneral.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

/////////////////// MIRAR POR QUE NO FUNCIONAN LOS SETTERS DE LA CLASE /////////////////////

Producto prod1 = Producto(nombreProducto: 'pan integral', precio: 1.60, hrefProducto: 'assets/pan_integral.jpg', unidades: 0);
Producto prod2 =
    Producto(nombreProducto:'leche sin lactosa',precio: 1.20, hrefProducto: 'assets/leche_sin_lactosa.png');
Producto prod3 = Producto(nombreProducto:'cerveza',precio: 0.80,hrefProducto:  'assets/mahou.jpg');
Producto prod4 = Producto(nombreProducto:'huevos',precio: 2.60,hrefProducto:  'assets/huevos_eco.jpg');
Producto prod5 =
    Producto(nombreProducto:'helado hägen dasz',precio: 4.80,hrefProducto:  'assets/helado_haagen.jpg');

// Lista contenedora de productos de Careffour
Set<Producto> _Careffour = Set<Producto>()
  ..addAll([prod1, prod2, prod3, prod4, prod5]);

Producto prod6 = Producto(nombreProducto:'pan integral',precio:1.30,hrefProducto:  'assets/pan_integral.jpg');
Producto prod7 =
    Producto(nombreProducto:'leche sin lactosa',precio: 1.30, hrefProducto: 'assets/leche_sin_lactosa.png');
Producto prod8 = Producto(nombreProducto:'cerveza',precio: 0.80, hrefProducto: 'assets/mahou.jpg');
Producto prod9 = Producto(nombreProducto:'huevos', precio:2.40, hrefProducto: 'assets/huevos_eco.jpg');
Producto prod10 = Producto(nombreProducto:'yogur griego',precio: 0.60,hrefProducto:  'assets/yogur_griego.jpg');
Producto prod11 = Producto(nombreProducto:'Arroz',precio: 0.90, hrefProducto: 'assets/arroz.jpg');
Producto prod12 = Producto(nombreProducto: 'pan', precio: 1.10, hrefProducto: 'assets/pan.jpg');

// Lista contenedora de productos de Ahorramás
Set<Producto> _Ahorramas = Set<Producto>()
  ..addAll([prod6, prod7, prod8, prod9, prod10, prod11, prod12]);

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
      body: SingleChildScrollView(
        child: Stack(
          
          children: [
            _buildContent(context),
            _buildDrawer(),
          ],
        ),
      ),
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////
////////////////////// método de creación de appBar personalizado/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const Image(image: 
        AssetImage('assets/logo4.png'),
        filterQuality: FilterQuality.high,
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
    List<List<Producto>> listas = devuelve_listas_por_precio();
  
    return Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
      //color: Color(0xFFFAF482),
      alignment: AlignmentDirectional.center,
      width: MediaQuery.of(context).size.width,
      //height: MediaQuery.of(context).size.height,
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


    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromARGB(255, 220, 230, 247), width: 4.0),
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromRGBO(239, 237, 254, 0.898)),
      
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: ListTile(
            visualDensity: const VisualDensity(vertical: 3),
            minLeadingWidth: 70.0,
            dense: false,
          
            leading: ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: 50.0,
                  minHeight: 50.0,
                  maxWidth: 200.0,
                  maxHeight: 200.0),
              child: Image.asset(
                'assets/logo_cart.png',
                width: 60.0,
                height: 60.0,
                alignment: Alignment.center,
                fit: BoxFit.cover,
              ),
            ),
            
            title: Text("Lista de compra", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),),

            subtitle: Text("Total productos:  ${Lista.getProductos().length}", style: TextStyle(fontSize: 11),),
      
            trailing: Tooltip(
              
              message: "Guardar lista.",

              child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  
                  backgroundColor: Color.fromARGB(100, 20, 80, 1 ),
                  textStyle: TextStyle(fontSize: 10.0)
      
              ),
               
                onPressed: () =>setState(() {
                 generatePDF(listas);
                }),
                // MOSTRAMOS CONFIRMACIÓN DE QUE SE HA GUARDADO ..........................
                label: Text("Descarga PDF"),
             
                icon: Icon(Icons.picture_as_pdf,
                size: 30.0,
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

  List<List<Producto>> devuelve_listas_por_precio() {
    // Objeto que nos devuelve que incluye las listas generadas en base al precio más barato
    List<List<Producto>> listasGeneradas = List.empty(growable: true);

    Lista listaCarrefour =
        Lista("Carrefour", "Resultado busqueda por criterio 'precio'");
    Lista listaAhorramas =
        Lista("Ahorramas", "Resultado busqueda por criterio 'precio'");

    // Por cada elemento de nuestra lista creada cargamos el nombre, precio y unidades
    Lista.getProductos().forEach((element) {
      
      Producto productoAhor = Producto.filtrado();
      Producto productoCarr = Producto.filtrado();
      
      // se busca en la lista de productos de Carrefour
      
      
    
      // Representan los datos extraidos desde la tabla de Carrefour
      for (Producto prod_car in _Careffour) {

        // Si se encuentra un producto con nombre similar
        if (prod_car.nombreProducto
            .toString()
            .contains(element.nombreProducto.toString())) {
          productoCarr = prod_car.copyWith(nombreProducto: prod_car.nombreProducto, precio: prod_car.precio, hrefProducto: prod_car.hrefProducto, unidades: element.unidades);
            print(
              "Se ha encontrado el producto ${element.nombreProducto} en Carrefour");
              break;
        } 
      }

      // Representan los datos extraidos desde la tabla de Ahorramas
      for (Producto prod_ahor in _Ahorramas) {
        if (prod_ahor.nombreProducto
            .toString()
            .contains(element.nombreProducto.toString())) {
          productoAhor = prod_ahor.copyWith(nombreProducto: prod_ahor.nombreProducto, precio: prod_ahor.precio, hrefProducto: prod_ahor.hrefProducto, unidades: element.unidades);
          print(
              "Se ha encontrado el producto ${element.nombreProducto} en Ahorramás");
              break;
        } 
      }

      // Se comparan los precios y nos quedamos con el más barato añadiendolo a la lista correspondiente
      // Para despues mostrarla por pantalla

      if((productoCarr.precio == 0) && (productoAhor.precio == 0)){
        
          print("No se ha encontrado el objeto ${element.nombreProducto}");
      }

      else if(productoCarr.precio == 0){
      
      listaAhorramas.aniadir_producto(productoAhor);
      }else if(productoAhor.precio == 0) {
      
      listaCarrefour.aniadir_producto(productoCarr);
      }      else if (productoAhor.precio > productoCarr.precio) {
        listaCarrefour.aniadir_producto(productoCarr);
      } else if (productoAhor.precio < productoCarr.precio) {
        listaAhorramas.aniadir_producto(productoAhor);

        // Si se han encontrado en las dos tiendas y los precios son iguales
        // miramos cual de las dos tiendas tienen un numero inferior de productos
        // encontrados y lo añadimos a esa para equilibrar las cantidades
      } else if (productoAhor.precio == productoCarr.precio) {
        if (listaAhorramas.productos.length >
            listaCarrefour.productos.length) {

          listaCarrefour.aniadir_producto(productoCarr);

        } else if ( listaAhorramas.productos.length <
            listaCarrefour.productos.length ) {
          listaAhorramas.aniadir_producto(productoAhor);
        } else if ( listaAhorramas.productos.length ==
            listaCarrefour.productos.length ){
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

    // Borrar contenido de la lista de productos buscados
    Lista.getProductos().clear();

    return listasGeneradas;
  }


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
                  Text("Unidades: ${producto.unidades.toString()}", style: TextStyle(fontSize: 18, ),),
                  Divider(),

                ],
              ),
            ).toList(),
            
          ),
          
        ),
      );



      cards.add(Divider(height: 35.0, thickness: 3.0,));
      if(i==0){
        cards.add(Text("Carrefour",style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),));
        cards.add(Text("Productos encontrados: ${productos.length}",style: TextStyle(fontSize: 24, fontStyle:FontStyle.italic)));
        makePdf(productos);

      }else{
        cards.add(Text("Ahorramás",style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),));
        cards.add(Text("Productos encontrados: ${productos.length}",style: TextStyle(fontSize: 24, fontStyle:FontStyle.italic)));
        makePdf(productos);

      }

      cards.add(card);

      cards.add(Text("TOTAL: ${total.toStringAsFixed(2)}Eu", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),textAlign: TextAlign.right,));

       cards.add(Divider(height: 35.0,thickness: 3.0,));

    }

     return(Container( 

      child: 
        Column(
          children: cards,
        )
       )
     
     );
     
     
      
  
}



// En este código, creamos un nuevo documento PDF y luego usamos el método _generaCards para generar el contenido 
//del PDF. Luego, convertimos el contenido a una lista de widgets PDF y lo agregamos a una nueva página en el documento PDF.

// Finalmente, guardamos el PDF como un archivo en el sistema de archivos local con el nombre example.pdf. 
//Debes asegurarte de especificar un nombre de archivo único y diferente cada vez que llames a la función para evitar sobrescribir archivos existentes.


Future<void> generatePDF(List<List<Producto>> lista) async {
  print("Pasamos a generar el pdf...");
  
  
  final pdf = pw.Document();

 

  pw.Container contenedor = await _generarContenido(lista);

  final page = pw.Page (
    build: (pw.Context context) => contenedor,
  
  );
  
  pdf.addPage(page);
  print("Se ha añadido una pagina en el pdf...");

  final file = File("lista_compra.pdf");
  await file.writeAsBytes(await pdf.save());

  final absoluta = await getApplicationDocumentsDirectory();

  print(absoluta);
  final output = await getTemporaryDirectory();

  print(output);
  // Escribimos los bytes del archivo PDF a un archivo en disco.
  // final file = File(output+"/lista.pdf");
  // await file.writeAsBytes( await pdf.save());
  
  
}


pw.Container _generarContenido(List<List<Producto>> lista) {


  List<pw.Widget> cards = [];


  for (int i = 0; i < lista.length; i++) {
    List<Producto> productos = lista[i];
    var total = 0.0;
    for(Producto p in productos){

      total += p.precio;

    }


    pw.Widget card = pw.Column(
        ////////////////////////////////////// TEXT PRODUCTOS TYPE (CARREFOUR / AHORRAMAS)
       
        children: [ pw.SizedBox(
          width: MediaQuery.of(context).size.width,
          child: pw.Column(
            
            children:

             productos.map((producto) =>
             
              pw.Column(
                
                children: <pw.Widget>[
                  pw.Divider(),
                  pw.Text("Producto ${producto.nombreProducto}", textAlign: pw.TextAlign.justify, style: pw.TextStyle(fontSize: 18, ),),
                  pw.Text("Precio: ${producto.precio.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 18, ),),
                  pw.Divider(),

                ],
              ),
            ).toList(),
            
          ),
          
        ),
        ]
      );



      cards.add(pw.Divider(height: 35.0, thickness: 3.0,));
      if(i==0){
        cards.add(pw.Text("Carrefour"));
        cards.add(pw.Text("Productos encontrados: ${productos.length}"));
        makePdf(productos);

      }else{
        cards.add(pw.Text("Ahorramás"));
        cards.add(pw.Text("Productos encontrados: ${productos.length}"));
        makePdf(productos);

      }

      cards.add(card);

      cards.add(pw.Text("TOTAL: ${total.toStringAsFixed(2)}Eu"));

       cards.add(pw.Divider(height: 35.0,thickness: 3.0,));

    }

    return(pw.Container( 

      child: 
        pw.Column(
          children: cards,
        )
       )
     
     );
     
     
      
  
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
        pw.Text("${producto.precio}Eu"),
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
