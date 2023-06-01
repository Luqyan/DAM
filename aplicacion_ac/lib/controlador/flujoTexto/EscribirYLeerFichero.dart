import 'dart:developer' as developer;
import 'dart:io';

class EscribirYLeerFichero {
  /// El método [leerFichero()] es un método asincrónico que lee el contenido de un fichero y lo devuelve como una cadena de texto.
  ///
  /// Recibe un parámetro [rutaFichero] que especifica la ruta del fichero a leer.
  ///
  /// Crea una instancia de la clase [File] con la ruta del fichero proporcionada.
  ///
  /// Verifica si el fichero existe utilizando el método [exists] de la clase [File]. Si el fichero existe:
  /// - Lee el contenido del fichero utilizando el método [readAsString] de la clase [File] y espera a que la operación se complete.
  /// - Devuelve el contenido del fichero como una cadena de texto.
  ///
  /// Si el fichero no existe, registra un mensaje de advertencia utilizando [developer.log] indicando la ruta del fichero que no existe.
  /// - Devuelve una cadena de texto vacía.
  ///
  /// Ejemplo de uso:
  ///    String contenido = await leerFichero(rutaFichero: [/ruta/al/fichero.txt]); /// print(contenido);
  ///   /// Esto imprimirá el contenido del fichero especificado en la ruta proporcionada.
  ///
  /// Nota: Asegúrate de proporcionar una ruta de fichero válida para evitar errores y de que el fichero exista antes de leerlo.
  static Future<String> leerFichero({required String rutaFichero}) async {
    File fichero = File(rutaFichero);

    if (await fichero.exists()) {
      String contenidoFichero =
          await fichero.readAsString().then((value) => value);

      return contenidoFichero;
    } else {
      developer.log(
          "La ruta del JSON establecida no existe | aplicacion_ac\lib\controlador\flujoTexto\EscribirYLeerFichero.dart");
      return "";
    }
  }
}
