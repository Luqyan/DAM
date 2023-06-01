
/// Clase que representa un alérgeno.
class Alergenos{
final String nombre;
bool clickado;
final String imagen;
final String tipoClase = "Alergenos";

/// Constructor de la clase Alergenos.
Alergenos({required this.nombre, this.clickado = false, required this.imagen});

/// Obtiene la imagen del alérgeno.
get img => imagen;

@override
String toString() {
// TO DO: implement toString
return tipoClase;
}
}