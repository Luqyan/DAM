import 'package:aplicacion_ac/modelo/Tienda.dart';
import 'package:aplicacion_ac/modelo/TiendaJson.dart';
import 'package:aplicacion_ac/vista/Lista.dart';

import 'package:sqflite/sqflite.dart';
import 'dart:developer' as developer;
import 'package:path/path.dart';
import 'Producto.dart';

class BD {
  static late Database baseDatos;

  /// El método [_openBD] es un método asincrónico que devuelve una instancia de la base de datos [Database].
  ///
  /// El método utiliza el método [getDatabasesPath] para obtener la ruta de acceso al directorio de bases de datos
  /// en el dispositivo del usuario. Luego, el método [join] se utiliza para agregar el nombre del archivo de la base
  /// de datos (en este caso [productos.db]) a la ruta de acceso de la carpeta de bases de datos.
  ///
  /// Si la base de datos no existe, se crea utilizando el método [onCreate]. El método ejecuta una sentencia [SQL]
  /// para crear una nueva tabla llamada [carrefour] con varios campos de diferentes tipos de datos, incluyendo
  /// [nombre], [categoria], [precio], [marca], [volumen], [peso] e [imagen]. La columna [nombre] se convierte en
  /// clave primaria.
  static Future<void> openBD() async {
    baseDatos = await openDatabase(join(await getDatabasesPath(), 'cacatua.db'),
        onCreate: (db, version) async {
      db.execute("""CREATE TABLE IF NOT EXISTS tiendas(
                        id INTEGER PRIMARY KEY AUTOINCREMENT,
                        nombre TEXT UNIQUE NOT NULL,
                        imagen TEXT NOT NULL
                  );""");
      db.execute("""CREATE TABLE IF NOT EXISTS productos(
                              id INTEGER PRIMARY KEY AUTOINCREMENT,
                              idTienda INTEGER NOT NULL,
                              nombre TEXT NOT NULL,
                              precio REAL NOT NULL,
                              categoria TEXT,
                              marca TEXT,
                              peso REAL,
                              volumen REAL,
                              imagen TEXT NOT NULL,
                              FOREIGN KEY(idTienda) REFERENCES tiendas(id) ON DELETE CASCADE
                  ); """);
      db.execute("""CREATE TABLE IF NOT EXISTS listas_favoritas(
                              id INTEGER PRIMARY KEY AUTOINCREMENT,
                              nombre TEXT NOT NULL
                  );""");
      db.execute("""CREATE TABLE IF NOT EXISTS productos_listas_favoritas(
                              id INTEGER PRIMARY KEY AUTOINCREMENT,
                              idListaFavorita INTEGER NOT NULL,
                              nombreProducto TEXT NOT NULL,
                              FOREIGN KEY(idListaFavorita) REFERENCES listasFavoritas(id) ON DELETE CASCADE
                  );""");
      db.execute("""CREATE TABLE IF NOT EXISTS productos_favoritos(
                              id INTEGER PRIMARY KEY AUTOINCREMENT,
                              nombre TEXT UNIQUE,
                              imagen TEXT UNIQUE
                  );""");

      await _insertarTodasTiendas(db);
      await _insertarTodosProductosDeTienda(
          db, await BD._obtenerTodosLosDatosTienda(db));
    }, version: 1);
  }

  /// Inserta todas las tiendas en la base de datos utilizando una conexión de base de datos específica.
  ///
  /// [db]: El objeto de tipo [Database] que representa la conexión de base de datos.
  ///
  /// Crea una lista de mapas que representa cada tienda, utilizando la clase [TiendaJson]. Luego, recorre la lista y realiza una inserción en la tabla [tiendas] de la base de datos utilizando la conexión específica proporcionada.
  ///
  /// Este método no retorna ningún valor.
  static Future<void> _insertarTodasTiendas(Database db) async {
    List<Map<String, dynamic>> tiendas = [
      TiendaJson(
          "ahorramas",
          "https://www.mercadoventas.es/wp-content/uploads/2018/03/LOGO-AHORRAMAS2.jpg",
          []).toMapParaBD(),
      TiendaJson(
          "carrefour",
          "https://upload.wikimedia.org/wikipedia/commons/5/5b/Carrefour_logo.svg",
          []).toMapParaBD()
    ];
    for (int i = 0; i < tiendas.length; i++) {
      await db.insert("tiendas", tiendas[i]);
    }
  }

  /// Inserta todos los productos de una tienda en la base de datos utilizando una conexión de base de datos específica.
  ///
  /// [db]: El objeto de tipo Database que representa la conexión de base de datos.
  /// [nomTiendasEid]: Una lista de mapas que contiene los nombres y los IDs de las tiendas.
  ///
  /// Recorre la lista de tiendas y obtiene los productos correspondientes a cada tienda mediante la función obtenerProductosDeJson() de la clase TiendaJson. Luego, inserta cada producto en la tabla "productos" de la base de datos utilizando la conexión específica proporcionada.
  ///
  /// Este método no retorna ningún valor.
  static Future<void> _insertarTodosProductosDeTienda(
      Database db, List<Map<String, Object>> nomTiendasEid) async {
    for (int i = 0; i < nomTiendasEid.length; i++) {
      List<Producto> productosIntroducir =
          await TiendaJson.obtenerProductosDeJson(
              nomTiendasEid[i]['nombre'] as String);
      //  print("cantidad de productos: ${productosIntroducir.length} de ${nomTiendas[i]}");
      for (Producto p in productosIntroducir) {
        try {
          await BD._insert(db, p, nomTiendasEid[i]['id'] as int);
        } on Exception catch (e) {
          developer.log(e.toString());
        }
      }
    }
  }

  /// Inserta un producto en la base de datos utilizando una conexión de base de datos específica.
  ///
  /// [db]: El objeto de tipo Database que representa la conexión de base de datos.
  /// [prod]: El objeto de tipo Producto que se desea insertar en la base de datos.
  /// [idTienda]: El ID de la tienda a la que pertenece el producto.
  ///
  /// Inserta los datos del producto en la tabla "productos" de la base de datos utilizando la conexión específica proporcionada. Este método no retorna ningún valor.
  static Future<void> _insert(Database db, Producto prod, int idTienda) async {
    return await db
        .insert("productos", prod.toMapIntroducirProductosEnBD(idTienda))
        .then((value) => value);
  }

  /// Inserta un producto favorito en la base de datos.
  ///
  /// [prod]: El objeto de tipo Producto que se desea insertar como favorito.
  ///
  /// Inserta los datos del producto favorito en la tabla "productos_favoritos" de la base de datos. Este método no retorna ningún valor.
  static Future<void> insertProductoFavorito(Producto prod) async {
    return await baseDatos
        .insert(
            "productos_favoritos", prod.toMapIntroducirProductoFavoritoEnBD())
        .then((value) => value);
  }

  /// Elimina un producto favorito de la base de datos.
  ///
  /// [prod]: El objeto de tipo Producto que se desea eliminar de los favoritos.
  ///
  /// Elimina el producto favorito de la tabla "productos_favoritos" de la base de datos, utilizando el nombre del producto como criterio de búsqueda. Este método no retorna ningún valor.
  static void deleteProductoFavorito(Producto prod) async {
    baseDatos.delete('productos_favoritos',
        where: 'nombre = ?', whereArgs: [prod.nombreProducto]);
  }

  /// Elimina una lista favorita de la base de datos.
  ///
  /// [nombreLista]: El nombre de la lista favorita que se desea eliminar.
  ///
  /// Elimina la lista favorita de la tabla "listas_favoritas" de la base de datos, utilizando el nombre de la lista como criterio de búsqueda. Este método no retorna ningún valor.
  static void deleteListaFavorita(String nombreLista) async {
    baseDatos.delete('listas_favoritas',
        where: 'nombre = ?', whereArgs: [nombreLista]);
  }

  /// Obtiene la lista de productos de una tienda específica en la base de datos.
  ///
  /// [tienda]: El nombre de la tabla que contiene los productos de la tienda.
  ///
  /// Retorna una lista de objetos de tipo Producto que representan los productos de la tienda especificada.
  static Future<List<Producto>> productos(String tienda) async {
    Database database = baseDatos;

    final List<Map<String, dynamic>> productosLista =
        await database.query("$tienda");

    return List.generate(
        productosLista.length,
        (index) => Producto(
            //id: productosLista[index]['id'],
            nombreProducto: productosLista[index]['nombre'],
            hrefProducto: productosLista[index]['imagen'],
            precio: productosLista[index]['precio']));
  }

  /// Obtiene los nombres de las tablas de tiendas almacenadas en la base de datos.
  ///
  /// Retorna una lista de objetos que representan los nombres de las tablas de tiendas.
  static Future<List<Object?>> obtenerNombresTablasTiendas() async {
    List<Object?> resultado = [];
    Database database = baseDatos;
    List<Map<String, Object?>> tablas = await database.query(
      columns: ['id', 'nombre'],
      "tiendas",
    );
    for (int i = 0; i < tablas.length; i++) {
      resultado.add((tablas[i]['nombre']));
    }
    return resultado;
  }

  /// Obtiene todos los datos de las tiendas almacenadas en la base de datos.
  ///
  /// [db]: El objeto de tipo [Database] que representa la base de datos.
  ///
  /// Retorna una lista de mapas que contienen los datos de las tiendas. Cada mapa contiene las siguientes claves: [id], [nombre] e [imagen].
  static Future<List<Map<String, Object>>> _obtenerTodosLosDatosTienda(
      Database db) async {
    List<Map<String, Object>> resultado = [];
    List<Map<String, Object?>> tablas = await db.query(
      columns: ['id', 'nombre', 'imagen'],
      "tiendas",
    );

    for (int i = 0; i < tablas.length; i++) {
      resultado.add({
        'id': tablas[i]['id']!,
        'nombre': tablas[i]['nombre']!,
        'imagen': tablas[i]['imagen']!
      });
    }
    return resultado;
  }

  /// Obtiene las listas favoritas almacenadas en la base de datos.
  ///
  /// Retorna una lista de objetos de tipo [Lista] que representan las listas favoritas.
  static Future<List<Lista>> _devolverListasFavoritas() async {
    List<Lista> resultado = List.empty(growable: true);

    Database database = baseDatos;

    final List<Map<String, dynamic>> lista_favoritas =
        await database.query("listas_favoritas");

    for (int f = 0; f < lista_favoritas.length; f++) {
      resultado
          .add(Lista.inicializandoDesdeMapaListaFavorita(lista_favoritas[f]));
    }

    return resultado;
  }

  /// Carga los productos de las listas favoritas desde la base de datos.
  ///
  /// Retorna una lista de objetos de tipo [Lista] que contienen los productos asociados a las listas favoritas.
  static Future<List<Lista>> cargaProductosListasFavoritas() async {
    List<Lista> lista_favorita = await BD._devolverListasFavoritas();

    for (Lista li in lista_favorita) {
      List<Map<String, Object?>> productos_listas_favoritas =
          await baseDatos.query("productos_listas_favoritas",
              columns: ["nombreProducto"],
              where: "idListaFavorita = ?",
              whereArgs: [li.id]);

      //if (productos_listas_favoritas.length != 0) {
      //Este if esta puesto por la estructura del del Map si tiene tamaño 0 peta debido a que no encuentra el producto[0]: no se ha comprobado si la causa es esta

      List<Producto> productos = List.empty(growable: true);

      //TODO:Investigar cual es el esquema del map generado
      for (int f = 0; f < productos_listas_favoritas.length; f++) {
        // productosDeTienda.add(Producto.inicializandoDesdeMapa(producto[f]));
        productos.add(Producto.inicializandoDesdeMapaProductoListaFavorita(
            productos_listas_favoritas[f]));
      }

      li.aniade_lista_productos(productos);

      // esta funcion se usara en confirmar lista
      // Tienda.anadirproductoOproductosATienda(tienda, productosDeTienda);
      // } else {
      //  developer.log(
      //    "No hay ningun producto que tenga el id de lista especificado.");
      // }
    }

    return lista_favorita;
  }

  /// Obtiene el ID máximo de las listas favoritas almacenadas en la base de datos.
  ///
  /// Retorna un entero que representa el ID máximo de las listas favoritas.
  static Future<int> _devuelveIdMaxListasFavoritas() async {
    int idMax;
    List<Lista> ultima_lista_favorita = await BD._devolverListasFavoritas();
    idMax = ultima_lista_favorita.last.id;
    return idMax;
  }

  /// Inserta una lista favorita en la base de datos.
  ///
  /// [lista]: El objeto de tipo [Lista] que se desea insertar en la base de datos.
  ///
  /// Realiza la inserción de la lista favorita en la tabla [listas_favoritas] de la base de datos. Además, inserta los productos de la lista en la tabla [productos_listas_favoritas] asociados a la lista favorita.
  ///
  /// Este método no retorna ningún valor.
  static Future<void> insertListaFavorita(Lista lista) async {
    await baseDatos.insert(
        "listas_favoritas", lista.toMapIntroducirListaFavoritaEnBD());

    int idMax = await BD._devuelveIdMaxListasFavoritas();

    for (Producto p in lista.productos) {
      await baseDatos.insert("productos_listas_favoritas",
          p.toMapIntroducirProductoListaFavoritaEnBD(idMax));
    }
  }

  /// Obtiene los productos favoritos almacenados en la base de datos.
  ///
  /// Retorna un conjunto de objetos de tipo Producto que representan los productos favoritos.
  static Future<Set<Producto>> devuelveProductosFavoritos() async {
    Set<Producto> resultado = Set();

    Database database = baseDatos;

    final List<Map<String, dynamic>> producto =
        await database.query("productos_favoritos");

    for (int f = 0; f < producto.length; f++) {
      resultado
          .add(Producto.inicializandoDesdeMapaProductoFavorito(producto[f]));
    }

    return resultado;
  }

  /// Realiza una consulta de productos de una tienda en base a un nombre buscado.
  ///
  /// [nombreBuscado]: El nombre que se utiliza para buscar los productos.
  ///
  /// Retorna una lista de objetos de tipo Tienda que contienen los productos encontrados.
  static Future<List<Tienda>> consultaProductosTienda(
      String nombreBuscado) async {
    List<Map<String, Object>> nomTiendasEid =
        await BD._obtenerTodosLosDatosTienda(BD.baseDatos);
    List<Tienda> tiendas = [];

    Database database = baseDatos;

    for (Map<String, Object> tiendaValores in nomTiendasEid) {
      print(tiendaValores['nombre']);
      String nombreTienda = tiendaValores['nombre'] as String;
      int IdTienda = tiendaValores['id'] as int;

      Tienda tienda = Tienda.tabla(nombre: nombreTienda);

      List<Producto> productosDeTienda = [];
      final List<Map<String, dynamic>> producto = await database.query(
          "productos",
          where: "idTienda = (?)and nombre LIKE (?)",
          whereArgs: [IdTienda, '%$nombreBuscado%']);

      if (producto.length != 0) {
        //Este if esta puesto por la estructura del del Map si tiene tamaño 0 peta debido a que no encuentra el producto[0]: no se ha comprobado si la causa es esta
        //TODO:Investigar cual es el esquema del map generado
        for (int f = 0; f < producto.length; f++) {
          // productosDeTienda.add(Producto.inicializandoDesdeMapa(producto[f]));
          tienda.lista_x_busqueda
              .add(Producto.inicializandoDesdeMapa(producto[f]));
        }

        // esta funcion se usara en confirmar lista
        // Tienda.anadirproductoOproductosATienda(tienda, productosDeTienda);
      } else {
        developer.log(
            "No hay ningun producto que tenga el nombre '$nombreBuscado' en la tabla : '$tienda' ");
      }

      tiendas.add(tienda);
    }

    return tiendas;
  }
}
