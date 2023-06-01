import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import 'Producto.dart';
import 'dart:convert';

///Clase que sirve para tratar el json de todas las tiendas y pasarlo a una lista de productos
class TiendaJson {
  String _nombreTienda;
  List<Producto> _productos;
  String _imagen;

  /// El constructor [TiendaJson] crea una instancia de la clase [TiendaJson] con los valores proporcionados para cada atributo.
  ///
  /// Recibe como argumentos el nombre de la tienda, la imagen de la tienda y una lista de productos.
  TiendaJson(String nombreTienda, String imagen, List<Producto> productos)
      : _nombreTienda = nombreTienda,
        _imagen = imagen,
        _productos = productos;

  get nombreTienda => _nombreTienda;

  set nombreTienda(value) => _nombreTienda = value;

  get productos => _productos;

  set productos(value) => _productos = value;

  /// El método estático [obtenerProductosDeJson] obtiene una lista de productos a partir de un archivo JSON.
  ///
  /// Recibe el nombre de la tienda como argumento y devuelve una lista de productos obtenidos del archivo JSON correspondiente a la tienda.
  static Future<String> leerJSON(String nomTienda) async {
    String resultado = "";
    if (nomTienda.toLowerCase() == 'ahorramas') {
      resultado = await rootBundle.loadString('assets/productosAhorramas.json');
    } else if (nomTienda.toLowerCase() == 'carrefour') {
      resultado = await rootBundle.loadString('assets/productosCarrefour.json');
    } else {
      developer.log(
          "No ha introducido bien el nombre por parametro el parametro que ha introdudico es $nomTienda");
    }
    return resultado;
  }

  /// El método estático [obtenerProductosDeJson()] obtiene una lista de productos a partir de un archivo JSON.
  ///
  /// Recibe el nombre de la tienda como argumento y devuelve una lista de productos obtenidos del archivo JSON correspondiente a la tienda.
  static Future<List<Producto>> obtenerProductosDeJson(String nomTienda) async {
    List<Producto> productoss = [];
    String contenidoJson = "no hay contenido de JSON1";
    contenidoJson = await leerJSON(nomTienda);
    Map<String, dynamic> userMap = await jsonDecode(contenidoJson);

    for (int i = 1; i < userMap.length + 1; i++) {
      if (Producto.productoDesdeJson(userMap, i).nombreProducto ==
              "ProductoNoExisteJSON" ||
          Producto.productoDesdeJson(userMap, i).nombreProducto ==
              "ProductoJSONnoTienePrecio") {
        developer.log(
            "No existe o no tiene ningun precio el producto en el json con el id: $i ");
      } else {
        productoss.add(Producto.productoDesdeJson(userMap, i));
      }
    }
    return productoss;
  }

  /// El método [toMapParaBD] devuelve un mapa que representa los atributos de la tienda para su almacenamiento en una base de datos.
  ///
  /// El mapa resultante contiene las claves [nombre] e [imagen], con sus respectivos valores de la tienda.
  Map<String, dynamic> toMapParaBD() {
    return {
      'nombre': _nombreTienda,
      'imagen': _imagen,
    };
  }

  /// La anotación [@override] indica que el método [toString] está sobrescribiendo el método de la clase padre [Object].
  ///
  /// El método [toString] devuelve una representación en forma de cadena del objeto [Tienda] y sus productos.
  @override
  String toString() {
    String resultado = _nombreTienda;
    for (int i = 0; i < _productos.length; i++) {
      resultado = "\n${_productos[i]}";
    }
    return resultado;
  }

  void imprimir() {}
}
