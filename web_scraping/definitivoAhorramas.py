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

driver.get("https://www.ahorramas.com/alimentacion")

existe = True
vueltas=0
while (existe):
    try:
        # NOS ASEGURAMOS QUE EL BOTON SE HA CARGADO
        # espera_boton = WebDriverWait(driver, 10).until(EC.visibility_of_element_located((By.CSS_SELECTOR, '.btn.btn-outline-primary.col-12.col-sm-4.more')))
        time.sleep(3)
        
        # BUSCAMOS Y PINCHAMOS EL BOTON
        boton = driver.find_element(By.CSS_SELECTOR, value='.btn.btn-outline-primary.col-12.col-sm-4.more')       
        
        boton.click()
        
        time.sleep(random.randint(1,3))

        #existe=existe+1
   
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


print("Pagina fuera del bucle:" ,driver.current_url)
time.sleep(4)
productos = driver.find_elements(By.CLASS_NAME, value= "product-tile")
print(len(productos))
time.sleep(random.randint(1,3))
productosAhorraMas={}
count=0
for e in productos:
    try:
        count=count+1
        categoria = e.get_attribute('data-category2')
        subcategoria = e.get_attribute('data-category3')
        precio = e.find_element(By.CLASS_NAME, 'value').text
        articulo = e.find_element(By.TAG_NAME, 'h2').text
        imagen=e.find_element(By.CLASS_NAME, 'product-pdp-link').get_attribute('href')
        print("pagOriginal",driver.current_url)
        drivernuevo= webdriver.Chrome()
        enlace_producto = e.find_element(By.CLASS_NAME, value="product-pdp-link ").get_attribute('href')
        drivernuevo.get(enlace_producto)
        time.sleep(1)
        print("enlace pinchado:",driver.current_url)
        #recogemos los datos
    
        caracteristicas = drivernuevo.find_elements(By.ID, value="collapseInfo")
        elementos={}
        for i in caracteristicas:
            print("Entor en el bucle")
            print(i.text)
            cosas=i.find_elements(By.TAG_NAME, 'p')
            contador=0
            for b in cosas:
                if "Marca" in b.text:
                    #que contiene la cadena "Marca : danone". Luego, hemos utilizado la función "split()" para dividir el string en dos partes en el carácter ":". La variable "partes" es una lista con dos elementos: "Marca " y " danone".
                    #Finalmente, hemos seleccionado la segunda parte de la lista resultante (índice 1) utilizando la sintaxis de corchetes, y hemos eliminado cualquier espacio en blanco alrededor del texto utilizando la función "strip()". El resultado final es la cadena "danone"
                    partesMarca=(b.text).split(":")
                    elementos['Marca']= partesMarca[1].strip()
                if "Peso Neto" in b.text:
                    partesPeso=(b.text).split(":")
                    elementos['Peso Neto']= partesPeso[1].strip()
                if "Volumen" in b.text:
                    partesVolumen=(b.text).split(":")
                    elementos['Volumen']= partesVolumen[1].strip()
        
        imagensita=drivernuevo.find_element(By.CLASS_NAME, value="zoom-img-origin")
        print("no da fallo buscar imagen")
        
        print("imagensita: ",(imagensita.find_element(By.TAG_NAME, value="img")).get_attribute("src"))
        imagen=(imagensita.find_element(By.TAG_NAME, value="img")).get_attribute("src")
        #implicity wait
        print("elementos: ",elementos)

        #volvemos a la pagina anterior
        drivernuevo.close()
        time.sleep(random.randint(1,3))
        print("pagBack:",driver.current_url)
        print("Categoria padre: ", str(categoria))
        print("Subcategoria: ", subcategoria)
        print("Precio: ",precio)
        print("Nombre articulo: ",articulo)
        print("imagen: ",imagen)
        print("///////////////////////////////////////////////////////")

        datosProducto={"Producto":articulo,
                    "Precio":precio,
                    "Categoria":subcategoria,
                    "Imagen":imagen,
                    "Características":elementos}
        print("-------------------DICCIONARIO-----------------")
        print(datosProducto)
        
        productosAhorraMas["Producto "+str(count)]=datosProducto
    except Exception:
        continue

json_datosProductos=json.dumps(productosAhorraMas, ensure_ascii=False).encode('utf-8')
    #hemos utilizado la función open() para abrir un archivo llamado "datos.json" en modo de escritura ('w'). Hemos escrito la cadena JSON en el archivo utilizando la función write() y hemos cerrado el archivo utilizando el bloque with
with open('productosAhorramass.json', 'wb') as archivo:
    archivo.write(json_datosProductos) #= json.dump(json_datosProductos, archivo) -->  otra forma de escribirlo pero en vez de con write, es con el dump

driver.quit()