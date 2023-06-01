from mensajesAscii import mensajeBienvenida
from mensajesAscii import mensajeSalir
import time
import json  
from Producto import Producto
import csv
import sys
import os

def main():
    mensajeBienvenida()
    while(True):
        numero=int(input("""Pasar JSON -> SQLite de archivos webscraping
    Pulse:
    - 1 : Solo los CREATE TABLE de la BBDD

    - 2 : Todos los Insert de todas las tablas
    - 3 : Solo Insert Productos Carrefour
    - 4 : Solo Insert Productos Ahorramas

    - 5 : Toda la creción de BBDD completa

    - 9 : Salir
    """))
        if(numero==1):
            contructorSQL(generarCreate=True,generarInsert=False)
        elif(numero==2):
             contructorSQL(ficherosIdTienda=[(f"{obtenerRutaFicheroMain()}\jsons\productosAhorramas.json",1),(f"{obtenerRutaFicheroMain()}//jsons//productosCarrefour.json",2)],generarCreate=False,generarInsert=True)
        elif(numero==3):
            contructorSQL(ficherosIdTienda=[(f"{obtenerRutaFicheroMain()}\jsons\productosAhorramas.json",1)],generarCreate=False,generarInsert=True)
        elif(numero==4):
            contructorSQL(ficherosIdTienda=[(f"{obtenerRutaFicheroMain()}\jsons\productosCarrefour.json",1)],generarCreate=False,generarInsert=True)
        elif(numero==5):
            contructorSQL(ficherosIdTienda=[(f"{obtenerRutaFicheroMain()}\jsons\productosAhorramas.json",1),(f"{obtenerRutaFicheroMain()}\jsons\productosAhorramas.json",2)],generarCreate=True,generarInsert=True)
        elif(numero==9):
            mensajeSalir()
            sys.exit()

def contructorSQL(generarInsert:bool,generarCreate:bool,ficherosIdTienda:list=[]):

    
    with open('SQLite//querys.sql', 'w', encoding='utf-8',newline="") as ficheroEscribir:
        if(generarCreate==True):
            ficheroEscribir.write(creadorContructoresSQL())
        
        if(generarInsert==True):
            
            ficheroEscribir.write(creadorInsertTiendaSQL())
            for fichId in ficherosIdTienda:

                fich,idTienda=fichId #Se recoge la tupla y se instancia la ubicacion y el id de la tienda en los productos
                print("fichero: "+fich)
                print("IdTienda: "+str(idTienda))
                numeroDeProductoNoEcontrados=0
                buscandoProducto=1#Sive para saber el numero del producto que se esta buscando, se usa para la busqueda del objeto en el JASON

                with open(fich, 'r',encoding='utf-8') as ficheroLeer:
                    fichero = ficheroLeer.read()
                    jsons=json.loads(fichero)
                    
                    while True:
                        producto= Producto()
                        producto.productoDesdeJson(jsons,buscandoProducto)

                        if(producto.nombreProducto=="ProductoNoExisteJSON" or producto.nombreProducto=="ProductoJSONnoTienePrecio"):
                            numeroDeProductoNoEcontrados=numeroDeProductoNoEcontrados+1
                            buscandoProducto=buscandoProducto+1
                        else:
                            ficheroEscribir.write(creadorInsertProductoSQL(producto,idTienda))
                            buscandoProducto=buscandoProducto+1
                            numeroDeProductoNoEcontrados=0

                        if numeroDeProductoNoEcontrados>50:
                            break
                                
        ficheroEscribir.close()


    print("Fichero generado en la carpeta SQLite\n")

def creadorInsertProductoSQL(producto:Producto,idTienda:int):
    if producto.nombreProducto.find("'"):
        producto.nombreProducto=producto.nombreProducto.replace("'","''")
        
        if(type(producto.marca)==str):

            if(producto.marca.find("'")):
                producto.marca=producto.marca.replace("'","''")
        return "INSERT INTO productos (idTienda,nombre,precio,categoria,marca,peso,volumen,imagen) VALUES({},'{}',{},'{}','{}',{},{},'{}');\n".format(idTienda,producto.nombreProducto,producto.precio,producto.categoria,producto.marca,producto.peso,producto.volumen,producto.hrefProducto)
    else:
        return "INSERT INTO productos (idTienda,nombre,precio,categoria,marca,peso,volumen,imagen) VALUES({},'{}',{},'{}','{}',{},{},'{}');\n".format(idTienda,producto.nombreProducto,producto.precio,producto.categoria,producto.marca,producto.peso,producto.volumen,producto.hrefProducto)
    
def creadorInsertTiendaSQL():
    querys="INSERT INTO tiendas (nombre,imagen) VALUES('{}','{}');".format("ahorramas","https://www.mercadoventas.es/wp-content/uploads/2018/03/LOGO-AHORRAMAS2.jpg")
    querys=querys+"\nINSERT INTO tiendas (nombre,imagen) VALUES('{}','{}');".format("carrefour","https://upload.wikimedia.org/wikipedia/commons/5/5b/Carrefour_logo.svg")
    return querys

def creadorContructoresSQL():
    return """DROP TABLE IF EXISTS tiendas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS listas_favoritas;
DROP TABLE IF EXISTS productos_listas;
DROP TABLE IF EXISTS productos_favoritos;
CREATE TABLE IF NOT EXISTS tiendas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT UNIQUE NOT NULL,
		  imagen TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS productos (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
		  idTienda INTEGER NOT NULL,
          nombre TEXT NOT NULL,
          precio REAL NOT NULL,
          categoria TEXT,
          marca TEXT,
          peso REAL,
          volumen REAL,
          imagen TEXT NOT NULL,
		  FOREIGN KEY(idTienda) REFERENCES tiendas(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS listas_favoritas(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	nombre TEXT NOT NULL
	
);


CREATE TABLE IF NOT EXISTS productos_listas(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	idListaFavorita INTEGER NOT NULL,
	nombreProducto TEXT NOT NULL,
    cantidad INTEGER NOT NULL,
	FOREIGN KEY(idListaFavorita) REFERENCES listas_favoritas(id)
);


CREATE TABLE IF NOT EXISTS productos_favoritos(
	id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT UNIQUE,
    imagen TEXT UNIQUE
);"""

def obtenerRutaFicheroMain():
    return os. getcwd()

if __name__ == "__main__":
        main()
