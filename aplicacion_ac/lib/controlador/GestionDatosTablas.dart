import 'package:aplicacion_ac/modelo/base_datos.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';
import '../modelo/Tienda.dart';

class GestionDatos {
  GestionDatos();

  /// El método [devuelveTiendas()] es un método asincrónico que devuelve una lista de objetos [Tienda].
  ///
  /// Este método realiza los siguientes pasos:
  /// 1. Crea una lista vacía de objetos [Tienda] llamada [lista].
  /// 2. Utiliza el método estático [obtenerNombresTablasTiendas()] de la clase [BD] para obtener una lista de nombres de tablas de tiendas.
  /// 3. Recorre la lista de nombres de tablas y crea un objeto [Tienda] con cada nombre de tabla. El nombre de la tabla se pasa como argumento al constructor de la clase [Tienda].
  /// 4. Agrega cada objeto [Tienda] a la lista [lista].
  /// 5. Retorna la lista [lista] que contiene todas las tiendas.
  ///
  /// Ejemplo de uso:
  /// dart /// List<Tienda> tiendas = await devuelveTiendas(); /// print(tiendas.length); // Imprime la cantidad de tiendas disponibles /// /// Este ejemplo obtiene la lista de tiendas utilizando el método [devuelveTiendas()] y luego imprime la cantidad de tiendas en la lista.
  ///
  /// Nota: Asegúrate de tener las tablas de tiendas correctamente configuradas en tu base de datos antes de llamar a este método.
  static Future<List<Tienda>> devuelveTiendas() async {
    List<Tienda> lista = List.empty(growable: true);

    List<Object?> lista_nombres_tablas = await BD.obtenerNombresTablasTiendas();

    for (Object? n in lista_nombres_tablas) {
      Tienda tabla_nueva = Tienda.tabla(nombre: n.toString());

      lista.add(tabla_nueva);
    }

    return lista;
  }

 
  /// El método [filtrarPorPrecio] es un método que filtra las listas de productos de las tiendas por precio y devuelve una lista de tiendas con el producto más caro de cada una.
  ///
  /// Crea una lista vacía llamada [resultado] que almacenará las tiendas filtradas.
  /// Crea dos instancias de la clase [Tienda]: [Carrefour] y [Ahorramas], con nombres y rutas de imagen predefinidos.
  ///
  /// Itera sobre todas las tiendas obtenidas mediante el método [obtenerTiendas] de la clase [Tienda].
  /// Dentro del bucle, itera sobre las listas de productos de cada tienda.
  /// Ordena cada lista de productos de forma descendente utilizando el método de comparación proporcionado ((b, a) => a.compareTo(b)).
  /// Si la lista no está vacía, verifica el nombre de la tienda:
  /// - Si el nombre de la tienda es[carrefour], agrega el primer producto de la lista a la lista de búsqueda de [Carrefour].
  /// - Si el nombre de la tienda es [ahorramas], agrega el primer producto de la lista a la lista de búsqueda de [Ahorramas].
  ///
  /// Agrega [Carrefour] a la lista [resultado].
  /// Agrega [Ahorramas] a la lista [resultado].
  ///
  /// Devuelve la lista [resultado] con las tiendas filtradas.
  ///
  /// Ejemplo de uso:
  /// dart /// List<Tienda> tiendasFiltradas = filtrarPorPrecio(); /// for (Tienda t in tiendasFiltradas) { /// print("Tienda: ${t.nombre}"); /// print("Producto más caro: ${t.lista_busqueda[0].nombreProducto}"); /// } /// /// Esto imprimirá el nombre de cada tienda y el producto más caro de cada una según el filtrado por precio.
  ///
  /// Nota: Asegúrate de tener las tiendas y listas de productos correctamente configuradas antes de llamar a este método.
  static List<Tienda> filtrarPorPrecio() {
    List<Tienda> resultado = List.empty(growable: true);
    Tienda Carrefour =
        Tienda.tabla(nombre: "Carrefour", imagen: "assets/carrefour.jpg");
    Tienda Ahorramas =
        Tienda.tabla(nombre: "Ahorramas", imagen: "assets/ahorramas.jpg");
    for (Tienda t in Tienda.obtenerTiendas) {
      for (List<Producto> lista in t.listas) {
        lista.sort(((b, a) => a.compareTo(b)));
        if (lista.isNotEmpty) {
          if (t.nombre == "carrefour") {
            Carrefour.lista_busqueda.add(lista[0]);
          } else {
            Ahorramas.lista_busqueda.add(lista[0]);
          }
        }
      }
    }
    resultado.add(Carrefour);

    resultado.add(Ahorramas);

    return resultado;
  }
}
