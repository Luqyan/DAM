import 'package:aplicacion_ac/vista/genera_buscador.dart';
import 'package:aplicacion_ac/vista/Item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// CLASE PRINCIPAL CREADORA DE 'HOME'
class buscador extends StatefulWidget {
  const buscador({
    super.key,
  });

  @override
  State<buscador> createState() => Pagina7();
}

/// Genera una lista de elementos [Item] con el tamaño especificado.
///
/// El método [generaItems] genera una lista de elementos [Item] utilizando
/// la función `List.generate`. Cada elemento de la lista es creado con
/// valores predefinidos, donde el índice se utiliza para asignar valores
/// únicos a las propiedades `expanded` y `title`. La propiedad `isExpanded`
/// se establece en falso para todos los elementos.
///
/// - [tamanio]: El tamaño de la lista de elementos a generar.
///
/// Retorna una lista de elementos [Item] generada.
List<Item> generaItems(int tamanio) {
  return List.generate(
    tamanio,
    (int index) => Item(
      expanded: '$index',
      title: 'Item $index',
      isExpanded: false,
    ),
  );
}
