import 'package:flutter/material.dart';
import 'pagina1.dart';
import 'menugeneral.dart';

// CLASE PRINCIPAL CREADORA DE 'HOME'
class Pagina3 extends StatefulWidget {
  const Pagina3({
    super.key,
  });

  @override
  State<Pagina3> createState() => _Pagina3();
}

/////////////////////////////////////1 ª PARTE//////////////////////////////////////////////
// CLASE ANIMADO
class _Pagina3 extends State<Pagina3> with SingleTickerProviderStateMixin {
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
      leading: const Icon(
        Icons.shopping_basket_sharp,
        color: Color.fromARGB(255, 3, 122, 44),
      ),
      title: const Text(
        'Gestión listas',
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

    return SizedBox(
        child: Container(
      margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
      //color: Color(0xFFFAF482),
      alignment: AlignmentDirectional.center,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 50.0),
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 220, 230, 247),
                    width: 3.0),
              ),
              child: const Expanded(
                child: Text(
                  "Elegir lista",
                  style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            // esto es el objeto por cada lista creada....
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 220, 230, 247),
                        width: 3.0),
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromRGBO(239, 237, 254, 0.898)),
                child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Image.asset(
                        'assets/logo_cart.png',
                        width: 140.0,
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            //border: Border.all(color: Colors.blueAccent)
                            color: Color.fromRGBO(255, 255, 255, 0.5)),
                        width: MediaQuery.of(context).size.width / 3,
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(3.0),
                        child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Lista Semana Santa",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Descripción: Lista que contiene productos necesarios para el periodo de ...................",
                                textAlign: TextAlign.justify,
                              ),
                            ]),
                      ),
                    ]))),
            const SizedBox(
              height: 20,
            ),

            Container(
              decoration: BoxDecoration(
                border: Border.all(
                    color: const Color.fromARGB(255, 220, 230, 247),
                    width: 3.0),
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromRGBO(239, 237, 254, 0.898),
              ),
              child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Image.asset(
                      'assets/logo_cart.png',
                      width: 140.0,
                      alignment: Alignment.centerLeft,
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.5)),
                      width: MediaQuery.of(context).size.width / 3,
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(3.0),
                      child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
         
            
                               Text(
                              "Lista Navidad",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Descripción: Lista que contiene productos necesarios para el periodo de Navidades............",
                              textAlign: TextAlign.justify,
                            ),
                          ]),
                    ),
                  ])),
            ),

            // esto es el objeto por cada lista creada....
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 220, 230, 247),
                        width: 3.0),
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromRGBO(239, 237, 254, 0.898)),
                child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Image.asset(
                        'assets/logo_cart.png',
                        width: 140.0,
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            //border: Border.all(color: Colors.blueAccent)
                            color: Color.fromRGBO(255, 255, 255, 0.5)),
                        width: MediaQuery.of(context).size.width / 3,
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(3.0),
                        child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Lista Semana Santa",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                "Descripción: Lista que contiene productos necesarios para el periodo de ...................",
                                textAlign: TextAlign.justify,
                              ),
                            ]),
                      ),
                    ]))),
          ]
          // controlamos donde nos devuelve al pulsar
          // como guardar en una base de datos Firebase
          // los datos introducidos
          //onPressed: ()=>{Navigator.push(conte,
          // nos pide el widget a utilizar que es de tipo materialpageroute
          // creando una ruta de la pagina
          //MaterialPageRoute(builder: (conte)=>Pagina1())),

          ),
    ));
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
