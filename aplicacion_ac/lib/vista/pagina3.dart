import 'package:flutter/material.dart';
import 'Lista.dart';
import 'pagina1.dart';
import 'menugeneral.dart';



// CLASE PRINCIPAL CREADORA DE 'HOME'
class Pagina3 extends StatefulWidget {
  const Pagina3({
    super.key,
  });

  @override
  State<Pagina3> createState() =>
      _Pagina3();


}



/////////////////////////////////////1 ª PARTE//////////////////////////////////////////////
// CLASE ANIMADO
class _Pagina3 extends State<Pagina3>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;
  

  late final List<ListView> listas;

  

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
        'Listas favoritas',
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
          
          children: <Widget>[
            Expanded(
              child: ListView( 
                children: 

                  crearListas()

                ,
             
              
            )
            ),
            // montar scrollable

              // // Montar drawable
              // Draggable( child:_lista1,
              
              // childWhenDragging: _monta_contenedor_vacio(),
              // feedback: Container(
              //   child: _lista1, 
              //   width: 400,
              //   height: 200,),
              // ),
                
              
                const SizedBox(      
                  height: 20,
                ),


              // Montar drawable
          //       _montar_contenedor('Lista barbacoa', 'Productos que hay que comprar para realizar una barbacoa como Diós manda!!!!'),
          //     DragTarget(
                
          //       builder: Container(const Icon(Icons.delete_forever_outlined,))

          //       onAccept: (){ setState(() {
                 
          //       });},
          //     ),
          // ],

            // Montar un buttom_Icon de basura (con Icon)
          
            
      //  ),
          ]  
      )
      
      )
    );
  }
  /////////////////////////////////////////////////////
  /////////////////////////////////////////////////////


  List<Widget> crearListas(){

    Lista lista1 = new Lista('Lista semanal', 'Lista de compras que se realizan todas las semanas.');
    Lista lista2 = new Lista('Lista productos igiéne', 'Productos necesarios para la igiene personal.');
    Lista lista3 = new Lista('Lista productos cosmeticos', 'Productos necesarios para la imágen personal.');
    
    
    List<Lista> lista_listas = [];

    lista_listas.add(lista1);
    lista_listas.add(lista2);
    lista_listas.add(lista3);
    final List<Widget> lista_obj = [];

    for (Lista li in lista_listas){

      final objeto_temporal = ListTile(

        leading: ConstrainedBox( 
          constraints: BoxConstraints(
            minWidth: 50.0,
            minHeight: 50.0,
            maxWidth: 200.0,
            maxHeight: 200.0
          ),
          child:Image.asset('assets/logo_cart.png', width: 60.0, height: 60,alignment:Alignment.centerLeft,fit: BoxFit.cover,), 
        ),
        title: Text(li.nombre),
        subtitle: Text(li.descripcion),
        trailing: Icon(Icons.arrow_circle_right_outlined),
      );
      lista_obj.add(objeto_temporal);

      lista_obj.add(Divider());

      
    }

    return lista_obj;


  }




  Widget _monta_contenedor_vacio(){

    return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 220, 230, 247), 
                  width: 3.0),
                borderRadius: BorderRadius.circular(12),
                color: Color.fromARGB(226, 188, 179, 241)
              ),

              child: const SizedBox(
              
                width: 300,
                height: 200,
              )
    );
  }

  Widget _montar_contenedor(String titulo, String descripcion){

    return 
        Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(255, 220, 230, 247), 
                  width: 3.0),
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromRGBO(239, 237, 254, 0.898)
              ),

             

              child:SizedBox(
              
                width: 200,
                height: 200,
                child: Row(
                  
                mainAxisSize: MainAxisSize.min,
                children: [
                Image.asset('assets/logo_cart.png', width: 140.0, alignment:Alignment.centerLeft,) ,
              
                Container(
                  decoration:  BoxDecoration(
                  //border: Border.all(color: Colors.blueAccent)
                  color: Color.fromRGBO(255, 255, 255, 0.5)
              ),
                    width: MediaQuery.of(context).size.width/3,
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(3.0),  
                                   
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text(titulo, textAlign: TextAlign.right,
                           style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                        SizedBox(height: 20.0,),
                        Text(descripcion, textAlign: TextAlign.justify,),
                 

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
