// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:aplicacion_ac/modelo/Producto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:aplicacion_ac/main.dart';
import 'package:shelf/shelf.dart' as shelf;

Future<void> main() async {
  final ruta_actual = Directory.current;
  final ruta_json = "test/";

  final manejador = createStaticHandler(ruta_json,
      defaultDocument: 'resultado.json', listDirectories: false);
  final encabezados = shelf.createMiddleware(
      responseHandler: (shelf.Response respuesta) =>
          respuesta.change(headers: {'Acces-Control-Allow-Origin': '*'}));
  final filtro =
      shelf.Pipeline().addMiddleware(encabezados).addHandler(manejador);
  final servidor = await io.serve(filtro, 'localhost', 8080);

  testWidgets(
      "Test para comprobar el funcionamiento del widget que se genera a partir de un producto:",
      (WidgetTester widget) async {
    final prod =
        Producto(nombreProducto: "Cerezas", precio: 4.50, hrefProducto: "");
    await widget.pumpWidget(MaterialApp(
      home: Scaffold(body: _construye_producto(prod)),
    ));

    expect(find.text("Cerezas"), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}

Widget _construye_producto(Producto p) {
  // esto es el objeto por cada producto favorito...
  return Container(
      padding: const EdgeInsets.all(5.0),
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 8,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        borderRadius: BorderRadius.circular(12),
        color: const Color.fromRGBO(239, 237, 254, 0.898),
        border: Border.all(
            color: const Color.fromARGB(255, 220, 230, 247), width: 3.0),
      ),
      child: SizedBox(
          width: 250,
          height: 140,
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Image.network(
              p.hrefProducto,
              height: 100.0,
              width: 100.0,
              alignment: Alignment.center,
              scale: 1,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stacktrace) {
                return Image.asset(
                  "assets/image_producto_no_encontrada.jpg",
                  height: MediaQuery.of(context).size.height,
                  width: 70.0,
                  alignment: Alignment.center,
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 8,
                    blurRadius: 9,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                //border: Border.all(color: Colors.blueAccent)
                color: Color.fromRGBO(255, 255, 255, 0.5),
              ),
              width: 200.0,
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(3.0),
              child: Column(
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
                  ]),
            ),
          ])));
}
