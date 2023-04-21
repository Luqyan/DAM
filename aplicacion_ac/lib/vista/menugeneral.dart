
import 'package:aplicacion_ac/vista/pagina8.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:aplicacion_ac/main.dart';
import 'pagina2.dart';
import 'pagina3.dart';
import 'pagina4.dart';
import 'pagina5.dart';
import 'pagina7.dart';

/////////////////////////////////2 ª PARTE/////CLASE MENU ////////////////////////////////////////////




class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  static const _menuOpciones = [
    'Listas favoritas',
    'Productos favoritos',
    'Productos lista',
    'Selector de productos',
    'Configuración cuenta',
    
  ];

  // creamos variables que contienen los valores definidos
  // utilizadas en la definición de la configuración animada del menú
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 500);
  final _animationDuration = _initialDelayTime +
      (_staggerTime * _menuOpciones.length) +
      _buttonDelayTime +
      _buttonTime;

  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];
  late Interval _buttonInterval;
  
  

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }


  // metodo definición de la animación de interacción con el menú
  void _createAnimationIntervals() {
    for (var i = 0; i < _menuOpciones.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }

    final buttonStartTime =
        Duration(milliseconds: (_menuOpciones.length * 50)) + _buttonDelayTime;
    final buttonEndTime = buttonStartTime + _buttonTime;
    _buttonInterval = Interval(
      buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
      buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
    );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      color: Color.fromRGBO(255, 255, 255, 0.89),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildFlutterLogo(),
          _buildContent(context),
        ],
      ),
    );
  }

  // método creación de un logo 
  Widget _buildFlutterLogo() {
    return const Positioned(
      right: -100,
      bottom: -30,
      child: Opacity(
        opacity: 0.4,
        child: FlutterLogo(
          size: 400,
        ),
      ),
    );
  }




  // MONTAMOS CON ESTE METODO LOS ITEMS Y EL BOTON 
  // el contexto con el contenido se ha creado en una sola columna
  // llamamos a la parte de los contenidos con la función '_buildListItems' y del boton de Inicio
  Widget _buildContent(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(context),
        const Spacer(),
        _buildGetStartedButton(context),
      ],
    );
  }


  // lista de cada opción del menú con valores recogidos desde la 
  List<Widget> _buildListItems(conte) {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuOpciones.length; ++i) {
      listItems.add(

        // se crean las filas del manu en funcion de la cantidad de elementos
        // encontrados en la lista estatica
        AnimatedBuilder(
          
          animation: _staggeredController,
          
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_staggeredController.value),
            );

            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;
            
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          
        child: InkWell(
         splashColor: Theme.of(context).primaryColorLight,
         
        child: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 16),
           
              child: Text(
                
                _menuOpciones[i],
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
              ),
            ),
           
          
          ),
          
     
        ),   

          
          onTap: () {
            if (i==0) {
              Navigator.push(
              conte, 
              MaterialPageRoute(builder: (conte)=>const Pagina3()));
            } else if(i==1) {
              Navigator.push(
              conte, 
              MaterialPageRoute(builder: (conte)=>const Pagina4()));
            // } else if(i==2) {
            //   Navigator.push(
            //   conte, 
            //   MaterialPageRoute(builder: (conte)=> Pagina8(cesta: null,)));
            // } else if(i==3) {
              Navigator.push(
              conte, 
              MaterialPageRoute(builder: (conte)=>const Pagina7()));
            } else if(i==4) {
              Navigator.push(
              conte, 
              MaterialPageRoute(builder: (conte)=>const Pagina5()));
            }
           } 
        ),
          ),
      
      );    
        
      
    }
    return listItems;
  }



  // CONSTRUCTOR DE BOTON INICIAL
  Widget _buildGetStartedButton(conte) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.elasticOut.transform(
                _buttonInterval.transform(_staggeredController.value));
            final opacity = animationPercent.clamp(0.0, 1.0);
            final scale = (animationPercent * 0.5) + 0.5;

            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },

          // BOTON ADICIONAL 
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Color.fromARGB(255, 25, 214, 158),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
            ),
            onPressed: () {Navigator.push(
        conte, 
        // nos pide el widget a utilizar que es de tipo materialpageroute
        // creando una ruta de la pagina
        MaterialPageRoute(builder: (conte)=>const MiAplicacion()));},
            child: const Text(
              'Inicio',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
