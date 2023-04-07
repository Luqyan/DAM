import 'package:flutter/material.dart';
import 'pagina1.dart';
import 'pagina3.dart';
import 'pagina4.dart';
import 'pagina5.dart';
import 'menugeneral.dart';


// CLASE PRINCIPAL CREADORA DE 'HOME'
class Pagina4 extends StatefulWidget {
  const Pagina4({
    super.key,
  });

  @override
  State<Pagina4> createState() =>
      _Pagina4();
}



/////////////////////////////////////1 ª PARTE//////////////////////////////////////////////
// CLASE ANIMADO
class _Pagina4 extends State<Pagina4>
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
      leading: const Icon(Icons.shopping_basket_sharp , color: Color.fromARGB(255, 3, 122, 44),),
      title: const Text(
        'Productos favoritos',
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
     
    return  SizedBox(
      child: Container(
        margin: const EdgeInsets.only(left: 50.0,right: 50.0,top: 20.0),
        //color: Color(0xFFFAF482),
        alignment: AlignmentDirectional.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
          Container(
            margin:const EdgeInsets.only(bottom: 50.0),
             decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 220, 230, 247), 
                  width: 3.0),),
            child: const Expanded(
              
                  child: Text("Productos favoritos",
                  style:  TextStyle(
                  
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87),
                          textAlign: TextAlign.center,
                          )
              
                  ,
              ),
          ),
       
          Expanded(
            child: ListView(
              children: [

              _construye_producto('assets/pan_integral.jpg', 'Pan integral'),
              _construye_producto('assets/yogur_griego.jpg', 'Yogur griego'),
              _construye_producto('assets/leche_sin_lactosa.png', 'Leche sín lactosa'),
              _construye_producto('assets/huevos_eco.jpg', 'Huevos ecológicos'),
              _construye_producto('assets/mahou.jpg', 'Cerveza Mahou 5 estrellas'),
              _construye_producto('assets/papel_ig.jpg', 'Papel igiénico'),

          ]
          
          ))
            // esto es el objeto por cada lista creada....
          
            
         
                            
              ]
              )
            ),
            
          
                  // controlamos donde nos devuelve al pulsar
                  // como guardar en una base de datos Firebase
                  // los datos introducidos
                   //onPressed: ()=>{Navigator.push(conte, 
        // nos pide el widget a utilizar que es de tipo materialpageroute
        // creando una ruta de la pagina
        //MaterialPageRoute(builder: (conte)=>Pagina1())),
          
        );
  }
  /////////////////////////////////////////////////////
  /////////////////////////////////////////////////////



  Widget _construye_producto(String imagen, String nombre){
    // esto es el objeto por cada producto favorito...
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(239, 237, 254, 0.898),
        border: Border.all(
          color: const Color.fromARGB(255, 220, 230, 247), 
          width: 3.0),
      ),

             
      child:SizedBox(
              
        width: 200,
        height: 100,
          
          child: Row(
            mainAxisSize: MainAxisSize.min,
           
            children: [
                
              Image.asset(imagen, height: MediaQuery.of(context).size.height,width: 100.0, alignment:Alignment.centerLeft,) ,
              
              Container(
                decoration: const BoxDecoration(
                  //border: Border.all(color: Colors.blueAccent)
                  color: Color.fromRGBO(255, 255, 255, 0.5)
                ),
                width: MediaQuery.of(context).size.width/2.3,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(3.0),  
                                   
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: [

                    Text(nombre, textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),

                  ]
                                    
                ),
              ),
                  
            ]
          )
        )
      );

  }










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






















