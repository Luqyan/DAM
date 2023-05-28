import 'dart:io';
import 'package:aplicacion_ac/modelo/Tienda.dart';
import 'package:aplicacion_ac/modelo/TiendaJson.dart';

import 'Producto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer; //Sirve para los logs

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
      db.execute("""CREATE TABLE ahorramas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT UNIQUE,
          precio REAL,
          categoria TEXT,
          marca TEXT,
          peso REAL,
          volumen REAL,
          imagen TEXT
); """);
      db.execute("""CREATE TABLE carrefour (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT UNIQUE,
          precio REAL,
          categoria TEXT,
          marca TEXT,
          peso REAL,
          volumen REAL,
          imagen TEXT
); """);
      await _insertarTodosProductosDeTienda(db, ['Ahorramas', 'carrefour']);
    }, version: 1);
  }

  //Funciona
  static Future<void> _insertarTodosProductosDeTienda(
      Database db, List<String> nomTiendas) async {
    for (int i = 0; i < nomTiendas.length; i++) {
      List<Producto> productosIntroducir =
          await TiendaJson.obtenerProductosDeJson(nomTiendas[i]);
      //  print("cantidad de productos: ${productosIntroducir.length} de ${nomTiendas[i]}");
      for (Producto p in productosIntroducir) {
        try {
          await BD._insert(db, p, nomTiendas[i]);
        } on Exception catch (e) {
          developer.log(e.toString());
        }
      }
    }
  }

//Funciona
  static Future<void> _insert(
      Database db, Producto prod, String nomTabla) async {
    return await db.insert(nomTabla, prod.toMap()).then((value) => value);
  }

/*El método delete() es un método estático y asincrónico que toma un objeto Producto como entrada. 

El método no devuelve nada, por lo que su tipo de retorno es Future<void>.

El método utiliza el método _openBD() para obtener una instancia de la base de datos. 
Luego, utiliza el método delete() de la clase Database para eliminar un registro de la tabla "productos". 
La condición de eliminación se especifica utilizando el parámetro where, que se establece en 'nombre = ?', 
y el valor que coincide con la condición se proporciona al parámetro whereArgs, que se establece en 
[prod.nombreProducto].*/
  // //No lhe comprobado si funciona
  // // static Future<int> delete(Producto prod) async {
  // //   Database database = await openBD();

  // //   return database.delete('ahorramas',
  // //       where: 'nombre = ?', whereArgs: [prod.nombreProducto]);
  // // }

/*El método update() es una función asíncrona que toma un objeto Producto como entrada. 

El método devuelve una Future<void>.

Primero, la función utiliza el método _openBD() para obtener una instancia de la base de datos. 
Luego, utiliza el método update() de la clase Database para actualizar los datos del objeto prod en la tabla 
"productos". Los valores actualizados se especifican mediante el método toMap() llamado en el objeto prod.

Además, el método tiene dos parámetros opcionales where y whereArgs que se utilizan para filtrar los resultados 
a actualizar. En este caso, se actualiza el primer registro cuyo nombre sea igual al nombre del objeto prod.*/
  //TO DO: Se va a usar esta función
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
  //TO DO: no funciona
  static Future<List<Producto>> productos(String tienda) async {
    Database database = baseDatos;

    final List<Map<String, dynamic>> productosLista =
        await database.query(tienda);

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
  //TO DO: no funciona este método
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

  //TO DO: No se si funciona correctamente
  static Future<void> borrarBBDD() async {
    String ruta = join(await getDatabasesPath(), 'baseDB2.db');
    File baseDatosEliminar = File(ruta);
    await baseDatosEliminar.delete();
  }

  //TO DO: No se si funciona correctamente
  static Future<int> getCount() async {
    Database database = baseDatos;
    var result = await database.query("ahorramas");
    int count = result.length;

    return count;
  }

  //TO DO: como puede devolver un valor nulo puede dar problemas a la hora de hacer bucles
  static Future<List<Producto>?> muestraTodo(String nomTabla) async {
    // ABRIMOS LA BASE DE DATOS
    Database database = baseDatos;

    // RECOGEMOS TODAS LAS FILAS DE LA TABLA
    final List<Map<String, dynamic>> result = await database.query(nomTabla);

    // IMPRIMIMOS CADA FILA

    result.forEach((row) => print(row));

    return null;
  }

  //Funciona
  static Future<List<Object?>> obtenerNombresTablasTiendas() async {
    List<Object?> resultado = [];
    Database database = baseDatos;
    List<Map<String, Object?>> tablas = await database.query(
        columns: ['name'],
        "sqlite_master",
        where:
            "type LIKE (?) AND name != 'android_metadata' AND name != 'sqlite_sequence' ",
        whereArgs: ['table'],
        orderBy: 'name');
    for (int i = 0; i < tablas.length; i++) {
      resultado.add((tablas[i]['name']));
    }
    return resultado;
  }

  //Funciona
  static Future<Producto> consultaPrimerProducto(
      String tabla, String nombreProducto) async {
    Producto resultado = Producto(
        nombreProducto: "productoNoEncontrado",
        precio: 0,
        hrefProducto: "assets/producto_no_encontrado.png");

    Database database = baseDatos;

    final List<Map<String, dynamic>> producto = await database.query(tabla,
        where: "nombre LIKE (?)", whereArgs: ['%$nombreProducto%']);

    if (producto.length > 0) {
      resultado = Producto.inicializandoDesdeMapa(producto[0]);
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
      List<String> tablas, String nombre) async {
    List<Tienda> tiendas = [];

    Database database = baseDatos;

    for (String nombreTabla in tablas) {
      Tienda tienda = Tienda.tabla(nombre: nombreTabla);
      List<Producto> productosDeTienda = [];
      final List<Map<String, dynamic>> producto = await database.query(
          "$nombreTabla",
          where: "nombre LIKE (?)",
          whereArgs: ['%$nombre%']);

      if (producto.length != 0) {
        //Este if esta puesto por la estructura del del Map si tiene tamaño 0 peta debido a que no encuentra el producto[0]: no se ha comprobado si la causa es esta
        //TODO:Investigar cual es el esquema del map generado
        for (int f = 0; f < producto.length; f++) {
          // productosDeTienda.add(Producto.inicializandoDesdeMapa(producto[f]));



          tienda.lista_x_busqueda
              .add(Producto.inicializandoDesdeMapa(producto[f]));
        }

        // esta funcion se usara en confirmar lista
        // Tienda.anadirproductoOproductosATienda(nombreTabla, productosDeTienda);
      } else {
        developer.log(
            "No hay ningun producto que tenga el nombre '$nombre' en la tabla : '$nombreTabla' ");
      }
      for (Producto p in productosDeTienda) {
        // tienda._aniadir_prod_tienda(p);
      }

      tiendas.add(tienda);
    }

    return tiendas;
  }

/*
/*El método cargarProductos() utiliza el método productos() de la clase BD para obtener la lista de todos 
los productos almacenados en la base de datos. El método es asíncrono y no toma parámetros de entrada. 
Al final de la función se actualiza el estado de los widgets mediante el método setState().

La función carga los datos de la base de datos en una lista de objetos de tipo Producto llamada productos_bd. 
Utilizando la palabra clave await, la función espera a que la lista sea devuelta por el método productos(), 
antes de continuar con otras operaciones.

Finalmente, la función actualiza el estado del objeto "productos" con la lista de productos cargada desde la 
base de datos, lo que provoca una nueva renderización visual.


******************* Es importante mencionar que si el número de productos es grande, esta función podría tomar un tiempo 
considerable para completarse y actualizar la pantalla, lo que podría afectar negativamente la experiencia 
del usuario. ********************

*/


cargarProductos() async {

  List<Producto> productos_bd = await BD.productos();

  setState(() {

    productos = productos_BD;

  })
}



*/
}
