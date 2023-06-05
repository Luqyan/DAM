import 'package:aplicacion_ac/vista/menugeneral.dart';
import 'package:aplicacion_ac/vista/mi_cesta.dart';
import 'package:flutter/material.dart';
import 'productos_favoritos.dart';
import 'listas_favoritas.dart';
import 'vista_resultado.dart';
import 'package:aplicacion_ac/main.dart';
import 'buscador.dart';
/// Clase que representa el estado del menú.
class MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  static const _menuOpciones = [
    'Listas favoritas',
    'Productos favoritos',
    'Mi cesta',
    'Selector de productos',
    
  ];

  // Creamos variables que contienen los valores definidos
  // utilizadas en la definición de la configuración animada del menú.
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

  // Método para crear los intervalos de animación.
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
      color: const Color.fromRGBO(255, 255, 255, 0.89),
      child: Stack(
        fit: StackFit.expand,
        children: [
          //_buildFlutterLogo(),
          _buildContent(context),
        ],
      ),
    );
  }


  // Método para construir el contenido del menú.
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

  // Método para construir los elementos de la lista del menú.
  List<Widget> _buildListItems(conte) {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuOpciones.length; ++i) {
      listItems.add(
        // Se crean las filas del menu en funcion de la cantidad de elementos
        // encontrados en la lista estatica.
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 36.0, vertical: 16),
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
                if (i == 0) {
                  Navigator.push(conte,
                      MaterialPageRoute(builder: (conte) => const listas_favoritas()));
                } else if (i == 1) {
                  Navigator.push(conte,
                      MaterialPageRoute(builder: (conte) => const productos_favoritos()));
                } else if (i == 2) {
                  Navigator.push(conte,
                      MaterialPageRoute(builder: (conte) => const mi_cesta()));
                } else if (i == 3) {
                  Navigator.push(conte,
                      MaterialPageRoute(builder: (conte) => const buscador()));
                  } else if (i == 5) {
                  Navigator.push(conte,
                      MaterialPageRoute(builder: (conte) => const genera_resultado()));
                }
              }),
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
              backgroundColor: const Color.fromARGB(255, 25, 214, 158),
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
            ),
            onPressed: () {
              Navigator.push(
                  conte,
                  // nos pide el widget a utilizar que es de tipo materialpageroute
                  // creando una ruta de la pagina
                  MaterialPageRoute(builder: (conte) => const inicio()));
            },
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
