import 'package:aplicacion_ac/controlador/GestionDatosTablas.dart';
import 'dart:developer' as developer;
import 'Producto.dart';


class Tienda {
  final String nombre;
  bool clickado = false;
  final String imagen;
  final String tipoClase = "Tienda";

  /// Lista que abarca cada objeto creado por cada tabla existente en la BD
  /// Lista de objetos de clase Lista generadas por cada tabla en base al dato introducido durante la busqueda (pag 7)
  /// Este objeto contiene la lista de productos generada dentro del atributo de clase _productos
  static List<Tienda> _listas_generadas_busqueda = List.empty(growable: true);

  // Lista con el resultado generado en cada busqueda utilizada antes de añadir a cesta el producto
  List<Producto> lista_x_busqueda = List.empty(growable: true);

  List<Producto> get lista_busqueda => lista_x_busqueda;

  void _aniadir_prod_tienda(Producto prod) => lista_x_busqueda.add(prod);

  /// Lista de listas de productos usada por cada filtrado
  List<List<Producto>> _listasProductosAnadidos =
      List.empty(growable: true);

  /// Constructor usado en la creacion de cada objeto Tienda por cada tabla de la BD
  Tienda.tabla({required nombre, imagen = ""})
      : nombre = nombre,
        imagen = imagen;

  Tienda({required this.nombre, this.clickado = false, required this.imagen});

  static List<Tienda> get obtenerTiendas => _listas_generadas_busqueda;

  List<dynamic> get listas => _listasProductosAnadidos;

  void addLista(List<Producto> mismosProductos) {
    _listasProductosAnadidos.add(mismosProductos);
  }

  //set imgTienda(value) => this.imagenTienda = value;

  get img => imagen;

  /// Especie de set para la List <Producto> del atributo _listasProductosAnadidos
  /// añade un grupo de productos o un producto a una tienda expecifica
  /// Atributos:
  /// - tienda : es la tienda donde se insertará los productos o producto
  /// - productosAnadir : son los los productos que se añadiran a la tienda
  static bool anadirproductoOproductosATienda(
      String tienda, List<Producto> productosAnadir) {
    bool resultado = false;
    for (int i = 0; i < _listas_generadas_busqueda.length; i++) {
      if (_listas_generadas_busqueda[i].nombre == tienda) {
        _listas_generadas_busqueda[i]
            ._listasProductosAnadidos
            .add(productosAnadir);
        if (productosAnadir.length > 0) {
          return resultado = true; //Si se cumple la condición sale del bucle
        }
      }
    }
    developer.log(
        "No existe ninguna tienda con el nombre $tienda | funcion: anadirproductoOproductosATienda");
    return resultado;
  }

  /// Creador de todas las tiendas, en base a los nombres de las tablas de la BD
  static Future<void> generarTiendas() async {
    _listas_generadas_busqueda = await GestionDatos.devuelveTiendas();
    print(_listas_generadas_busqueda.length);
  }

  @override
  String toString() {
  
    return tipoClase;
  }
}
