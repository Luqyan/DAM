import 'package:flutter/material.dart';
import 'Lista.dart';
import 'Lista.dart';
import 'pagina1.dart';
import 'menugeneral.dart';

// CLASE PRINCIPAL CREADORA DE 'HOME'
class Pagina3 extends StatefulWidget {
  const Pagina3({
    super.key,
  });
  // creamos la ista de listas a través del método
   



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

///////////////////////////////////////////////generamos la lista de elementos
    List<Widget> listaListas = crearListas();


    return Scaffold(
      backgroundColor: Color.fromRGBO(254, 239, 188, 1),
      appBar: _buildAppBar(),
      body: Stack(
        
        children: [
          _buildContent(context,listaListas),
          _buildDrawer(),
        ],
      ),
    );
  }


//////////////////////////////////////////////////////////////////////////////////////////
////////////////////// método de creación de appBar personalizado/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: const Icon(
        Icons.shopping_basket_sharp,
        color: Color.fromARGB(255, 3, 122, 44),
      ),
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



  /////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////AQUI AÑADIMOS EL CONTENIDO DE LA PAGINA (BODY)/////////////
  /////////////////////// METODO QUE DEVUELVE UN SIZED BOX CON SU CONTENIDO////////////
  /////////////////////////////////////////////////////////////////////////////////////
  
  Widget _buildContent(conte,listaListas) {
    // Indicador si se ha arrastrado y soltado algo
    bool pasadoOnaccept = false;

    List<Widget> lista = List.from(listaListas);
 
    
    return Container(
        margin: const EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
      //color: Color(0xFFFAF482),
        alignment: AlignmentDirectional.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                //shrinkWrap: true,
                children: lista,
              )
            ),

          const SizedBox(
            height: 20,
          ),

          ]
            ),
            
          );
        
      
  }
  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
 
  /// Metodo que genera una lista de widgets de listas favoritas (guardadas) 
  List<Widget> crearListas() {
    Lista lis1 = Lista('Lista semanal');
    Lista lis2 = Lista('Lista productos igiéne');
    Lista lis3 = Lista('Lista productos cosmeticos');
    Lista lis4 = Lista('Lista semanal');
    Lista lis5 = Lista('Lista productos igiéne');
    Lista lis6 = Lista('Lista productos cosmeticos');
    Lista lis7 = Lista('Lista semanal');
    Lista lis8 = Lista('Lista productos igiéne');
    Lista lis9 = Lista('Lista productos cosmeticos');



    List<Lista> ejemplos = [];
    ejemplos.add(lis1);
    ejemplos.add(lis2);
    ejemplos.add(lis3);
    ejemplos.add(lis4);
    ejemplos.add(lis5);
    ejemplos.add(lis6);
    ejemplos.add(lis7);
    ejemplos.add(lis8);
    ejemplos.add(lis9);
    final List<Widget> listaObj = [];

    // Por cada objeto lista encontrado se monta un contenedor y se añade a
    // la lista de widgets que va dentro de un LIST VIEW
    for (Lista li in ejemplos) {
      final objetoTemporal = _montar_contenedor(li);
      // y despues lo convertimos a un objeto draggable
      final objetoFinal = _generaDraggable(objetoTemporal);
      listaObj.add(objetoFinal);

      listaObj.add(SizedBox(height: 20.0));
    }

    return listaObj;
  }

  // Metodo de conversión de los elementos de ListView a Draggable
  Widget _generaDraggable(Widget w) {
    final snackBar = SnackBar(content: Text("La lista ha sido eliminada!"));
    
    bool muestraCaja = true;

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container( 
        padding: EdgeInsets.only(left:20.0 ),
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        color: Colors.red,
      
        child: Icon(Icons.delete, color: Colors.white, size: 40.0,),

      ),
          
      
          key: ValueKey(w),
        onDismissed: (_){
          print("Elemento eliminado");
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
            
        child: SizedBox(
          height: 100.0,

          width: MediaQuery.of(context).size.width,
          
          child: ConstrainedBox(
            constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                child: w,
              ),
        ),
        );
     
  }




  // Metodo constructor de contenedor de lista (ListTile)
  Widget _montar_contenedor(Lista li) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          
          border: Border.all(
              color: const Color.fromARGB(255, 220, 230, 247), width: 4.0),
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromRGBO(239, 237, 254, 0.898)
          ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListTile(
          visualDensity: const VisualDensity(vertical: 3),
          minLeadingWidth:50.0,
          dense: false,
          onTap: () => () {},
          leading: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 70.0,
                minHeight: 70.0,
                maxWidth: 200.0,
                maxHeight: 200.0),
            child: Image.asset(
              'assets/logo_cart.png',
              width: 80.0,
              height: 80.0,
              alignment: Alignment.centerLeft,
              fit: BoxFit.fill,
            ),
          ),
          title: Text(li.nombreLista, style: TextStyle(fontSize: 20),),
          subtitle: Text(li.descripcionLista),
          
        ),
      ),
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
