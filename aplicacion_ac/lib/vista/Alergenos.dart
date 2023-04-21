class Alergenos{

  final String nombre;
  bool clickado;
  final String imagen;
  final String tipoClase = "Alergenos";
  Alergenos({required this.nombre, this.clickado = false, required this.imagen});

  get img => imagen;


  @override
    String toString() {
      // TODO: implement toString
      return tipoClase;
    }

}