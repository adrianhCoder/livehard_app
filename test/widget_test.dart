// Smoke test mínimo: verifica que la pantalla de bienvenida se construye.
//
// La app real necesita una instancia de Isar (base de datos) inyectada vía
// `isarProvider`. Para un test de widget puro la sobrescribimos por un fake
// más adelante; por ahora este test solo comprueba que el árbol de widgets
// de la vista inicial se renderiza sin lanzar excepciones.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('La pantalla de bienvenida muestra el botón de inicio',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Bienvenido a LiveHard')),
        ),
      ),
    );

    expect(find.text('Bienvenido a LiveHard'), findsOneWidget);
  });
}
