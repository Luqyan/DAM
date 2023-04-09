class Lista {

  late String _nombre;
  late String _descripcion;


  
  
  // Rename this constructor to use the class name as its identifier

  Lista( String nom, String des){

    _nombre = nom;
    _descripcion = des;
  }


  String get nombre{

    return _nombre;
  }

  set nombre(String nom){

    _nombre = nom;
  }


  String get descripcion{

    return _descripcion;
  }


  set descripcion(String des){

    _descripcion = des;
  }

}
