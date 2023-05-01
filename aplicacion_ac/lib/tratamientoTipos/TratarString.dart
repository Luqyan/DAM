///En esta clase se añade todo tipo de funciones estaticas para tratar String que no están por defecto en el lenguaje
class TratarString{
  static String quitarUnidad(String frase){ 
      return frase.toLowerCase().replaceAll(RegExp('€|kg|v|litro'), "");

    
  }
  static  String eliminarEspacios(String frase){
      return frase.toLowerCase().replaceAll(RegExp('\s'), "");


  }
    
  
  static double? quitarUnidadesEspacios(String? frase){
    if(frase==null){
      return null;
    }
    String resultado= quitarUnidad(frase);
    return double.parse(eliminarEspacios(resultado));
    
    
  }

  static String? sustituirComasPorPuntos(String frase){
    if(frase==null){
      return "";
    }
    return frase.toLowerCase().replaceAll(RegExp(','), ".");
  }
  
}