import 'package:flutter/material.dart';
import 'package:aplicacion_ac/tratamientoTipos/TratarString.dart';


class Producto implements Comparable<Producto>{
  
  late String _nombreProducto;
  late double _precio;
  double? _peso;
  double? _volumen;
  String? _marca;
  String? _categoria;
  late String _hrefProducto;
  int? _unidades;


  Producto.filtrado() :
    
    this._nombreProducto = "",
    this._precio = 0.0,
    this._hrefProducto = "",
    this._unidades = 0
  ;






  Producto({required String nombreProducto,required double precio,required String hrefProducto, double? peso =null, double? volumen=null, String? marca=null, String? categoria=null, int? unidades = null}):
  
    this._nombreProducto=nombreProducto,
    this._precio=precio,
    this._hrefProducto=hrefProducto,
    this._peso=peso,
    this._volumen=volumen,
    this._marca=marca,
    this._categoria=categoria,
    this._unidades = unidades
    ;
    

   Producto copyWith({required String nombreProducto,required double precio,
   required String hrefProducto, double? peso =null, double? volumen=null, String? marca=null, String? categoria=null, required int unidades})
  { return Producto (
    
    nombreProducto : nombreProducto ?? this._nombreProducto,
    precio : precio  ?? this._precio ,
    hrefProducto : hrefProducto  ?? this._hrefProducto,
    peso : peso  ?? this._peso ,
    volumen : volumen  ?? this._volumen ,
    marca : marca  ?? this._marca ,
    categoria : categoria  ?? this.categoria ,
    unidades : unidades  ?? this._unidades
  );

 }




  ///Funcion que es usada en la funcion obtener jSON ubicada en las crpeta JSON cada vez que se quiera leer el archivo
  Producto.userDesdeJson(Map<String, dynamic> json, int i){
      _nombreProducto=json['Producto $i']['Producto'];
      _precio = TratarString.quitarUnidadesEspacios(TratarString.sustituirComasPorPuntos(json['Producto $i']['Precio']))!;//Confio en que simpre se devolvera el precio en el json
      
      
      if(json['Producto $i']['Características']['Peso Neto']!= null){
        _peso = TratarString.quitarUnidadesEspacios(TratarString.sustituirComasPorPuntos(json['Producto $i']['Características']['Peso Neto']));
      }else{
        _peso=null;
      }
      if(json['Producto $i']['Características']['Volumen']!= null){
        _volumen= TratarString.quitarUnidadesEspacios(TratarString.sustituirComasPorPuntos(json['Producto $i']['Características']['Volumen']));
      }else{
        _volumen= null;
      }
      _marca= json['Producto $i']['Características']['Marca'];
      _categoria= json['Producto $i']['Categoria'];
      _hrefProducto= json['Producto $i']['Imagen'];
      _unidades=0;

  }
get nombreProducto => this._nombreProducto;

  set nombreProducto(value) => this._nombreProducto = value;

  get precio => this._precio;

  set precio( value) => this._precio = value;

  get peso => this._peso;

  set peso( value) => this._peso = value;

  get volumen => this._volumen;

  void set setUnidades(int value) => this._unidades = value;

  get unidades => this._unidades;

  set volumen( value) => this._volumen = value;

  get marca => this._marca;

  set marca( value) => this._marca = value;

  get categoria => this._categoria;

  set categoria( value) => this._categoria = value;

  get hrefProducto => this._hrefProducto;

  set hrefProducto( value) => this._hrefProducto = value;


  List<dynamic?> toList(){
    return [this._nombreProducto,this._precio,this._peso,this._volumen,this._marca,this._volumen,this._categoria,this._hrefProducto];

  } 

  Map<String,dynamic?> toMap(){
    return {
      'nombre':this._nombreProducto,
      'precio':this._precio,
      'categoria':this._categoria,
      'marca':this._marca,
      'volumen':this._volumen,
      'peso':this._peso,
      'imagen':this._hrefProducto,
    };
  }
  Producto.inicializandoDesdeMapa(Map<String,dynamic> productoMapa):

    _nombreProducto = productoMapa['nombre'],
    _precio = productoMapa['precio'],
    _hrefProducto = productoMapa['imagen'],
    _peso = productoMapa['peso'],
    _volumen = productoMapa['volumen'],
    _marca = productoMapa['marca'],
    _categoria = productoMapa['categoria'],
    _unidades =0;
    
    
    
  
  Producto toObjeto(Map<String,dynamic> objeto){
     
    Producto resultado= Producto(nombreProducto: objeto['nombre'], precio: objeto['precio'], hrefProducto: objeto['imagen'], categoria: objeto['categoria'],marca: objeto['marca'],peso: objeto[peso],volumen: objeto['volumen']);
    print(resultado);
    return resultado;
  }  

  @override
  String toString() {
    // TODO: implement toString
    return """
    Nombre del Producto: ${ this._nombreProducto}
    Precio: ${this._precio} 
    Peso: ${this._peso} 
    Volumen: ${this._volumen}
    Marca: ${this.marca}
    Categoria: ${this._categoria}
    Unidades: ${this._unidades}
    hrefproducto: ${this.hrefProducto}""";
  }





  
  @override
  int compareTo(Producto other) {
    if(precio>other.precio) return -1;
    if(precio<other.precio) return 1;


    return 0;
  }

}