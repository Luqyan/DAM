import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:aplicacion_ac/controlador/GestionDatosTablas.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';
import 'package:aplicacion_ac/modelo/Tienda.dart';
import 'package:path/path.dart' as path;
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'menugeneral.dart';
import 'dart:typed_data';
import 'Lista.dart';
import 'dart:io';

/// Página 11, StatefulWidget que representa una página con estado.
class Pagina11 extends StatefulWidget {
  /// Constructor de la clase Pagina11.
  const Pagina11({
    super.key,
  });

  @override
  State<Pagina11> createState() => _Pagina11();
}

/// Estado de la página 11 (_Pagina11) que extiende de State y utiliza SingleTickerProviderStateMixin.
class _Pagina11 extends State<Pagina11> with SingleTickerProviderStateMixin {
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

  /// Verifica si el drawer está abierto.
  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  /// Verifica si el drawer está abriendo.
  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  /// Verifica si el drawer está cerrado.
  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  /// Alterna la apertura/cierre del drawer.
  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  /// Construye la barra de aplicaciones preferida (AppBar).
  ///
  /// Retorna un widget de tipo PreferredSizeWidget que representa la barra de aplicaciones.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const Image(
        image: AssetImage('assets/logo4.png'),
        filterQuality: FilterQuality.high,
      ),
      title: const Text(
        'Listas generadas',
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

  // metodo creacion Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(254, 239, 188, 1),
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            _buildContent(context),
            _buildDrawer(),
          ],
        ));
  }

  /// Construye el contenido principal del widget.
  ///
  /// [conte] - El contenido del widget.
  Widget _buildContent(conte) {
    List<List<Producto>> listas = devuelve_listas_por_precio();

    return Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
      //color: Color(0xFFFAF482),
      alignment: AlignmentDirectional.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,

      child: SingleChildScrollView(
        child: Column(

            // crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _montar_contenedor(listas),
              const SizedBox(
                height: 20,
              ),
              _generarCards(listas)
            ]),
      ),
    );
  }

  /// Construye un widget de contenedor personalizado.
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
          title: const Text(
            "Lista de compra",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            "Total productos:  ${Lista.getProductos().length}",
            style: const TextStyle(fontSize: 11),
          ),
          trailing: Tooltip(
            message: "Guardar lista.",
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(100, 20, 80, 1),
                  textStyle: const TextStyle(fontSize: 10.0)),

              onPressed: () {
                generatePDF(listas);
                // openPDF();
              },
              // MOSTRAMOS CONFIRMACIÓN DE QUE SE HA GUARDADO ..........................
              label: const Text("Descarga PDF"),

              icon: const Icon(
                Icons.picture_as_pdf,
                size: 30.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Función que coge los productos de la lista de clase introducidos previamente
  /// y los busca en cada tienda para devolvernos las opciones más baratas
  ///  que en este caso se generarán 2 ya que solo tenemos datos de 2 tiendas
  /// tabien si algún producto se encuentra en una sola tienda se escogera directamente ese
  List<List<Producto>> devuelve_listas_por_precio() {
    // Objeto que nos devuelve que incluye las listas generadas en base al precio más barato
    List<List<Producto>> listasGeneradas = List.empty(growable: true);
    // Contendrán los objetos más baratos despues de compararlos entre tiendas y se mostrarán pr pantalla como resultado
    Lista listaCarrefour = Lista("Carrefour");
    Lista listaAhorramas = Lista("Ahorramas");

    List<Producto> _Carrefour = [];
    List<Producto> _Ahorramas = [];

    List<Tienda> tiendas_listas_filtradas_precio =
        GestionDatos.filtrarPorPrecio();

    for (Tienda tienda in tiendas_listas_filtradas_precio) {
      if (tienda.nombre.contains("Carrefour")) {
        _Carrefour = tienda.lista_x_busqueda;
      } else if (tienda.nombre.contains("Ahorramas")) {
        _Ahorramas = tienda.lista_x_busqueda;
      }
    }

    // Por cada elemento de nuestra lista creada cargamos el nombre y unidades
    Lista.getProductos().forEach((element) {
      Producto productoAhor = Producto.filtrado();
      Producto productoCarr = Producto.filtrado();

      // Representan los datos extraidos desde la tabla de Carrefour
      for (Producto prod_car in _Carrefour) {
        // Si se encuentra un producto con nombre similar
        if (prod_car.nombreProducto
            .toLowerCase()
            .contains(element.nombreProducto.toLowerCase())) {
          productoCarr = prod_car.copyWith(
              nombreProducto: prod_car.nombreProducto,
              precio: prod_car.precio,
              hrefProducto: prod_car.hrefProducto,
              unidades: element.unidades);
          break;
        }
      }

      // Representan los datos extraidos desde la tabla de Ahorramas
      for (Producto prod_ahor in _Ahorramas) {
        if (prod_ahor.nombreProducto
            .toLowerCase()
            .contains(element.nombreProducto.toLowerCase())) {
          productoAhor = prod_ahor.copyWith(
              nombreProducto: prod_ahor.nombreProducto,
              precio: prod_ahor.precio,
              hrefProducto: prod_ahor.hrefProducto,
              unidades: element.unidades);
          break;
        }
      }

      // Se comparan los precios y nos quedamos con el más barato añadiendolo a la lista correspondiente
      // Para despues mostrarla por pantalla

      if ((productoCarr.precio == 0) && (productoAhor.precio == 0)) {
      } else if (productoCarr.precio == 0) {
        listaAhorramas.aniadir_producto(productoAhor);
      } else if (productoAhor.precio == 0) {
        listaCarrefour.aniadir_producto(productoCarr);
      } else if (productoAhor.precio > productoCarr.precio) {
        listaCarrefour.aniadir_producto(productoCarr);
      } else if (productoAhor.precio < productoCarr.precio) {
        listaAhorramas.aniadir_producto(productoAhor);

        // Si se han encontrado en las dos tiendas y los precios son iguales
        // miramos cual de las dos tiendas tienen un numero inferior de productos
        // encontrados y lo añadimos a esa para equilibrar las cantidades
      } else if (productoAhor.precio == productoCarr.precio) {
        if (listaAhorramas.productos.length > listaCarrefour.productos.length) {
          listaCarrefour.aniadir_producto(productoCarr);
        } else if (listaAhorramas.productos.length <
            listaCarrefour.productos.length) {
          listaAhorramas.aniadir_producto(productoAhor);
        } else if (listaAhorramas.productos.length ==
            listaCarrefour.productos.length) {
          listaCarrefour.aniadir_producto(productoCarr);
        }
      }
    });

    listasGeneradas
        .addAll([listaCarrefour.productos, listaAhorramas.productos]);

    // Borrar contenido de la lista de productos buscados
    Lista.getProductos().clear();

    return listasGeneradas;
  }

  /// Genera una lista de tarjetas (cards) a partir de una lista de listas de productos.
  Widget _generarCards(List<List<Producto>> lista) {
    List<Widget> cards = [];

    for (int i = 0; i < lista.length; i++) {
      List<Producto> productos = lista[i];
      var total = 0.0;

      // Calcular el total sumando el precio de cada producto multiplicado por las unidades
      for (Producto p in productos) {
        total += p.precio * p.unidades;
      }

      Widget card = Card(
        color: const Color.fromARGB(255, 153, 224, 199),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: productos
                .map(
                  (producto) => Column(
                    children: <Widget>[
                      const Divider(),
                      Text(
                        producto.nombreProducto,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Precio: ${(producto.unidades * producto.precio).toStringAsFixed(2)}Eu",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "Unidades: ${producto.unidades.toString()}",
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                        ),
                      ),
                      const Divider(),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      );

      cards.add(const Divider(
        height: 35.0,
        thickness: 3.0,
      ));

      // Agregar el encabezado dependiendo del índice (Carrefour o Ahorramás)
      if (i == 0) {
        cards.add(const Text(
          "Carrefour",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ));
        cards.add(Text("Productos encontrados: ${productos.length}",
            style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic)));
      } else {
        cards.add(const Text(
          "Ahorramás",
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ));
        cards.add(Text("Productos encontrados: ${productos.length}",
            style: const TextStyle(fontSize: 24, fontStyle: FontStyle.italic)));
      }

      cards.add(card);

      // Agregar el total al final de la tarjeta
      cards.add(Text(
        "TOTAL: ${total.toStringAsFixed(2)}Eu",
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        textAlign: TextAlign.right,
      ));

      cards.add(const Divider(
        height: 35.0,
        thickness: 3.0,
      ));
    }

    return Container(
      child: Column(
        children: cards,
      ),
    );
  }

  /// Genera un archivo PDF a partir de una lista de listas de productos y lo guarda en el directorio de descargas del dispositivo.
  Future<void> generatePDF(List<List<Producto>> lista) async {
    // Generar el contenido del PDF
    final Uint8List pdfBytes = await makePdf(lista);

    // Obtener el directorio de descargas
    String? downloadsDirectoryPath =
        (await DownloadsPath.downloadsDirectory())?.path;

    // Construir la ruta y el nombre de archivo del PDF
    final filePath = path.join(downloadsDirectoryPath!, 'lista_compra.pdf');
    final file = File(filePath);

    // Verificar y solicitar permisos de almacenamiento
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (!status.isGranted) {
        return;
      }
    }

    // Escribir el archivo PDF
    await file.writeAsBytes(pdfBytes);
  }

// Future<void> generatePDF(List<List<Producto>> lista) async {
//     print("Pasamos a generar el pdf...");

//     final pdf = pw.Document();
//     final Uint8List pdfBytes = await makePdf(lista);

//     final downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;

//     final directory = await getApplicationDocumentsDirectory();
//     final filePath = path.join(downloadsDirectory!.path, 'lista_compra.pdf');
//     final file = File(filePath);
//     await file.writeAsBytes(await pdfBytes);

//     print('Archivo PDF generado en: $filePath');
//   }

  /// Genera un documento PDF a partir de una lista de listas de productos.
  Future<Uint8List> makePdf(List<List<Producto>> lista) async {
    List<String> nombresTiendas = ["Carrefour", "Ahorramas"];
    final pdf = pw.Document();

    for (int i = 0; i < lista.length; i++) {
      List<Producto> productos = lista[i];
      var total = 0.0;

      for (Producto producto in productos) {
        total += producto.precio;
      }

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            List<pw.Widget> cards = [];

            cards.add(pw.Text("Tienda: ${nombresTiendas[i]}",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 28,
                )));
            cards.add(pw.Text(
              "Productos encontrados: ${productos.length}",
            ));

            for (Producto producto in productos) {
              cards.add(pw.Text(
                producto.nombreProducto,
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(fontSize: 18),
              ));
              cards.add(pw.Text(
                "Precio: ${producto.precio.toStringAsFixed(2)}",
                style: const pw.TextStyle(fontSize: 18),
              ));
              cards.add(pw.Text(
                "Unidades: ${producto.unidades.toStringAsFixed(2)}",
                style: const pw.TextStyle(fontSize: 18),
              ));
              cards.add(pw.Divider());
            }

            cards.add(pw.Text("TOTAL: ${total.toStringAsFixed(2)}Eu",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                )));

            return pw.Container(
              child: pw.Column(children: cards),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

// Metodo para visualizar el PDF por pantalla en una ventana aparte
// Future<void> openPDF() async {
//   final directory = await getApplicationDocumentsDirectory();
//   final filePath = path.join(directory.path, 'lista_compra.pdf');
//   final file = File(filePath);

//   // Verificar si el archivo existe antes de intentar abrirlo
//   if (await file.exists()) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PDFView(
//           filePath: filePath,
//           enableSwipe: true,
//         ),
//       ),
//     );
//   } else {
//     print('El archivo PDF no existe');
//   }
// }

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
