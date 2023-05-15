import 'package:flutter/services.dart';
import 'Producto.dart';
import 'package:aplicacion_ac/controlador/flujoTexto/EscribirYLeerFichero.dart';
import 'dart:convert'; //Libreria para parsear un json
import 'base_datos.dart';
import 'dart:developer' as developer;

///Clase que sirve para tratar el json de todas las tiendas y pasarlo a una lista de productos
class TiendaJson {
  String _nombreTienda;
  List<Producto> _productos;

  TiendaJson(String nombreTienda, List<Producto> productos)
      : _nombreTienda = nombreTienda,
        _productos = productos;

  get nombreTienda => _nombreTienda;

  set nombreTienda(value) => _nombreTienda = value;

  get productos => _productos;

  set productos(value) => _productos = value;

  static Future<String> leerJSON(String nomTienda) async {
    String resultado="";
    if (nomTienda.toLowerCase() == 'ahorramas') {
      resultado= await rootBundle.loadString('assets/productosAhorramas.json');
    } else if (nomTienda.toLowerCase() == 'carrefour') {
      resultado= await rootBundle.loadString('assets/productosCarrefour.json');
    }else{
      developer.log("No ha introducido bien el nombre por parametro el parametro que ha introdudico es $nomTienda");
    }
    return resultado;
    
  }

  static Future<List<Producto>> obtenerProductosDeJson(String nomTienda) async {
    List<Producto> productoss = [];
    String contenidoJson = "no hay contenido de JSON1";
    contenidoJson = await leerJSON(nomTienda);
    Map<String, dynamic> userMap = await jsonDecode(contenidoJson);

    for (int i = 1; i < userMap.length + 1; i++) {
      print(i);
      if(Producto.userDesdeJson(userMap, i).nombreProducto == "ProductoNoExisteJSON"||  Producto.userDesdeJson(userMap, i).nombreProducto == "ProductoJSONnoTienePrecio"){
        developer.log("No existe o no tiene ningun precio el producto en el json con el id: $i ");
      }else{
        print(Producto.userDesdeJson(userMap, i));
        productoss.add(Producto.userDesdeJson(userMap, i));
      }
      
    }
    return productoss;
  }

  @override
  String toString() {
    String resultado = _nombreTienda;
    for (int i = 0; i < _productos.length; i++) {
      resultado = "\n${_productos[i]}";
    }
    return resultado;
  }

  void imprimir() {
    print(_nombreTienda);
    print(_productos);
  }
}
