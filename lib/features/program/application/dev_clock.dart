import 'package:riverpod_annotation/riverpod_annotation.dart';

// Tras editar: dart run build_runner build --delete-conflicting-outputs
part 'dev_clock.g.dart';

/// **Solo para desarrollo.** Offset en días que se suma a la fecha real para
/// "viajar en el tiempo" y probar el avance de fases / la detección de racha
/// rota sin esperar días reales. En producción el offset siempre es 0 (la barra
/// que lo modifica solo se muestra con `kDebugMode`).
@Riverpod(keepAlive: true)
class DevClock extends _$DevClock {
  @override
  int build() => 0;

  /// Avanza (o retrocede, con [days] negativo) el reloj simulado.
  void advance(int days) => state = state + days;

  void reset() => state = 0;
}

/// Fecha "hoy" que debe usar TODA la app (UI y providers) en lugar de
/// `DateTime.now()`, para que el reloj de desarrollo afecte a todo de forma
/// coherente. Con offset 0 equivale a la fecha real.
///
/// Se recalcula al cambiar [DevClock]; entre cambios la fecha real queda
/// "congelada" en el último recálculo, lo cual estabiliza las pruebas.
@riverpod
DateTime simulatedNow(SimulatedNowRef ref) {
  final offset = ref.watch(devClockProvider);
  return DateTime.now().add(Duration(days: offset));
}
