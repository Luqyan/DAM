import 'package:aplicacion_ac/modelo/base_datos.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';
import '../modelo/Tienda.dart';

class GestionDatos {
  GestionDatos();

  static Future<List<Tienda>> devuelveTiendas() async {
    List<Tienda> lista = List.empty(growable: true);

    List<Object?> lista_nombres_tablas = await BD.obtenerNombresTablasTiendas();

    for (Object? n in lista_nombres_tablas) {
      Tienda tabla_nueva = Tienda.tabla(nombre: n.toString());

      lista.add(tabla_nueva);
    }

    return lista;
  }

  ///===========Advertencia: Esta funcion es obligatoria ejecutarla simpre
  ///después de haber ejecutado la funcion generarTiendas
  ///de la clase modelo/Tienda.dart
  ///Devuelve true si hay alguna tienda que tiene el producto introducido por parametro
  ///Devuelve false si ninguna tienda tiene el producto introducido por parametro
  static Future<void> anadirElementosAarrayTienda(String productoAbuscar,
      List<Producto> lista_prod, tiendaEnDondeSeRealizaSelect) async {
    List<bool> IntroducidoAlgunproducto = [];

    IntroducidoAlgunproducto.add(Tienda.anadirproductoOproductosATienda(
        tiendaEnDondeSeRealizaSelect, lista_prod));
  }

  ///comprueba si al menos el producto buscado ha sido añadido ha alguna tienda del List<Producto>
  ///Si devulve false significa que se habia introducido en todas las tablas el ultimo List<producto> vacio
  ///Si devuelve true significa que por lo menos en una tabla el ultimo List<producto> añadido tiene algun producto
  static bool _comprobadorDeListasproductosVacias(List<bool> metidoProductos) {
    bool resultado = false;
    for (int i = 0; i < metidoProductos.length; i++) {
      resultado = metidoProductos[i];
      if (resultado) {
        return resultado;
      }
    }
    for (Tienda tienda in Tienda.obtenerTiendas) {
      tienda.listas.removeLast();
    }
    return resultado;
  }

  // Se filtran todos los productos por precio y se devuelven dos listas con los productos buscados más baratos por cada tienda
  static List<Tienda> filtrarPorPrecio() {
    List<Tienda> resultado = List.empty(growable: true);
    Tienda Carrefour = Tienda.tabla(nombre: "Carrefour", imagen: "assets/carrefour.jpg");
    Tienda Ahorramas = Tienda.tabla(nombre: "Ahorramas", imagen: "assets/ahorramas.jpg");
    for (Tienda t in Tienda.obtenerTiendas) {
      for (List<Producto> lista in t.listas) {
        lista.sort(((a, b) => a.compareTo(b)));
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
