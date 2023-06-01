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
        numero=int(input("""Pasar JSON -> CSV de archivos webscraping
    Pulse:
    - 1 : Carrefour
    - 2 : Ahorramas
    - 3 : Todos los productos
    - 9 : Salir
    """))
        if(numero==1):
            contructorCsv(ficherosIdTienda=[(f"{obtenerRutaFicheroMain()}\jsons\productosCarrefour.json",2)],nombreFichero="carrefour")
        elif(numero==2):
            contructorCsv(ficherosIdTienda=[(f"{obtenerRutaFicheroMain()}\jsons\productosAhorramas.json",1)],nombreFichero="ahorramas")
        elif(numero==3):
            contructorCsv(ficherosIdTienda=[(f"{obtenerRutaFicheroMain()}\jsons\productosAhorramas.json",1),(f"{obtenerRutaFicheroMain()}//jsons//productosCarrefour.json",2)],nombreFichero="productos")
        elif(numero==9):
            mensajeSalir()
            sys.exit()

def contructorCsv(ficherosIdTienda:list,nombreFichero:str):
    filas=[]
    idproducto=1
    anadirCabeceraCSV(filas)
    for fichId in ficherosIdTienda:
        fich,idTienda=fichId #Se recoge la tupla y se instancia la ubicacion y el id de la tienda en los productos
        print("fichero: "+fich)
        print("IdTienda: "+str(idTienda))
        numeroDeProductoNoEcontrados=0
        buscandoProducto=1#Sive para saber el numero del producto que se esta buscando, se usa para la busqueda del objeto en el JASON

        with open(fich, 'r',encoding='utf-8') as file:
            fichero = file.read()
            jsons=json.loads(fichero)
            

            while True:
                producto= Producto()
                producto.productoDesdeJson(jsons,buscandoProducto)

                if(producto.nombreProducto=="ProductoNoExisteJSON" or producto.nombreProducto=="ProductoJSONnoTienePrecio"):
                    numeroDeProductoNoEcontrados=numeroDeProductoNoEcontrados+1
                    buscandoProducto=buscandoProducto+1
                else:
                    anadirJSON(filas,producto,idproducto,idTienda)
                    idproducto=idproducto+1
                    buscandoProducto=buscandoProducto+1
                    numeroDeProductoNoEcontrados=0


                if numeroDeProductoNoEcontrados>50:
                    break
            
        with open('csv//{}.csv'.format(nombreFichero), 'w', encoding='utf-8',newline="") as file:
            writer = csv.writer(file)
            writer.writerows(filas)
    print(f"\nIntroducidos {len(filas)-1} productos")#Se resta 1 ya que el primero es la cabecera
    print("Fichero generado en la carpeta csv\n")

def anadirJSON(filas,producto:Producto,indice:int,idTienda:int):
    fila=[]
    fila.append(indice)
    fila.append(idTienda)
    fila.append(producto.nombreProducto)
    fila.append(producto.precio)
    fila.append(producto.peso)
    fila.append(producto.volumen)
    fila.append(producto.marca)
    fila.append(producto.categoria)
    fila.append(producto.hrefProducto)
    filas.append(fila)

def anadirCabeceraCSV(filas):
    fila=[]
    fila.append("id")
    fila.append("idTienda")
    fila.append("nombre")
    fila.append("precio")
    fila.append("categario")
    fila.append("marca")
    fila.append("peso")
    fila.append("volumen")
    fila.append("imagen")
    filas.append(fila)

def obtenerRutaFicheroMain():
    return os. getcwd()

if __name__ == "__main__":
        main()
