import 'Producto.dart';
import 'package:aplicacion_ac/controlador/flujoTexto/EscribirYLeerFichero.dart';
import 'dart:convert';//Libreria para parsear un json
class Tienda{
  String _nombreTienda;
  List<Producto> _productos;

  
  Tienda(String nombreTienda, List<Producto> productos):
    _nombreTienda=nombreTienda,
    _productos= productos;
    
  get nombreTienda => _nombreTienda;

  set nombreTienda( value) => _nombreTienda = value;

  get productos => _productos;

  set productos( value) => _productos = value;

  

  static Future<List<Producto>> obtenerProductosJsonAhorraMas() async{//Es necesario ponerlo get y statico para meterlo dentro del constructor
    List<Producto> productoss=List.empty(growable: true);
    String contenidoJson="no hay contenido de JSOn1";
    EscribirYLeerFichero.leerFichero(rutaFichero: ".\\lib\\modelo\\productosAhorramas.json").then((value){
      contenidoJson=value;
      Map<String, dynamic> userMap = jsonDecode(contenidoJson);

      for(int i=1;i<userMap.length+1;i++){
        productoss.add(Producto.userDesdeJson(userMap,i));
      }
      
      });
    return productoss;
    
  }

  @override
  String toString() {
    String resultado=_nombreTienda;
    for(int i=0;i<_productos.length;i++){
      resultado="\n${_productos[i]}";
    }
    return resultado;
  }
  void imprimir(){
    print(_nombreTienda);
    print(_productos);
  }
}

