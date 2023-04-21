import 'package:aplicacion_ac/vista/Producto.dart';

class Lista{

  String? _nombre;
  String? _descripcion;


  static List<Producto> lista_productos = List.empty();
  
  // Rename this constructor to use the class name as its identifier

  Lista( this._nombre, this._descripcion);
  


  get nombreLista => this._nombre;
  

  set nombreLista(value) => this._nombre= value;


  get descripcionLista => this._descripcion;
 

  set descripcionLista(value) =>  this._descripcion = value;





}
