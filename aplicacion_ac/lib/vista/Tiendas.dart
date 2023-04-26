class Tiendas{

  final String nombre;
  bool clickado = false;
  final String imagen;
  final String tipoClase = "Tiendas";



  Tiendas({required this.nombre, this.clickado = false, required this.imagen});

  //set imgTienda(value) => this.imagenTienda = value;

  get img => imagen;


  @override
    String toString() {
      // TODO: implement toString
      return tipoClase;
    }

}