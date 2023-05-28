import 'package:aplicacion_ac/modelo/Producto.dart';
import 'package:flutter/src/widgets/text.dart';

class Lista {
  String? _nombre;
  String? _descripcion;

  /// Atributo de clase con objetos de la clase Producto utilizada durante la busqueda de productos
  static List<Producto> lista_productos = List.empty(growable: true);

  /// Atributo de clase con objetos de la propia clase 'Lista' para la pantalla de 'Elegir lista' (6)
  /// Se utiliza al pulsar 'Guardar lista' en la Página 8 e incluirá la lista de Pro ductos anterior (_productos)
  static List<dynamic> _listas = new List.empty(growable: true);

  static List<dynamic> get listas => _listas;

  static void addLista(Lista lista) {
    _listas.add(lista);
  }

  /// Atributo de objeto de clase utilizada cada vez que se guarden listas a partir de busqueda
  List<Producto> _productos = List.empty(growable: true);

  /// Getter
  List<Producto> get productos => _productos;

  /// Setter
  void aniade_lista_productos(List<Producto> value) {
    _productos.addAll(value);
  }

  /// Añade un producto a la lista de productos [_productos].
  ///
  /// - Parámetro [value]: El producto a añadir.

  void aniadir_producto(Producto value) => _productos.add(value);

  /// Borra una lista por su nombre.
  ///
  /// Recorre la lista de listas [_listas] y elimina la primera lista que coincida con el nombre proporcionado.
  /// Si no se encuentra ninguna lista con el nombre especificado, no se realiza ninguna acción.
  ///
  /// - Parámetro [nombre]: El nombre de la lista a borrar.

  static void borrarListaPorNombre(String nombre) {
    for (Lista lista in _listas) {
      if (lista.nombreLista == nombre) {
        _listas.remove(lista);
      }
    }
  }

  // Lista de productos favoritos utilizada en la pantalla 'pagina4'
  static final Set<Producto> _productos_favoritos = Set();

  
  /// Constructor de la clase Lista.

  Lista(this._nombre);

 /// Getter para el nombre de la lista.
  get nombreLista => _nombre;

  /// Setter para el nombre de la lista.
  set nombreLista(value) => _nombre = value;

  /// Getter para la descripción de la lista.
  get descripcionLista => _descripcion;

  /// Setter para la descripción de la lista.
  set descripcionLista(value) => _descripcion = value;

  /// Añade un producto a la lista de productos favoritos [_productos_favoritos].
  ///
  /// - Parámetro [producto]: El producto a añadir.
  static void aniadir_favorito(Producto producto) {
    _productos_favoritos.add(producto);
  }

  /// Obtiene la lista de productos favoritos [_productos_favoritos].
  ///
  /// Devuelve un conjunto (Set) de productos.
  static Set<Producto> getFavoritos() {
    return _productos_favoritos;
  }

  /// Añade un producto a la lista de productos [lista_productos].
  ///
  /// - Parámetro [producto]: El producto a añadir.
  static void addProducto(Producto producto) {
    lista_productos.add(producto);
  }

  /// Obtiene la lista de productos [lista_productos].
  ///
  /// Devuelve una lista de productos.
  static List<Producto> getProductos() {
    return lista_productos;
  }

  /// Agrega un producto a la lista actual.
  ///
  /// - Parámetro [producto]: El producto a añadir.
  void agregarProductoALaLista(Producto producto) {
    Lista.addProducto(producto);
  }

  /// Borra un producto de la lista de productos por su posición.
  ///
  /// - Parámetro [posicion]: La posición del producto a borrar.
  static void borrarProductoPorPosicion(int posicion) {
    if (posicion < 0 || posicion >= lista_productos.length) {
      throw RangeError('La posición está fuera del rango de la lista');
    }

    lista_productos.removeAt(posicion);
  }

  /// Quita un producto de la lista de productos favoritos por su posición.
  ///
  /// - Parámetro [posicion]: La posición del producto a quitar.
  static void quitarFavorito(int posicion) {
    if (posicion >= 0 && posicion < _productos_favoritos.length) {
      _productos_favoritos.remove(_productos_favoritos.elementAt(posicion));
    }
  }

  /// Método sin implementación.
  map(Text Function(dynamic producto) param0) {}

}
