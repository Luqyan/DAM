import 'dart:async';
import 'dart:math';

import 'package:aplicacion_ac/modelo/Producto.dart';
import 'package:aplicacion_ac/modelo/Tienda.dart';
import 'dart:developer' as developer;
class Select{

  static Producto buscarProductoPorNombre({required String nomProducto, required String nomTienda}){
    Tienda.obtenerProductosJsonAhorraMas().then((productos){
      Producto ProductoResultado=Producto(nombreProducto: "Producto no encontrado", precio: 0.00, hrefImgProducto: "./imagenes/imagen-no-encontrada.png");
      if(nomTienda.toLowerCase()=="ahorramas"){
        
          for (Producto produc in productos) {
            if(produc.nombreProducto==nomProducto){
              ProductoResultado=produc;
            }
          }
      }else{
        developer.log("Error: El nombre de la tienda o es ahorramas | aplicacion_ac\\lib\\controlador\\Json\\DML\\Select.dart");
      }
      return ProductoResultado;
    });
    

  }
}