import 'package:aplicacion_ac/tratamientoTipos/TratarString.dart';

class Producto implements Comparable<Producto> {
  late String _nombreProducto;
  late double _precio;
  double? _peso;
  double? _volumen;
  String? _marca;
  String? _categoria;
  late String _hrefProducto;
  int? _unidades;

  /// El constructor [Producto.filtrado] crea una instancia de la clase [Producto] con valores predeterminados para los atributos.
  ///
  /// Este constructor se utiliza para crear un objeto [Producto] que se utiliza en el proceso de filtrado, donde se establecen valores iniciales vacíos o nulos para los atributos relevantes.
  Producto.filtrado()
      : _nombreProducto = "",
        _precio = 0.0,
        _hrefProducto = "",
        _unidades = 0;

  /// El constructor [Producto] crea una instancia de la clase [Producto] con los valores proporcionados para cada atributo.
  ///
  /// Recibe como argumentos los valores iniciales de los atributos requeridos, y los valores opcionales para los atributos no requeridos.
  Producto(
      {required String nombreProducto,
      required double precio,
      required String hrefProducto,
      double? peso,
      double? volumen,
      String? marca,
      String? categoria,
      int? unidades})
      : _nombreProducto = nombreProducto,
        _precio = precio,
        _hrefProducto = hrefProducto,
        _peso = peso,
        _volumen = volumen,
        _marca = marca,
        _categoria = categoria,
        _unidades = unidades;

  /// El método [copyWith] crea una copia modificada del objeto [Producto] actual, con la posibilidad de actualizar algunos de sus atributos.
  ///
  /// Recibe como argumentos los nuevos valores de los atributos que se desean modificar, y retorna un nuevo objeto [Producto] con los atributos actualizados.
  /// Los atributos que no se especifiquen en los argumentos mantendrán su valor original.
  Producto copyWith(
      {required String nombreProducto,
      required double precio,
      required String hrefProducto,
      double? peso,
      double? volumen,
      String? marca,
      String? categoria,
      required int unidades}) {
    return Producto(
        nombreProducto: nombreProducto,
        precio: precio,
        hrefProducto: hrefProducto,
        peso: peso ?? _peso,
        volumen: volumen ?? _volumen,
        marca: marca ?? _marca,
        categoria: categoria ?? this.categoria,
        unidades: unidades);
  }

  /// El método [productoDesdeJson] crea un objeto [Producto] a partir de un mapa [json] que contiene los datos del producto en formato JSON.
  ///
  /// Recibe como argumentos el mapa [json] y un entero [i] que indica el índice del producto en el JSON.
  ///
  /// Este método se utiliza para deserializar el JSON y asignar los valores correspondientes a los atributos del producto.
  Producto.productoDesdeJson(Map<String, dynamic> json, int i) {
    if (json['Producto $i'] != null) {
      if (json['Producto $i']['Producto'] != "" &&
          json['Producto $i']['Producto'] != null) {
        _nombreProducto = json['Producto $i']['Producto'];
      } else {
        _nombreProducto = "ProductoNoExisteJSON";
      }

      if (json['Producto $i']['Precio'] != null) {
        var variable = TratarString.quitarUnidadesEspacios(
            TratarString.sustituirComasPorPuntos(json['Producto $i'][
                'Precio']))!; //Confio en que simpre se devolvera el precio en el json
        if (variable == "") {
          _precio = 0.0;
          _nombreProducto = "ProductoJSONnoTienePrecio";
        } else {
          _precio = variable;
        }
      } else {
        _precio = 0.00;
        _nombreProducto = "ProductoJSONnoTienePrecio";
      }

      if (json['Producto $i']['Características'] != null) {
        if (json['Producto $i']['Características']['Peso Neto'] != null) {
          _peso = TratarString.quitarUnidadesEspacios(
              TratarString.sustituirComasPorPuntos(
                  json['Producto $i']['Características']['Peso Neto']));
        } else {
          _peso = null;
        }

        if (json['Producto $i']['Características']['Volumen'] != null) {
          _volumen = TratarString.quitarUnidadesEspacios(
              TratarString.sustituirComasPorPuntos(
                  json['Producto $i']['Características']['Volumen']));

          _volumen = null;
        }

        if (json['Producto $i']['Características']['Marca'] != null) {
          _marca = json['Producto $i']['Características']['Marca'];
        } else {
          _marca = null;
        }
      } else {
        _peso = null;
        _volumen = null;
        _marca = null;
      }

      _categoria = json['Producto $i']['Categoria'];
      if (TratarString.detectarSiTieneRutaHttp(json['Producto $i']['Imagen'])) {
        _hrefProducto = json['Producto $i']['Imagen'];
      } else {
        _hrefProducto = "assets/image_producto_no_encontrada.jpg";
      }
    } else {
      _nombreProducto = "ProductoNoExisteJSON";
      _precio = 0.00;
      _hrefProducto = "";
    }
    _unidades = 0;
  }
  String get nombreProducto => _nombreProducto;

  void nombre(value) {
    _nombreProducto = value;
  }

  get precio => _precio;

  set precio(value) => _precio = value;

  get peso => _peso;

  set peso(value) => _peso = value;

  get volumen => _volumen;

  set setUnidades(int value) => _unidades = value;

  get unidades => _unidades;

  set volumen(value) => _volumen = value;

  get marca => _marca;

  set marca(value) => _marca = value;

  get categoria => _categoria;

  set categoria(value) => _categoria = value;

  get hrefProducto => _hrefProducto;

  void imagen(value) {
    _hrefProducto = value;
  }

  /// El método [toList()] convierte el objeto [Producto] en una lista de valores.
  ///
  /// Retorna una lista de tipo [List<dynamic>] que contiene los valores de los atributos del producto en el mismo orden en el que fueron definidos.

  List<dynamic> toList() {
    return [
      _nombreProducto,
      _precio,
      _peso,
      _volumen,
      _marca,
      _volumen,
      _categoria,
      _hrefProducto
    ];
  }

  /// El método [toMapIntroducirProductoListaFavoritaEnBD] convierte el objeto [Producto] en un mapa de datos para su inserción en la base de datos de una lista favorita.
  ///
  /// Recibe como argumento un entero [idListaFavorita], que representa el ID de la lista favorita.
  /// Retorna un mapa de tipo [Map<String, dynamic>] que contiene los datos del producto en el formato adecuado para su inserción en la base de datos.

  Map<String, dynamic> toMapIntroducirProductoListaFavoritaEnBD(
      int idListaFavorita) {
    return {
      'idListaFavorita': idListaFavorita,
      'nombreProducto': _nombreProducto,
    };
  }

  /// El método [toMapIntroducirProductoFavoritoEnBD] convierte el objeto [Producto] en un mapa de datos para su inserción en la base de datos de productos favoritos.
  ///
  /// Retorna un mapa de tipo [Map<String, dynamic>] que contiene los datos del producto en el formato adecuado para su inserción en la base de datos.
  Map<String, dynamic> toMapIntroducirProductoFavoritoEnBD() {
    return {
      'nombre': _nombreProducto,
      'imagen': _hrefProducto,
    };
  }

  /// El método [toMapIntroducirProductosEnBD] convierte el objeto [Producto] en un mapa de datos para su inserción en la base de datos de productos.
  ///
  /// Recibe como argumento un entero [idTienda], que representa el ID de la tienda.
  /// Retorna un mapa de tipo [Map<String, dynamic>] que contiene los datos del producto en el formato adecuado para su inserción en la base de datos.
  Map<String, dynamic> toMapIntroducirProductosEnBD(int idTienda) {
    return {
      'idTienda': idTienda,
      'nombre': _nombreProducto,
      'precio': _precio,
      'categoria': _categoria,
      'marca': _marca,
      'volumen': _volumen,
      'peso': _peso,
      'imagen': _hrefProducto,
    };
  }

  /// El método [toMap] convierte el objeto [Producto] en un mapa de datos.
  ///
  /// Retorna un mapa de tipo [Map<String, dynamic>] que contiene los datos del producto en formato clave-valor.
  Map<String, dynamic> toMap() {
    return {
      'nombre': _nombreProducto,
      'precio': _precio,
      'categoria': _categoria,
      'marca': _marca,
      'volumen': _volumen,
      'peso': _peso,
      'imagen': _hrefProducto,
    };
  }

  /// El constructor [Producto.inicializandoDesdeMapaProductoListaFavorita] crea un objeto [Producto] a partir de un mapa de datos.
  ///
  /// Recibe como argumento un mapa de tipo [Map<String, dynamic>] llamado [productoMapa], que contiene los datos del producto.
  /// Utiliza el valor correspondiente del mapa para inicializar la propiedad [_nombreProducto] del objeto [Producto].

  Producto.inicializandoDesdeMapaProductoListaFavorita(
      Map<String, dynamic> productoMapa)
      : _nombreProducto = productoMapa['nombreProducto'];

  /// El constructor [Producto.inicializandoDesdeMapaProductoFavorito] crea un objeto [Producto] a partir de un mapa de datos.
  ///
  /// Recibe como argumento un mapa de tipo [Map<String, dynamic>] llamado [productoMapa], que contiene los datos del producto.
  /// Utiliza los valores del mapa para inicializar las propiedades [_nombreProducto] y [_hrefProducto] del objeto [Producto].
  /// Las propiedades se obtienen del mapa mediante claves como [nombre] y [imagen].

  Producto.inicializandoDesdeMapaProductoFavorito(
      Map<String, dynamic> productoMapa)
      : _nombreProducto = productoMapa['nombre'],
        _hrefProducto = productoMapa['imagen'];

  /// El constructor [Producto.inicializandoDesdeMapa] crea un objeto [Producto] a partir de un mapa de datos.
  ///
  /// Recibe como argumento un mapa de tipo [Map<String, dynamic>] llamado [productoMapa], que contiene los datos del producto.
  /// Utiliza los valores del mapa para inicializar las propiedades del objeto [Producto].
  /// Las propiedades se obtienen del mapa mediante claves como [nombre], [precio], [imagen], [peso], [volumen], [marca] y [categoria].
  /// La propiedad [_unidades] se inicializa con el valor 0.
  ///
  /// Nota: Asegúrate de que el mapa de datos contenga las claves necesarias y los tipos de datos correctos para inicializar correctamente el objeto [Producto].

  Producto.inicializandoDesdeMapa(Map<String, dynamic> productoMapa)
      : _nombreProducto = productoMapa['nombre'],
        _precio = productoMapa['precio'],
        _hrefProducto = productoMapa['imagen'],
        _peso = productoMapa['peso'],
        _volumen = productoMapa['volumen'],
        _marca = productoMapa['marca'],
        _categoria = productoMapa['categoria'],
        _unidades = 0;

  /// El método [toObjeto()] convierte un mapa de datos en un objeto [Producto].
  ///
  /// Recibe como argumento un mapa de tipo [Map<String, dynamic>] llamado [objeto], que contiene los datos del producto.
  /// Utiliza los valores del mapa para crear un objeto [Producto] con las propiedades correspondientes.
  /// Las propiedades se obtienen del mapa mediante claves como 'nombre', 'precio', 'imagen', 'categoria', 'marca', 'peso' y 'volumen'.
  /// Retorna el objeto [Producto] creado.
  Producto toObjeto(Map<String, dynamic> objeto) {
    Producto resultado = Producto(
        nombreProducto: objeto['nombre'],
        precio: objeto['precio'],
        hrefProducto: objeto['imagen'],
        categoria: objeto['categoria'],
        marca: objeto['marca'],
        peso: objeto[peso],
        volumen: objeto['volumen']);
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
    if (precio > other.precio) return -1;
    if (precio < other.precio) return 1;

    return 0;
  }
}
