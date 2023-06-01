import TratarString
class Producto:
    #  self.nombreProducto
    #  precio
    #  peso
    #  volumen
    #  marca
    #  categoria
    #  hrefProducto
    #  unidades

    def __init__(self):
        self._nombreProducto=""
        self.precio=0
        self.peso = 0
        self.volumen = 0
        self.marca = ""
        self.categoria = ""
        self.hrefProducto = ""
        self.unidades = ""
    @property
    def nombreProducto(self):
        return self._nombreProducto

    @nombreProducto.setter
    def nombreProducto(self, nomProducto):
        self._nombreProducto = nomProducto
    
    def productoDesdeJson(self, jsonDeUnProducto, i):
        
        if(self.__existeProducto(jsonDeUnProducto,i)):
      
            if jsonDeUnProducto['Producto {}'.format(i)]['Producto'] !="" and self.__existeNombreProducto(jsonDeUnProducto,i):
                self._nombreProducto=jsonDeUnProducto['Producto {}'.format(i)]['Producto']
            else:
                self._nombreProducto="ProductoNoExisteJSON"
            
                
            if(self.__existePrecio(jsonDeUnProducto,i)):
                variable=TratarString.TratarString.quitarUnidadesEspacios(TratarString.TratarString.sustituirComasPorPuntos(jsonDeUnProducto['Producto {}'.format(i)]['Precio']))#Confio en que simpre se devolvera el precio en el jsonDeUnProducto
                if(variable==""):
                    self.precio = 0.0
                    self._nombreProducto="ProductoJSONnoTienePrecio"
                else:
                    self.precio =variable
                
                
                # print("Nombre del Producto: ${ jsonDeUnProducto['Producto {}'.format(i)]['Producto']}")
                # print("Precio: ${jsonDeUnProducto['Producto {}'.format(i)]['Precio']}")
                # print("2")
            else:
                self.precio=0.00
                self._nombreProducto="ProductoJSONnoTienePrecio"
            

            if(self.__existeCaracteristicas(jsonDeUnProducto,i)):
                if(self.__existePesoNeto(jsonDeUnProducto,i)):
                    print(jsonDeUnProducto['Producto {}'.format(i)]['Características']['Peso Neto'])
                    self.peso = TratarString.TratarString.quitarUnidadesEspacios(TratarString.TratarString.sustituirComasPorPuntos(jsonDeUnProducto['Producto {}'.format(i)]['Características']['Peso Neto']))
                
                # print("3")
                else:
                    self.peso="null"
                # print("Peso: ${jsonDeUnProducto['Producto {}'.format(i)]['Características']['Peso Neto']}")
                # print("4")
                
                if(self.__existeVolumen(jsonDeUnProducto,i)):
                    # print("4")
                    # print("Volumen: ${jsonDeUnProducto['Producto {}'.format(i)]['Características']['Volumen']}")
                    self.volumen= TratarString.TratarString.quitarUnidadesEspacios(TratarString.TratarString.sustituirComasPorPuntos(jsonDeUnProducto['Producto {}'.format(i)]['Características']['Volumen']))
                else:
                    # print("5")
                    # print("Volumen: ${jsonDeUnProducto['Producto {}'.format(i)]['Características']['Volumen']}")
                    self.volumen= "null"
                

                # print("6")
                # print("Marca: ${jsonDeUnProducto['Producto {}'.format(i)]['Características']['Marca']}")
                if(self.__existeMarca(jsonDeUnProducto,i)):
                    self.marca = jsonDeUnProducto['Producto {}'.format(i)]['Características']['Marca']
                else:
                    self.marca = "null"
                

            else:
                # print("8")
                self.peso="null"
                self.volumen="null"
                self.marca="null"
                # print("9")
            
            if(self.__existeCategoria(jsonDeUnProducto,i)):
                self.categoria= jsonDeUnProducto['Producto {}'.format(i)]['Categoria']


            if(TratarString.TratarString.detectarSiTieneRutaHttp(jsonDeUnProducto['Producto {}'.format(i)]['Imagen']) and self.__existeImagen(jsonDeUnProducto,i)):
                self.hrefProducto= jsonDeUnProducto['Producto {}'.format(i)]['Imagen']
            else:
                self.hrefProducto="assets/imageproductonoencontrada.jpg"
            


            
            # # print("11")
        else:
            self._nombreProducto="ProductoNoExisteJSON"
            self.precio=0.00
            self.hrefProducto=""
        self.unidades=0


    def __existeProducto(self,jsonDeproductos:str,numeroProducto:int):
        existepar=False; 
        try:
            jsonDeproductos["Producto {}".format(numeroProducto)]
            return True
        except Exception as a:
            print("No existe el par con la clave:{}".format(a))
            return False
        
    def __existeNombreProducto(self,jsonDeproductos:str,numeroProducto:int):
        existepar=False; 
        try:
            jsonDeproductos['Producto {}'.format(numeroProducto)]['Producto']
            return True
        except Exception as a:
            print("No existe el par con la clave:{}".format(a))
            return False
        
    def __existePrecio(self,jsonDeproductos:str,numeroProducto:int):
        existepar=False; 
        try:
            jsonDeproductos['Producto {}'.format(numeroProducto)]['Precio']
            return True
        except Exception as a:
            print("No existe el par con la clave:{}".format(a))
            return False

    def __existeCaracteristicas(self,jsonDeproductos:str,numeroProducto:int):
        existepar=False; 
        try:
            jsonDeproductos['Producto {}'.format(numeroProducto)]['Características']
            return True
        except Exception as a:
            print("No existe el par con la clave:{}".format(a))
            return False
        
    def __existePesoNeto(self,jsonDeproductos:str,numeroProducto:int):
        existepar=False; 
        try:
            jsonDeproductos['Producto {}'.format(numeroProducto)]['Características']['Peso Neto']
            return True
        except Exception as a:
            print("No existe el par con la clave:{}".format(a))
            return False
        
    def __existeVolumen(self,jsonDeproductos:str,numeroProducto:int):
        existepar=False; 
        try:
            jsonDeproductos['Producto {}'.format(numeroProducto)]['Características']['Volumen']
            return True
        except Exception as a:
            print("No existe el par con la clave:{}".format(a))
            return False
        
    def __existeMarca(self,jsonDeproductos:str,numeroProducto:int):
        existepar=False; 
        try:
            jsonDeproductos['Producto {}'.format(numeroProducto)]['Características']['Marca']
            return True
        except Exception as a:
            print("No existe el par con la clave:{}".format(a))
            return False
        
    def __existeImagen(self,jsonDeproductos:str,numeroProducto:int):
        existepar=False; 
        try:
            jsonDeproductos['Producto {}'.format(numeroProducto)]['Imagen']
            return True
        except Exception as a:
            print("No existe el par con la clave:{}".format(a))
            return False
        
    def __existeCategoria(self,jsonDeproductos:str,numeroProducto:int):
        existepar=False; 
        try:
            jsonDeproductos['Producto {}'.format(numeroProducto)]['Categoria']
            return True
        except Exception as a:
            print("No existe el par con la clave:{}".format(a))
            return False