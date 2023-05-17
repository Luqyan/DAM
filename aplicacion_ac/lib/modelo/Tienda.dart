import '../vista/Lista.dart';
import 'Producto.dart';

class Tienda{

  late final String nombre;
  bool clickado = false;
  final String imagen;
  final String tipoClase = "Tienda";

    // Lista que abarca cada objeto creado por cada tabla existente en la BD
  // Lista de objetos de clase Lista generadas por cada tabla en base al dato introducido durante la busqueda (pag 7)
  // Este objeto contiene la lista de productos generada dentro del atributo de clase _productos
  static List<Tienda> _listas_generadas_busqueda = List.empty(growable: true);

  static List<dynamic> get listas_busqueda => _listas_generadas_busqueda;

  static void aniadir_lista_resultado(Tienda tienda) =>
      _listas_generadas_busqueda.add(tienda);



  // Lista de listas de productos usada por cada filtrado 
  List<List<Producto>> _listas = new List.empty(growable: true);

  List<dynamic> get listas => _listas;

  void addLista(value) {
    _listas.add(value);
  }




  // Constructor usado en la creacion de cada objeto Tienda por cada tabla de la BD
  Tienda.tabla({required nombre, this.imagen =""});




  Tienda({required this.nombre, this.clickado = false, required this.imagen});

  //set imgTienda(value) => this.imagenTienda = value;

  get img => imagen;



  @override
    String toString() {
      // TODO: implement toString
      return tipoClase;
    }

}