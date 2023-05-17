import 'package:aplicacion_ac/modelo/Producto.dart';

class Lista {
  String? _nombre;
  String? _descripcion;

  // Atributo de clase con objetos de la clase Producto utilizada durante la busqueda de productos
  static List<Producto> _lista_productos = List.empty(growable: true);

  // Atributo de clase con objetos de la propia clase 'Lista' para la pantalla de 'Elegir lista' (6)
  // Se utiliza al pulsar 'Guardar lista' en la Página 8 e incluirá la lista de Pro ductos anterior (_productos)
  static final List<dynamic> _listas = new List.empty(growable: true);

  static List<dynamic> get listas => _listas;

  static void addLista() {
    _listas.add(_lista_productos);
  }

  // Atributo de objeto de clase utilizada cada vez que se guarden listas a partir de busqueda
  List<Producto> _productos = List.empty(growable: true);

  // Getter
  List<Producto> get productos => _productos;

  // Setter
  set productos(List<Producto> value) {
    _productos = value;
  }

  void aniadir_producto(Producto value) => _productos.add(value);





  // Lista con el resultado generado en cada busqueda
  static List<Lista> _lista_x_busqueda = List.empty(growable: true);

  static List<dynamic> get listas_x_busqueda => _lista_x_busqueda;

  static set aniadir_listas_tiendas(Lista lista) =>
      _lista_x_busqueda.add(lista);



  // Lista de productos favoritos utilizada en la pantalla 'pagina4'
  static final Set<Producto> _productos_favoritos = Set();

  /////////////////////////////////////////////////

  Lista(this._nombre);

  get nombreLista => this._nombre;

  set nombreLista(value) => this._nombre = value;

  get descripcionLista => this._descripcion;

  set descripcionLista(value) => this._descripcion = value;

  static void aniadir_favorito(Producto producto) {
    _productos_favoritos.add(producto);
  }

  static Set<Producto> getFavoritos() {
    return _productos_favoritos;
  }

  // void agregarFavoritosALaLista(List<Producto>) {
  //   Lista.aniadir_favorito(producto);
  // }

  static void addProducto(Producto producto) {
    _lista_productos.add(producto);
  }

  // Métodos lista de productos 'static'
  static List<Producto> getProductos() {
    return _lista_productos;
  }

  void agregarProductoALaLista(Producto producto) {
    Lista.addProducto(producto);
  }

  static void borrarProductoPorPosicion(int posicion) {
    if (posicion < 0 || posicion >= _lista_productos.length) {
      throw RangeError('La posición está fuera del rango de la lista');
    }

    _lista_productos.removeAt(posicion);
  }

  static void quitarFavorito(int posicion) {
    if (posicion >= 0 && posicion < _productos_favoritos.length) {
      _productos_favoritos.remove(_productos_favoritos.elementAt(posicion));
    }
  }


}
