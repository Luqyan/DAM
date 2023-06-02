import random
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
import selenium.common.exceptions   
import time
import json

driver = webdriver.Chrome()

driver.get("https://www.carrefour.es/supermercado/la-despensa/cat20001/c")
options = webdriver.ChromeOptions()
options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3')
CarrefourProductos={}
existe = 0
pagina=0
 
while (existe<32):
    try:
        time.sleep(3)
        existe=existe+1
        # BUSCAMOS Y PINCHAMOS EL BOTON
        boton = driver.find_element(By.CSS_SELECTOR, value='span.pagination__next.icon-right-arrow-thin')  
        #boton = driver.find_element(By.XPATH, '/html/body/div[3]/div/main/div[3]/div[1]/div[2]/div[2]/div[3]/div/div[2]/div/a[2]/span')     
        boton.click()
        
        time.sleep(random.randint(1,3))
        print("Entramos en una nueva pagina")
        #ahora tenemos q sacar la info de los productos 
        productos = driver.find_elements(By.CLASS_NAME, value= "product-card")
        print("Productos: ", len(productos))
        i=0
        productonum=0
        pagina=pagina+1
        print("PAGINA: ",pagina)
        
        for e in productos:
            try:
                datosProducto={}
                time.sleep(random.randint(1,2))
                i=i+1
                productonum=productonum+1
                print("Num Producto",productonum)
                print("Producto ",i," ",e.text)
                nombreProducto= e.find_elements(By.TAG_NAME, value="h2")
                for a in nombreProducto:
                    print("Nombre producto: ",a.text)
                    datosProducto["Producto"]=a.text
                precioProducto=e.find_elements(By.CLASS_NAME, value="product-card__price")
                for b in precioProducto:
                    print("Precio: ",b.text)
                    datosProducto["Precio"]=b.text
                imagenProducto=e.find_elements(By.CLASS_NAME, value="product-card__media")
                for c in imagenProducto:
                   print("Imagen: ",c.find_element(By.TAG_NAME, value="img").get_attribute("src")) 
                   datosProducto["Imagen"]=c.find_element(By.TAG_NAME, value="img").get_attribute("src")
                print("//////////////////////////////////////")
                #entrar en cada producto y sacar las caracteristicas
                linkProducto=e.find_elements(By.CSS_SELECTOR, value="a.link.product-card__title-link.track-click") 
                driverCaracteristicas= webdriver.Chrome() #creamos un nuevo driver para acceder al producto 
                for d in linkProducto:
                    print("Link producto: ",d.get_attribute('href')) #cogemos el linkdel producto accediendo al atributo href
                    #Prueba para meterse dentro del producto
                    driverCaracteristicas.get(d.get_attribute('href')) #El nuevo driver se conectará al link de ese producto (recuerda que cada vuelta de bucle es un producto, en realidad habria q usar findelement y no hacer bucles pero si no, salta error)
                    time.sleep(1) #Usamos time.sleep(1) para que de tiempo a cargar la pagina
                    caracteristicasProducto={}
                    caracteristicas = driverCaracteristicas.find_elements(By.CLASS_NAME, value="nutrition-more-info__box")#sacammos las caracteristicas
                    for f in caracteristicas:
                        informacion=f.find_elements(By.CLASS_NAME, value="info-txt") #dentro de las caracteristicas sacamos la informacion
                        for g in informacion:
                            if "Contenido neto" in g.text:
                                print("Peso: ",g.text) #Mostramos info de las caracteristicas 
                                peso=(g.text).split(":")
                                peso2=peso[1]
                                print("Peso neto: ",peso2)
                                if  peso2 == "":
                                    caracteristicasProducto["Peso Neto"]="-"
                                else:
                                    caracteristicasProducto["Peso Neto"]=peso2
                            if "fabricante" in g.text:
                                print("Informasion: ",g.text) #Mostramos info de las caracteristicas
                                marca=(g.text).split(":")
                                marca2=marca[1]
                                print("Marca: ",marca2)
                                if marca2 == "":
                                    caracteristicasProducto["Marca"]="-"
                                else:
                                    caracteristicasProducto["Marca"]=marca2
                        datosProducto["Características"]=caracteristicasProducto

                print(datosProducto)
                CarrefourProductos["Producto"+str(productonum)]=datosProducto
            except selenium.common.StaleElementReferenceException:
                print("Error en el bucle de recogida de datos de productos")
                pass
        print("JSON: ",CarrefourProductos)
        print("HOLA")
        time.sleep(2)  

    except selenium.common.NoSuchElementException:
        existe = False
        print("Error")
        # Seguimos conel codigo a pesar del error
        # Podemos
        continue

    except Exception:
        pass
   
    finally:
        url_final = driver.current_url
        # COMPRUEBO QUE LA URL HA CAMBIADO
        print(driver.current_url)
        pass

json_datosProductos=json.dumps(CarrefourProductos, ensure_ascii=False).encode('utf-8')
    #hemos utilizado la función open() para abrir un archivo llamado "datos.json" en modo de escritura ('w'). Hemos escrito la cadena JSON en el archivo utilizando la función write() y hemos cerrado el archivo utilizando el bloque with
with open('productosCarrefourdespensaa.json', 'wb') as archivo:
    archivo.write(json_datosProductos) #= json.dump(json_datosProductos, archivo) -->  otra forma de escribirlo pero en vez de con write, es con el dump

driver.quit()