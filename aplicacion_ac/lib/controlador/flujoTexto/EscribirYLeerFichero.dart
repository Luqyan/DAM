import 'dart:io';
import 'dart:developer' as developer;
class EscribirYLeerFichero {
	

  ///devuelve:
  ///
  ///   -el contenido del JSON: Si encuentra el fichero lo devulve en String
  /// 
  ///   -0: Si no ha encontrado el fichero
	static Future<String> leerFichero({required String rutaFichero}) async {
		File fichero=File(rutaFichero);
   
;    if( await fichero.exists()){
  
			String contenidoFichero = await fichero.readAsString().then((value) => value);
      
			return contenidoFichero;
		}else{
      developer.log("La ruta del JSON establecida no existe | aplicacion_ac\lib\controlador\flujoTexto\EscribirYLeerFichero.dart");
      return "";
		}
      

	}
}
