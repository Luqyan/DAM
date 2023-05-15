import 'dart:async';

///En esta clase se añade todo tipo de funciones estaticas para tratar String que no están por defecto en el lenguaje
class TratarString{
  static String quitarUnidad(String frase){ 
      return frase.toLowerCase().replaceAll(RegExp('€|kg|v|litro|g|G'), "");

    
  }
  static  String eliminarEspacios(String frase){
      return frase.toLowerCase().replaceAll(RegExp('\\s'), "");


  }
  
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

  static String? sustituirComasPorPuntos(String? frase){
    if(frase==null){
      return "";
    }
    return frase.toLowerCase().replaceAll(RegExp(','), ".");
  }
  static printAsincrono(dynamic frase,int tiempoMilisegundos) async{
    if(frase!=null ||frase!="" ){
      print(frase);
    }
    Timer(Duration(milliseconds: tiempoMilisegundos), () {print(frase); });
    
    
  }

  static bool detectarSiTieneRutaHttp(String frase){
    return frase.startsWith(RegExp("http"));
  }
}