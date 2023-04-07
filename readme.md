# COMPARADOR DE PRECIOS
## Version: Agustin 1.0
Para este proyecto se usara el patron de diseño **MVC** para ello se tendrña que seguir las siguientes reglas:

1. Se trabajara siempre edntro de la carpeta lib cuando se trabajan con los .dart
2. El **main** debe estar dentro de lib, si no pasará lo [esto](https://stackoverflow.com/questions/71011955/where-is-lib-main-dart-in-android-studio).
3. Crear los ficheros **.dart** dentro de las carpetas *Modelo*, *Vista*, *Controlador*.
4. No se puede crear una clase en la mismo fichero donde se usan widget

## Recordatorio de Modelo MVC
* **Modelo**: Carpeta que guarda todo lo que tiene que ver con la BBDD tanto conexión como las clases que se usarán, si se usa una API.
* **Controlador**: En esta carpeta se debe meter Conexión entre la BBDD y la Vista como son:
    *  Setter y getter que usara *vista*, ojo no son getter y setter de la clases de modelo 
    * Cierta lógica que no encage del todo en la capeta modelo, como por ejemplo el comparador centralizado.
* **Vista**: Carpeta que se encarga de qué verá el usuario en su pantalla y cómo.

<u style="color:red">Se pueden añadir más carpetas dentro de las carpetas Modelo, COntrolador y Vista si hay muchos ficheros.</u>

## Enlaces interesantes para el trabajo
* [Pagina donde esta todas las libreris de flutter](https://pub.dev/)
* [pagina para organizarno](https://trello.com/)
* [Documentacion de flutter en español](https://esflutter.dev/docs)
