import 'package:flutter/material.dart';
import 'package:aplicacion_ac/tratamientoTipos/TratarString.dart';


class Producto {
  late int _id;
  late String _nombreProducto;
  late double _precio;
  late double? _peso;
  late double? _volumen;
  late String? _marca;
  late String? _categoria;
  late String _hrefProducto;
  late int _unidades;
  Producto({required int id, required String nombreProducto,required double precio,required String hrefImgProducto, double? peso =null, double? volumen=null, String? marca=null, String? categoria=null}):
    this._id = id,
    this._nombreProducto=nombreProducto,
    this._precio=precio,
    this._hrefProducto=hrefImgProducto,
    this._peso=peso,
    this._volumen=volumen,
    this._marca=marca,
    this._categoria=categoria,
    this._unidades=0
    ;
    


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

  }
get nombreProducto => this._nombreProducto;

  set nombreProducto(value) => this._nombreProducto = value;

  get precio => this._precio;

  set precio( value) => this._precio = value;

  get peso => this._peso;

  set peso( value) => this._peso = value;

  get id => this._id;

  set id( value) => this._id = value;

  get volumen => this._volumen;

  set unidades( value) => this._unidades = value;

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

  @override
  String toString() {
    // TODO: implement toString
    return """ 
    ID: ${this._id}
    Nombre del Producto: ${ this._nombreProducto}
    Precio: ${this._precio} 
    Peso: ${this._peso} 
    Volumen: ${this._volumen}
    Marca: ${this.marca}
    Categoria: ${this._categoria}
    hrefproducto: ${this.hrefProducto}""";
  }

}