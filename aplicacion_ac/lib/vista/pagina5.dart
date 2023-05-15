import 'package:flutter/material.dart';
import 'pagina1.dart';
import 'pagina3.dart';
import 'pagina4.dart';
import 'pagina5.dart';
import 'menugeneral.dart';

// CLASE PRINCIPAL CREADORA DE 'HOME'
class Pagina5 extends StatefulWidget {
  const Pagina5({
    super.key,
  });

  @override
  State<Pagina5> createState() => _Pagina5();
}

/////////////////////////////////////1 ª PARTE//////////////////////////////////////////////
// CLASE ANIMADO
class _Pagina5 extends State<Pagina5> with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  // metodos controladores de estados
  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  // metodo creacion Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 239, 188, 1),
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(context),
          _buildDrawer(),
        ],
      ),
    );
  }

  // hay que acceder
//////////////////////////////////////////////////////////////////////////////////////////
  // método de creación de appBar personalizado
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const Image(image: 
        AssetImage('assets/logo4.png'),
        filterQuality: FilterQuality.high,
      ),
      title: const Text(
        'Configuración cuenta',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Color.fromARGB(0, 44, 202, 246),
      elevation: 3,
      automaticallyImplyLeading: false,
      actions: [
        AnimatedBuilder(
          animation: _drawerSlideController,
          builder: (context, child) {
            return IconButton(
              onPressed: _toggleDrawer,
              icon: _isDrawerOpen() || _isDrawerOpening()
                  ? const Icon(
                      Icons.clear,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
            );
          },
        ),
      ],
    );
  }

/////////////////////////////////////////////////////
  // AQUI AÑADIMOS EL CONTENIDO DE LA PAGINA (BODY)////
  // METODO QUE DEVUELVE UN SIZED BOX CON SUS VALORES//
  Widget _buildContent(conte) {
    // Put page content here.

    String _valor_modo = 'Modo oscuro';
    String _valor_tiendas = 'Careffour';
    return SizedBox(
        
        child: Column(
          
          mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [


          // Cuadro Cambio de foto
              Container(
                alignment: Alignment.center,
                
                height: 160,
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/carts.jpg'),
                  fit: BoxFit.cover
                  )
                 
               
                //border: Border.all(color: Colors.blueAccent),
                //color: Color.fromRGBO(252, 196, 196, 0.498),
                ),
                width: MediaQuery.of(context).size.width / 2.2,
                margin: EdgeInsets.all(8.0),
                padding: EdgeInsets.all(3.0),
                
                child: const SizedBox(
                  child: Row(
                    mainAxisSize: MainAxisSize.min, 
                    children: [
                // Imagen perfil
                      CircleAvatar(
                        radius: 50,
                    
                        backgroundImage:AssetImage('assets/einstein.jpg'),
                      ),
                      // Cuadro información
                      SizedBox(
                  
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Foto perfil:",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Cambie aquí su foto de perfil.",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255)),
                            ),
                          ]),
                    ),
                  ]
                ),
              ),
            ),



        Expanded(
          child: ListView(
            padding:EdgeInsets.all(50.0),
            children: [
            ////los elementos de la página dentro de una lista scrollable

            /////////////////////////////////////////////////////////////////////////////////////////////////////
            // Sección Elección modo pantalla
            SizedBox(
                height: 90.0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Elegir modo:",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                      DropdownButton(
                        borderRadius: BorderRadius.circular(15),
                        dropdownColor: Color.fromARGB(255, 228, 207, 201),
                        isExpanded: true,
                        padding: const EdgeInsets.all(10.0),
                        items: <String>['Modo oscuro', 'Modo normal']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        icon: const Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 30,
                        ),

                        iconSize: 15,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),

                        // Actualizamos el valor seleccionado
                        value: _valor_modo,
                        onChanged: (String? valorActual) {
                          setState(() {
                            _valor_modo = valorActual!;
                          });
                        },
                      ),
                    ])),

            const SizedBox(
              height: 50.0,
            ),

            //////////////////////////////////////////////////////////////////////////////////////////////////
            // Sección 'Tiendas favoritas'
            SizedBox(
                height: 90.0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Elegir tiendas favoritas:",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                      DropdownButton(
                        borderRadius: BorderRadius.circular(15),
                        dropdownColor: Color.fromARGB(255, 228, 207, 201),
                        isExpanded: true,
                        padding: const EdgeInsets.all(10.0),
                        items: <String>['AhorraMás', 'Careffour', 'Supercor']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        icon: const Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 30,
                        ),

                        iconSize: 15,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),

                        // Actualizamos el valor seleccionado
                        value: _valor_tiendas,
                        onChanged: (String? valorActual) {
                          setState(() {
                            _valor_tiendas = valorActual!;
                          });
                        },
                      ),
                    ]
                    )
                    ),

            const SizedBox(
              height: 50.0,
            ),

            /////////////////////////////////////////////////////////////////////////////////////////////////////
            // Doble autenticación

            const SizedBox(
              height: 100.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Introducir tu número de teléfono",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Teléfono',
                      ),
                    ),
                  ]),
            ),
            ]
        )
        )
        

        ]
        )
        );
    
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////

  // METODO QUE DEVUELVE UN BUILDER ANIMADO
  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1.0 - _drawerSlideController.value, 0.0),
          child: _isDrawerClosed() ? const SizedBox() : const Menu(),
        );
      },
    );
  }
}
