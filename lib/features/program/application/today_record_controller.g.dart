// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_record_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todayRecordControllerHash() =>
    r'ec53c067bc79372fbafc6ac35209e14e62ebd6fb';

/// Observa y muta el [DailyRecord] de HOY.
///
/// `build` emite el registro de hoy en vivo desde la base de datos (o `null`
/// mientras no exista todavía). Las mutaciones crean el registro de forma
/// perezosa: solo se persiste cuando el usuario marca la primera tarea / nota
/// / foto.
///
/// Copied from [TodayRecordController].
@ProviderFor(TodayRecordController)
final todayRecordControllerProvider = AutoDisposeStreamNotifierProvider<
    TodayRecordController, DailyRecord?>.internal(
  TodayRecordController.new,
  name: r'todayRecordControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayRecordControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TodayRecordController = AutoDisposeStreamNotifier<DailyRecord?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
