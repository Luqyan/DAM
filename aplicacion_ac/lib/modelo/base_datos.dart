import 'dart:ffi';
import 'dart:io';
import 'package:aplicacion_ac/modelo/Tienda.dart';
import 'package:aplicacion_ac/modelo/TiendaJson.dart';
import 'package:aplicacion_ac/vista/Lista.dart';

import 'Producto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer; //Sirve para los logs
import 'dart:io' as system;

class BD {
  static late Database baseDatos;
  /* El método _openBD() es un método asincrónico que devuelve una instancia de la base de datos Database.

  El método utiliza el método getDatabasesPath() para obtener la ruta de acceso al directorio de bases de datos 
  en el dispositivo del usuario. Luego, el método join() se utiliza para agregar el nombre del archivo de la base 
  de datos (en este caso "productos.db") a la ruta de acceso de la carpeta de bases de datos.

  Si la base de datos no existe, se crea utilizando el método onCreate(). El método ejecuta una sentencia SQL 
  para crear una nueva tabla llamada "carrefour" con varios campos de diferentes tipos de datos, incluyendo 
  "nombre", "categoria", "precio", "marca", "volumen", "peso" e "imagen". La columna "nombre" se convierte en 
  clave primaria.*/

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

  // Lista lista<Producto>

  // INSERT listas_favoritas nombre_lista
  // for producto in lista:

  //   INSERT IN productos_listas_favoritas nombreProducto, idListaFavorita VALUES ......

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

  //Funciona
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

//Funciona
  static Future<void> _insert(Database db, Producto prod, int idTienda) async {
    return await db
        .insert("productos", prod.toMapIntroducirProductosEnBD(idTienda))
        .then((value) => value);
  }

  static Future<void> insertProductoFavorito(Producto prod) async {
    return await baseDatos
        .insert(
            "productos_favoritos", prod.toMapIntroducirProductoFavoritoEnBD())
        .then((value) => value);
  }

/*El método delete() es un método estático y asincrónico que toma un objeto Producto como entrada. 

El método no devuelve nada, por lo que su tipo de retorno es Future<void>.

El método utiliza el método _openBD() para obtener una instancia de la base de datos. 
Luego, utiliza el método delete() de la clase Database para eliminar un registro de la tabla "productos". 
La condición de eliminación se especifica utilizando el parámetro where, que se establece en 'nombre = ?', 
y el valor que coincide con la condición se proporciona al parámetro whereArgs, que se establece en 
[prod.nombreProducto].*/

  // Funsiona
  static void deleteProductoFavorito(Producto prod) async {
    baseDatos.delete('productos_favoritos',
        where: 'nombre = ?', whereArgs: [prod.nombreProducto]);
  }

  static void deleteListaFavorita(String nombreLista) async {
    baseDatos.delete('listas_favoritas',
        where: 'nombre = ?', whereArgs: [nombreLista]);
  }

/*El método update() es una función asíncrona que toma un objeto Producto como entrada. 

El método devuelve una Future<void>.

Primero, la función utiliza el método _openBD() para obtener una instancia de la base de datos. 
Luego, utiliza el método update() de la clase Database para actualizar los datos del objeto prod en la tabla 
"productos". Los valores actualizados se especifican mediante el método toMap() llamado en el objeto prod.

Además, el método tiene dos parámetros opcionales where y whereArgs que se utilizan para filtrar los resultados 
a actualizar. En este caso, se actualiza el primer registro cuyo nombre sea igual al nombre del objeto prod.*/
  //TODO: Se va a usar esta función
  static Future<void> update(Producto prod) async {
    Database database = baseDatos;

    database.update('productos', prod.toMap(),
        where: 'nombre = ?', whereArgs: [prod.nombreProducto]);
  }

/*El método productos() es un método asincrónico que devuelve una lista de objetos Producto.

El método abre la base de datos utilizando el método _openBD(), y luego hace una consulta a la tabla "productos" 
utilizando el método database.query("productos").

El resultado de la consulta es una lista de objetos Map, donde cada objeto Map representa 
una fila en la tabla "productos". 

El método crea una nueva lista de objetos Producto, basada en el resultado de la consulta, y devuelve la lista.*/
  //TODO: no funciona
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

/*El método insertarTodo() es una función asíncrona que toma un objeto Producto como entrada. 
El método devuelve una Future<void>.

Primero, la función utiliza el método _openBD() para obtener una instancia de la base de datos. 
Luego, utiliza el método rawInsert() de la clase Database para insertar los datos del objeto prod en la tabla 
"productos" mediante una sentencia SQL.

La sentencia SQL INSERT INTO se utiliza para insertar una nueva fila en una tabla. Los valores a insertar 
se especifican mediante los parámetros ${prod.nombreProducto}, ${prod.precio}, ${prod.categoria}, ${prod.marca},
 ${prod.peso}, ${prod.volumen}, ${prod.hrefProducto}, correspondientes a las columnas de la tabla.

Además, el método almacena el resultado de la operación de inserción en una variable llamada resultado.*/
  //TODO: no funciona este método
  static Future<int> insertarProducto(Producto prod) async {
    Database database = baseDatos;

    return await database.rawInsert(
        'INSERT INTO ahorramas (nombre, precio, categoria, marca, volumen, peso, imagen) VALUES (${prod.nombreProducto}, ${prod.precio}, ${prod.categoria}, ${prod.marca}, ${prod.volumen}, ${prod.peso}, "${prod.hrefProducto}")');
  }

  //Funciona
  static Future<void> borrarTabla(String nombre) async {
    Database database = baseDatos;

    await database.execute('DELETE FROM $nombre');
  }

  //TODO: No se si funciona correctamente
  static Future<void> borrarBBDD() async {
    String ruta = join(await getDatabasesPath(), 'baseDB2.db');
    File baseDatosEliminar = File(ruta);
    await baseDatosEliminar.delete();
  }

  //TODO: No se si funciona correctamente
  static Future<int> getCount() async {
    Database database = baseDatos;
    var result = await database.query("ahorramas");
    int count = result.length;

    return count;
  }

  //TODO: como puede devolver un valor nulo puede dar problemas a la hora de hacer bucles
  static Future<List<Producto>?> muestraTodo(String nomTabla) async {
    // ABRIMOS LA BASE DE DATOS
    Database database = baseDatos;

    // RECOGEMOS TODAS LAS FILAS DE LA TABLA
    final List<Map<String, dynamic>> result = await database.query(nomTabla);

    // IMPRIMIMOS CADA FILA

    result.forEach((row) => print(row));

    return null;
  }

  //TODO:AQUI
  //Funciona y se usa
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

// List<Producto> lista = SELECT FROM productos_listas_favoritas WHERE idListaFavorita = id

//	Lista lista.addLista(lista);

//	Lista.listas.add(lista);

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

  static Future<int> _devuelveIdMaxListasFavoritas() async {
    int idMax;
    List<Lista> ultima_lista_favorita = await BD._devolverListasFavoritas();
    idMax = ultima_lista_favorita.last.id;
    return idMax;
  }

  static Future<void> insertListaFavorita(Lista lista) async {
    await baseDatos.insert(
        "listas_favoritas", lista.toMapIntroducirListaFavoritaEnBD());

    int idMax = await BD._devuelveIdMaxListasFavoritas();

    for (Producto p in lista.productos) {
      await baseDatos.insert("productos_listas_favoritas",
          p.toMapIntroducirProductoListaFavoritaEnBD(idMax));
    }
  }

// metodo

  //Funciona
  static Future<Producto> consultaPrimerProducto(
      String tabla, String nombreProducto) async {
    Producto resultado = Producto(
        nombreProducto: "productoNoEncontrado",
        precio: 0,
        hrefProducto: "assets/producto_no_encontrado.png");

    Database database = baseDatos;

    final List<Map<String, dynamic>> producto = await database.query("$tabla",
        where: "nombre LIKE (?)", whereArgs: ['%$nombreProducto%']);

    if (producto.length > 0) {
      resultado = Producto.inicializandoDesdeMapa(producto[0]);
    }

    return resultado;
  }

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

  //Funciona
  static Future<List<Producto>> consultaProductos(
      List<String> tablas, String nombre) async {
    List<Producto> resultado = [];

    Database database = baseDatos;

    for (int i = 0; i < tablas.length; i++) {
      final List<Map<String, dynamic>> producto = await database.query(
          "${tablas[i]}",
          where: "nombre LIKE (?)",
          whereArgs: ['%$nombre%']);
      for (int f = 0; f < producto.length; f++) {
        resultado.add(Producto.inicializandoDesdeMapa(producto[f]));
      }
    }

    return resultado;
  }

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
      for (Producto p in productosDeTienda) {
        print(p);
        // tienda._aniadir_prod_tienda(p);
      }

      tiendas.add(tienda);
    }

    return tiendas;
  }
}
