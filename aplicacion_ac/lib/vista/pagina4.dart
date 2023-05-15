import 'package:flutter/material.dart';
import 'Item.dart';
import 'pagina1.dart';
import 'pagina3.dart';
import 'pagina4.dart';
import 'pagina5.dart';
import 'menugeneral.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';
import 'Lista.dart';


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

      
    // Ordenar los productos ascendentemente por los precios 
    print((Lista.getFavoritos().toList()..sort()).reversed);
    
    // Coger los Productos de la lista atributo de la clase Lista
    List<Widget> listaListas = crearListas(Lista.getFavoritos().toList());

    return Scaffold(
        
        backgroundColor: Color.fromARGB(255, 252, 224, 125),
        appBar: _buildAppBar(),
        body: Stack(
          
          children: [
            _buildContent(context, listaListas),
            _buildDrawer(),
    
          ],
        ),
    );
  }

//////////////////////////////////////////////////////////////////////////////////////////
  // método de creación de appBar personalizado
  PreferredSizeWidget _buildAppBar() {
    
    return AppBar(
      leading: const Image(image: 
        AssetImage('assets/logo4.png'),
        filterQuality: FilterQuality.high,
      ),
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
  Widget _buildContent(conte, productos) {
    // Put page content here.
     
    return  SizedBox(
      child: Container(
        margin: const EdgeInsets.only(left: 40.0,right: 40.0,top: 20.0),
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
       
          // Expanded(
          //   child: ListView(
          //     children: [

          //     _construye_producto('assets/pan_integral.jpg', 'Pan integral'),
          //     _construye_producto('assets/yogur_griego.jpg', 'Yogur griego'),
          //     _construye_producto('assets/leche_sin_lactosa.png', 'Leche sín lactosa marca Puleva semidesnatada y baja en grasa 1L abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrst'),
          //     _construye_producto('assets/huevos_eco.jpg', 'Huevos ecológicos'),
          //     _construye_producto('assets/mahou.jpg', 'Cerveza Mahou 5 estrellas'),
          //     _construye_producto('assets/papel_ig.jpg', 'Papel igiénico'),

          // ]
          
          // ))
            // esto es el objeto por cada lista creada....
          
          Expanded(
            child: ListView.builder(
            padding: EdgeInsets.only(top: 30),
            controller: ScrollController(initialScrollOffset: 2),
            itemCount: productos.length,
            itemBuilder:(BuildContext context, int index) => productos[index],
          ),
          )
         
                            
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



  Widget _construye_producto(Producto p){
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
              
        width: 250,
        height: 100,
          
          child: Row(
            mainAxisSize: MainAxisSize.min,
           
            children: [
                
              Image.asset(p.hrefProducto, height: MediaQuery.of(context).size.height,width: 100.0, alignment:Alignment.center,) ,
              
              Container(
                decoration: const BoxDecoration(
                  //border: Border.all(color: Colors.blueAccent)
                  color: Color.fromRGBO(255, 255, 255, 0.5)
                ),
                width: MediaQuery.of(context).size.width/2.2,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(3.0),  
                                   
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  
                  children: [

                    Expanded(

                            flex: 9,
                            child: Center(
                              child: Text(
                                p.nombreProducto.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                  ]
                                    
                ),
              ),
                  
            ]
          )
        )
      );

  }




 Widget _generaDraggable(Widget w, int pos) {
    const snackBar = SnackBar(
        duration: Duration(seconds: 1),
        content: Text("El producto ha sido eliminado!"));

    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40.0,
        ),
      ),
      key: ValueKey(w),
      onDismissed: (_) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          Lista.quitarFavorito(pos);
        });
      },
      child: SizedBox(
        height: 80.0,
        width: MediaQuery.of(context).size.width,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
          child: w,
        ),
      ),
    );
  }


  /// Metodo que genera una lista de widgets de listas favoritas (guardadas)
  List<Widget> crearListas(List<Producto> productos) {
    final List<Widget> listaObj = [];

    // Por cada objeto Producto encontrado se monta un contenedor y se añade a
    // la lista de widgets que va dentro de un LIST VIEW
    int pos = 0;
    for (Producto pro in productos) {
      final objetoTemporal = _construye_producto(pro);
      // y despues lo convertimos a un objeto draggable
      final objetoFinal = _generaDraggable(objetoTemporal, pos);
      listaObj.add(objetoFinal);

      listaObj.add(SizedBox(height: 20.0));
      pos += 1;
    }

    return listaObj;
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



// Generador de una lista de Items
List<Item> generaItems(int tamanio) {
  return List.generate(
    tamanio,
    (int index) => Item(
      expanded: '$index',
      title: 'Item $index',
      isExpanded: false,
    ),
  );
}



















