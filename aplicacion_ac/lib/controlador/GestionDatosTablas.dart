import 'package:aplicacion_ac/modelo/base_datos.dart';
import 'package:aplicacion_ac/vista/Lista.dart';
import 'package:aplicacion_ac/modelo/base_datos.dart';

import '../modelo/Tienda.dart';

class GestionDatos {

  
 
  GestionDatos();
  
  

  static Future<List<Tienda>> devuelveTiendas() async {

    List<Tienda> lista = List.empty(growable: true);

    List<Object?> lista_nombres_tablas = await BD.obtenerNombresTablasTiendas();

    for (Object? n in lista_nombres_tablas) {
      Tienda tabla_nueva = Tienda.tabla(nombre:n.toString());

      lista.add(tabla_nueva);
    }

    return lista;
  }
///===========Advertencia: Esta funcion es obligatoria ejecutarla simpre 
///después de haber ejecutado la funcion generarTiendas
///de la clase modelo/Tienda.dart
  static Future<void> anadirElementosAarrayTienda(String productoAbuscar)async {
    for (var i = 0; i < Tienda.obtenerTiendas.length; i++) {
      String tiendaEnDondeSeRealizaSelect=Tienda.obtenerTiendas[i].nombre;
      
      Tienda.anadirproductoOproductosATienda(tiendaEnDondeSeRealizaSelect,
        await BD.consultaProductosTienda(tiendaEnDondeSeRealizaSelect, productoAbuscar)
      );

    }
    
  }

}
