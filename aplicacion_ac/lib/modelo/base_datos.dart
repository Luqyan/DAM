import 'Producto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class BD {

  /* El método _openBD() es un método asincrónico que devuelve una instancia de la base de datos Database.

  El método utiliza el método getDatabasesPath() para obtener la ruta de acceso al directorio de bases de datos 
  en el dispositivo del usuario. Luego, el método join() se utiliza para agregar el nombre del archivo de la base 
  de datos (en este caso "productos.db") a la ruta de acceso de la carpeta de bases de datos.

  Si la base de datos no existe, se crea utilizando el método onCreate(). El método ejecuta una sentencia SQL 
  para crear una nueva tabla llamada "carrefour" con varios campos de diferentes tipos de datos, incluyendo 
  "nombre", "categoria", "precio", "marca", "volumen", "peso" e "imagen". La columna "nombre" se convierte en 
  clave primaria.*/

  

  static Future<Database> openBD() async {

    return openDatabase(join(await getDatabasesPath(), 'productos.db'),
        onCreate: (db, version) {
        db.execute(
          """CREATE TABLE ahorramas (
          nombre TEXT PRIMARY KEY,
          precio REAL,
          categoria TEXT,
          marca TEXT,
          peso REAL,
          volumen REAL,
          imagen TEXT
); """
      );
    }, version: 1);
  }



/*El método insert() es un método estático y asíncrono que toma un objeto Producto como entrada. 
El método devuelve una Future<void>.

El método utiliza el método _openBD() para obtener una instancia de la base de datos. 
Luego, utiliza el método insert() de la clase Database para insertar los datos del objeto prod en la 
tabla "productos". Los valores a insertar se especifican mediante el método toMap() llamado en el objeto prod.

La función anónima pasada al método then() se llama con el valor devuelto por database.insert(), 
pero no hace nada con él y simplemente lo devuelve.*/

  static Future<void> insert(Producto prod) async {
    Database database = await openBD();

    return database.insert('ahorramas', prod.toMap()).then((value) => value);
  }

/*El método delete() es un método estático y asincrónico que toma un objeto Producto como entrada. 

El método no devuelve nada, por lo que su tipo de retorno es Future<void>.

El método utiliza el método _openBD() para obtener una instancia de la base de datos. 
Luego, utiliza el método delete() de la clase Database para eliminar un registro de la tabla "productos". 
La condición de eliminación se especifica utilizando el parámetro where, que se establece en 'nombre = ?', 
y el valor que coincide con la condición se proporciona al parámetro whereArgs, que se establece en 
[prod.nombreProducto].*/

  static Future<void> delete(Producto prod) async {
    Database database = await openBD();

    database.delete('productos',
        where: 'nombre = ?', whereArgs: [prod.nombreProducto]);
  }

/*El método update() es una función asíncrona que toma un objeto Producto como entrada. 

El método devuelve una Future<void>.

Primero, la función utiliza el método _openBD() para obtener una instancia de la base de datos. 
Luego, utiliza el método update() de la clase Database para actualizar los datos del objeto prod en la tabla 
"productos". Los valores actualizados se especifican mediante el método toMap() llamado en el objeto prod.

Además, el método tiene dos parámetros opcionales where y whereArgs que se utilizan para filtrar los resultados 
a actualizar. En este caso, se actualiza el primer registro cuyo nombre sea igual al nombre del objeto prod.*/

  static Future<void> update(Producto prod) async {
    Database database = await openBD();

    database.update('productos', prod.toMap(),
        where: 'nombre = ?', whereArgs: [prod.nombreProducto]);

  }

/*El método productos() es un método asincrónico que devuelve una lista de objetos Producto.

El método abre la base de datos utilizando el método _openBD(), y luego hace una consulta a la tabla "productos" 
utilizando el método database.query("productos").

El resultado de la consulta es una lista de objetos Map, donde cada objeto Map representa 
una fila en la tabla "productos". 

El método crea una nueva lista de objetos Producto, basada en el resultado de la consulta, y devuelve la lista.*/

  static Future<List<Producto>> productos(String tienda) async {
    Database database = await openBD();

    final List<Map<String, dynamic>> productosLista =
        await database.query("$tienda");

    return List.generate(

        productosLista.length,
        (index) => Producto(
            nombreProducto: productosLista[index]['nombre'],
            hrefImgProducto: productosLista[index]['imagen'],
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

  static Future<void> insertarProducto(Producto prod) async {
    Database database = await openBD();

    var resultado = await database.rawInsert(
        'INSERT INTO ahorramas (nombre, precio, categoria, marca, peso, volumen, imagen) VALUES ("${prod.nombreProducto}", ${prod.precio}, "${prod.categoria}", "${prod.marca}", ${prod.volumen}, ${prod.peso}, "${prod.hrefProducto}")'
        
        );

  
  }


  static Future<void> borrarTabla(String nombre) async {

    Database database = await openBD();

    database.delete(nombre);


  }

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