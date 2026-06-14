// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_clock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$simulatedNowHash() => r'a7c0bdea600edbaaad053ba3416c8294009d87fa';

/// Fecha "hoy" que debe usar TODA la app (UI y providers) en lugar de
/// `DateTime.now()`, para que el reloj de desarrollo afecte a todo de forma
/// coherente. Con offset 0 equivale a la fecha real.
///
/// Se recalcula al cambiar [DevClock]; entre cambios la fecha real queda
/// "congelada" en el último recálculo, lo cual estabiliza las pruebas.
///
/// Copied from [simulatedNow].
@ProviderFor(simulatedNow)
final simulatedNowProvider = AutoDisposeProvider<DateTime>.internal(
  simulatedNow,
  name: r'simulatedNowProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$simulatedNowHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SimulatedNowRef = AutoDisposeProviderRef<DateTime>;
String _$devClockHash() => r'd65ea508a574daee0e75d3a4ead488511a48e06f';

/// **Solo para desarrollo.** Offset en días que se suma a la fecha real para
/// "viajar en el tiempo" y probar el avance de fases / la detección de racha
/// rota sin esperar días reales. En producción el offset siempre es 0 (la barra
/// que lo modifica solo se muestra con `kDebugMode`).
///
/// Copied from [DevClock].
@ProviderFor(DevClock)
final devClockProvider = NotifierProvider<DevClock, int>.internal(
  DevClock.new,
  name: r'devClockProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$devClockHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DevClock = Notifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
