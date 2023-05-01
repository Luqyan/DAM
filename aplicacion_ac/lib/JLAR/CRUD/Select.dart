import 'dart:async';

import 'package:aplicacion_ac/modelo/Producto.dart';
import 'package:aplicacion_ac/modelo/Tienda.dart';
import 'dart:developer' as developer;
class Select{

  static Future<List<Producto>> buscarProductosPorNombre({required String nomProducto, required String nomTienda, int limit=0, }) async{
    List<Producto> productosResultado=[Producto(nombreProducto: "Producto no encontrado", precio: 0.00, hrefImgProducto: "./imagenes/imagen-no-encontrada.png")];
    
    if(nomTienda.toLowerCase()=="ahorramas" || nomTienda.toLowerCase()=="carrefour"){
      print("Hola gustavo1");
      List<Producto> todosProductosDeTienda=await Tienda.obtenerProductosDeJson(nomTienda);
            
            print("Hola gustavo2");
      for (Producto produc in todosProductosDeTienda) {
        if(produc.nombreProducto==nomProducto){
          if(productosResultado.length==1){
            print("Impresion1");
            productosResultado[0]=(produc);
          }else{
            print("impresion2");
            productosResultado.add(produc);
          }
          
        }
      }
    }else{
        developer.log("Error: No ha introducido el nombre de tienda correcto | aplicacion_ac\\lib\\controlador\\Json\\DML\\Select.dart");
    }
    //____________Logica LIMIT_____________

    if(limit>0 && limit<productosResultado.length){
      List<Producto> productosDespuesDeLimit=List.empty(growable: true);

      for(int i=0;i<=limit;i++ ){
        productosDespuesDeLimit.add(productosResultado[i]);
      }
      productosResultado=productosDespuesDeLimit;
      
    }
  return productosResultado;
  }
}