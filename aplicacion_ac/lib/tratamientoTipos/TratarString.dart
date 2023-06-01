import 'dart:async';

/// Clase que contiene métodos para tratar cadenas de texto.
class TratarString{

/// Elimina las unidades de medida de una frase.
/// [frase]: La frase de la que se desean eliminar las unidades.
/// Retorna la frase sin las unidades de medida.
static String quitarUnidad(String frase){
return frase.toLowerCase().replaceAll(RegExp('€|kg|v|litro|g|G'), "");
}

/// Elimina los espacios en blanco de una frase.
/// [frase]: La frase de la que se desean eliminar los espacios.
/// Retorna la frase sin espacios en blanco.
static String eliminarEspacios(String frase){
return frase.toLowerCase().replaceAll(RegExp('\s'), "");
}

/// Quita las unidades de medida y los espacios en blanco de una cadena de texto.
/// [frase]: La cadena de texto de la que se desean quitar las unidades y los espacios.
/// Retorna el valor numérico sin unidades ni espacios en blanco.
static double? quitarUnidadesEspacios(String? frase){
if(frase==null){
return null;
}
if(frase==""){
frase="0";
}
String resultado= quitarUnidad(frase);
return double.parse(eliminarEspacios(resultado));
}

/// Sustituye las comas por puntos en una cadena de texto.
/// [frase]: La cadena de texto en la que se desean sustituir las comas.
/// Retorna la cadena de texto con las comas sustituidas por puntos.
static String? sustituirComasPorPuntos(String? frase){
if(frase==null){
return "";
}
return frase.toLowerCase().replaceAll(RegExp(','), ".");
}

/// Imprime de forma asíncrona una frase después de un determinado tiempo en milisegundos.
/// [frase]: La frase que se desea imprimir.
/// [tiempoMilisegundos]: El tiempo en milisegundos después del cual se imprime la frase.
static printAsincrono(dynamic frase, int tiempoMilisegundos) async{
if(frase!=null ||frase!="" ){
}
Timer(Duration(milliseconds: tiempoMilisegundos), () {});
}

/// Detecta si una cadena de texto comienza con una ruta HTTP.
/// [frase]: La cadena de texto que se desea analizar.
/// Retorna true si la cadena comienza con una ruta HTTP, de lo contrario retorna false.
static bool detectarSiTieneRutaHttp(String frase){
return frase.startsWith(RegExp("http"));
}
}