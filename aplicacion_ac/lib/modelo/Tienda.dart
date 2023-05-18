import 'package:aplicacion_ac/controlador/GestionDatosTablas.dart';

import '../vista/Lista.dart';
import 'Producto.dart';
import 'dart:developer'as developer;
class Tienda{

  late final String nombre;
  bool clickado = false;
  final String imagen;
  final String tipoClase = "Tienda";
  /// Lista que abarca cada objeto creado por cada tabla existente en la BD
  /// Lista de objetos de clase Lista generadas por cada tabla en base al dato introducido durante la busqueda (pag 7)
  /// Este objeto contiene la lista de productos generada dentro del atributo de clase _productos
  static List<Tienda> _listas_generadas_busqueda = List.empty(growable: true);
  

  /// Lista de listas de productos usada por cada filtrado 
  List<List<Producto>> _listasProductosAnadidos = new List.empty(growable: true);




  /// Constructor usado en la creacion de cada objeto Tienda por cada tabla de la BD
  Tienda.tabla({required nombre, this.imagen =""});

  Tienda({required this.nombre, this.clickado = false, required this.imagen});
    
  
  

  static List<Tienda> get obtenerTiendas => _listas_generadas_busqueda;
  
  //TODO:Ver si esta función es necesaria ya que la funión generarTiendas ya genera todas las tiendas, por lo que no es necesario un set de tiendas
  static void aniadir_lista_resultado(Tienda tienda) =>
      _listas_generadas_busqueda.add(tienda);



  
   

  List<dynamic> get listas => _listasProductosAnadidos;

  void addLista(List<Producto> mismosProductos) {
    _listasProductosAnadidos.add(mismosProductos);
  }

  //set imgTienda(value) => this.imagenTienda = value;

  get img => imagen;

/// Especie de set para la Lis<Producto> del atributo _listasProductosAnadidos
/// añade un grupo de productos o un producto a una tienda expecifica
/// Atributos:
/// - tienda : es la tienda donde se insertará los productos o producto
/// - productosAnadir : son los los productos que se añadiran a la tienda
  static bool anadirproductoOproductosATienda(String tienda,List<Producto> productosAnadir){
    bool resultado=false;
    for(int i=0; i<_listas_generadas_busqueda.length;i++){
      if(_listas_generadas_busqueda[i].nombre==tienda){
        _listas_generadas_busqueda[i]._listasProductosAnadidos.add(productosAnadir);
        resultado = true;
      }else{
        developer.log("No existe ninguna tienda con el nombre $tienda | funcion: anadirproductoOproductosATienda");
        resultado = false;
      }
    }
    return resultado;
    
  }

  void generarTiendas() async {
    _listas_generadas_busqueda=await GestionDatos.devuelveTiendas();
  }


  @override
    String toString() {
      // TODO: implement toString
      return tipoClase;
    }

}