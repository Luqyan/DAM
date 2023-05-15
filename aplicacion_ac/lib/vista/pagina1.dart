import 'package:aplicacion_ac/vista/pagina7.dart';
import 'package:flutter/material.dart';
import 'pagina2.dart';

import 'menugeneral.dart';

// void main() {
//   runApp(
//     const MaterialApp(
//       home: Pagina1(),
//       debugShowCheckedModeBanner: false,
//     ),
//   );
// }


// CLASE PRINCIPAL CREADORA DE 'HOME'
class Pagina1 extends StatefulWidget {
  const Pagina1({
    super.key,
  });

  @override
  State<Pagina1> createState() =>
      _Pagina1();
}



/////////////////////////////////////1 ª PARTE//////////////////////////////////////////////
// CLASE ANIMADO
class _Pagina1 extends State<Pagina1>
    with SingleTickerProviderStateMixin {
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
      // Color fundal
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
        'AveriCarro',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Color.fromARGB(0, 44, 81, 246),
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
     
    return  SizedBox(
      child: Container(
        margin: const EdgeInsets.only(left: 50.0,right: 50.0,top: 100.0),
        //color: Color(0xFFFAF482),
        alignment: AlignmentDirectional.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            SizedBox(
              
              width: 250,
              height: 200,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                       Color.fromARGB(255, 255, 170, 90)), /*padding: EdgeInsets.all(10), */
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        
                        child: Text(
                          "Nueva Lista",
                          style: new TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),

                  // controlamos donde nos devuelve al pulsar
                  // como guardar en una base de datos Firebase
                  // los datos introducidos
                  onPressed: () => {Navigator.push(
        conte, 
        // nos pide el widget a utilizar que es de tipo materialpageroute
        // creando una ruta de la pagina
        MaterialPageRoute(builder: (conte)=>const Pagina7())),}),
            ),
            SizedBox(
              height: 120,
            ),
            SizedBox(
              width: 300,
              height: 80,
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 201, 215,
                            202)), /*padding: EdgeInsets.all(10), */
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          "Mensaje: Regístrate para elegir tus propias listas y obtener más funcionalidades",
                          style: new TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),

                  // controlamos donde nos devuelve al pulsar
                  // como guardar en una base de datos Firebase
                  // los datos introducidos
                  onPressed: () => {Navigator.push(context,  MaterialPageRoute(builder: (conte)=>const Pagina2())),})
            )
          ],
        ),
      )
      );
  }
  /////////////////////////////////////////////////////
  /////////////////////////////////////////////////////

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
