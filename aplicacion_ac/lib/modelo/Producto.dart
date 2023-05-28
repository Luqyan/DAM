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
    
    _nombreProducto = "",
    _precio = 0.0,
    _hrefProducto = "",
    _unidades = 0
  ;






  Producto({required String nombreProducto,required double precio,required String hrefProducto, double? peso, double? volumen, String? marca, String? categoria, int? unidades}):
  
    _nombreProducto=nombreProducto,
    _precio=precio,
    _hrefProducto=hrefProducto,
    _peso=peso,
    _volumen=volumen,
    _marca=marca,
    _categoria=categoria,
    _unidades = unidades
    ;
  

   Producto copyWith({required String nombreProducto,required double precio,
   required String hrefProducto, double? peso, double? volumen, String? marca, String? categoria, required int unidades})
  { return Producto (
    
    nombreProducto : nombreProducto,
    precio : precio ,
    hrefProducto : hrefProducto,
    peso : peso  ?? _peso ,
    volumen : volumen  ?? _volumen ,
    marca : marca  ?? _marca ,
    categoria : categoria  ?? this.categoria ,
    unidades : unidades
  );

 }




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
        // print("9");s
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
  String get nombreProducto => _nombreProducto;

  void nombre(value) { _nombreProducto = value; }

  get precio => _precio;

  set precio( value) => _precio = value;

  get peso => _peso;

  set peso(value) => _peso = value;

  get volumen => _volumen;

  set setUnidades(int value) => _unidades = value;

  get unidades => _unidades;

  set volumen( value) => _volumen = value;

  get marca => _marca;

  set marca( value) => _marca = value;

  get categoria => _categoria;

  set categoria( value) => _categoria = value;

  get hrefProducto => _hrefProducto;

  void imagen(value) { _hrefProducto = value;}


  List<dynamic> toList(){
    return [_nombreProducto,_precio,_peso,_volumen,_marca,_volumen,_categoria,_hrefProducto];

  } 

  Map<String,dynamic> toMap(){
    return {
      'nombre':_nombreProducto,
      'precio':_precio,
      'categoria':_categoria,
      'marca':_marca,
      'volumen':_volumen,
      'peso':_peso,
      'imagen':_hrefProducto,
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
    return resultado;
  }  

  @override
  String toString() {
    
    return """
    Nombre del Producto: $_nombreProducto
    Precio: $_precio 
    Peso: $_peso 
    Volumen: $_volumen
    Marca: $marca
    Categoria: $_categoria
    Unidades: $_unidades
    hrefproducto: $hrefProducto""";
  }





  
  @override
  int compareTo(Producto other) {
    if(precio>other.precio) return -1;
    if(precio<other.precio) return 1;


    return 0;
  }

}