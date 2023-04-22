import 'package:flutter/material.dart';

class Producto{
  String _nombreProducto;
  double _precio;
  int? _peso;
  int? _volumen;
  String? _descripcion;
  String? _marca;
  String? _categoria;
  String? _hrefProducto;
  String? _imagen;
  
  Producto(this._nombreProducto,this._precio,this._imagen);
 
get imagenProducto => this._imagen;
set imagenProducto(value) => this._imagen = value;
    
get nombreProducto => this._nombreProducto;

 set nombreProducto(value) => this._nombreProducto = value;

  get precio => this._precio;

 set precio( value) => this._precio = value;

  get peso => this._peso;

 set peso( value) => this._peso = value;

  get volumen => this._volumen;

 set volumen( value) => this._volumen = value;

  get descripcion => this._descripcion;

 set descripcion( value) => this._descripcion = value;

  get marca => this._marca;

 set marca( value) => this._marca = value;

  get categoria => this._categoria;

 set categoria( value) => this._categoria = value;

  get hrefProducto => this._hrefProducto;

 set hrefProducto( value) => this._hrefProducto = value;



  Map<String,dynamic?> toMap(){
    return {
      'nombreproducto':this._nombreProducto,
      'precio':this._precio,
      'peso':this._peso,
      'volumen':this._volumen,
      'descripcion':this._descripcion,
      'marca':this._marca,
      'categoria':this._categoria,
      'hrefProducto':this._hrefProducto,
    };
  } 

  @override
  String toString() {
    // TODO: implement toString
    return """ Nombre del Producto: ${ this._nombreProducto}
    Precio: ${this._precio} 
    Peso: ${this._peso} 
    Volumen: ${this._volumen}
    Descripcion: ${this._descripcion}
    Marca: ${this.marca}
    Categoria: ${this._categoria}
    hrefproducto: ${this.hrefProducto}""";
  }
     
}