import 'package:flutter/material.dart';
import 'package:aplicacion_ac/tratamientoTipos/TratarString.dart';


class Producto {

  late String _nombreProducto;
  late double _precio;
  late double? _peso;
  late double? _volumen;
  late String? _marca;
  late String? _categoria;
  late String _hrefProducto;
  late int _unidades;
  static late int contador=0;
  Producto({required String nombreProducto,required double precio,required String hrefImgProducto, double? peso =null, double? volumen=null, String? marca=null, String? categoria=null}):
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
    //     print("""
    // Nombre del Producto: ${ json['Producto $i']['Producto']}
    // Precio: ${json['Producto $i']['Precio']} 
    // Peso: ${json['Producto $i']['Características']['Peso Neto']} 
    // Volumen: ${json['Producto $i']['Características']['Volumen']}
    // Marca: ${json['Producto $i']['Características']['Marca']}
    // Categoria: ${json['Producto $i']['Categoria']}
    // hrefproducto: ${json['Producto $i']['Imagen']}""");
    // print("1");
    //if(json['Producto $i']!=null || json['Producto $i']['Imagen']!=null || json['Producto $i']['Precio']!=null){
    if(json['Producto $i']!=null ){
      
      if(json['Producto $i']['Producto'] !=""|| json['Producto $i']['Producto'] != null){
        _nombreProducto=json['Producto $i']['Producto'];
      }else{
        _nombreProducto="ProductoNoExisteJSON";
      }
        
      if(json['Producto $i']['Precio'] !=null){
        var variable=TratarString.quitarUnidadesEspacios(TratarString.sustituirComasPorPuntos(json['Producto $i']['Precio']))!;//Confio en que simpre se devolvera el precio en el json
        if(variable==""){
          _precio = 0.0;
          _nombreProducto="ProductoJSONnoTienePrecio";
        }else{
          _precio =variable;
        }
        
        // print("Nombre del Producto: ${ json['Producto $i']['Producto']}");
        // print("Precio: ${json['Producto $i']['Precio']}");
        // print("2");
      }else{
        _precio=0.00;
        _nombreProducto="ProductoJSONnoTienePrecio";
      }

      if(json['Producto $i']['Características'] != null){
        if(json['Producto $i']['Características']['Peso Neto']!= null){
          _peso = TratarString.quitarUnidadesEspacios(TratarString.sustituirComasPorPuntos(json['Producto $i']['Características']['Peso Neto']));
          // print("Peso: ${json['Producto $i']['Características']['Peso Neto']}");
          // print("3");
        }else{
          _peso=null;
          // print("Peso: ${json['Producto $i']['Características']['Peso Neto']}");
          // print("4");
        }

        if(json['Producto $i']['Características']['Volumen']!= null){
          // print("4");
          // print("Volumen: ${json['Producto $i']['Características']['Volumen']}");
          _volumen= TratarString.quitarUnidadesEspacios(TratarString.sustituirComasPorPuntos(json['Producto $i']['Características']['Volumen']));
        }else{
          // print("5");
          // print("Volumen: ${json['Producto $i']['Características']['Volumen']}");
          _volumen= null;
        }

          // print("6");
          // print("Marca: ${json['Producto $i']['Características']['Marca']}");
        if(json['Producto $i']['Características']['Marca']!=null){
          _marca = json['Producto $i']['Características']['Marca'];
        }else{
          _marca = null;
        }

      }else{
        // print("8");
        _peso=null;
        _volumen=null;
        _marca=null;
        // print("9");
      }
      // print("10");
      // print("Categoria: ${json['Producto $i']['Categoria']}");
      // print("hrefproducto: ${json['Producto $i']['Imagen']}");
      _categoria= json['Producto $i']['Categoria'];
      if(TratarString.detectarSiTieneRutaHttp(json['Producto $i']['Imagen'])){
        _hrefProducto= json['Producto $i']['Imagen'];
      }else{
        _hrefProducto="assets/image_producto_no_encontrada.jpg";
      }


      
      // // print("11");
    }else{
      _nombreProducto="ProductoNoExisteJSON";
      _precio=0.00;
      _hrefProducto="";
    }
    _unidades=0;

  }
  String get nombreProducto => this._nombreProducto;

  set nombreProducto(value) => this._nombreProducto = value;

  get precio => this._precio;

  set precio( value) => this._precio = value;

  get peso => this._peso;

  set peso( value) => this._peso = value;

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
     
    Producto resultado= Producto(nombreProducto: objeto['nombre'], precio: objeto['precio'], hrefImgProducto: objeto['imagen'], categoria: objeto['categoria'],marca: objeto['marca'],peso: objeto[peso],volumen: objeto['volumen']);
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
    hrefproducto: ${this.hrefProducto}""";
  }

}