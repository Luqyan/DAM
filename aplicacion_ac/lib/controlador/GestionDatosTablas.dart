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


}
