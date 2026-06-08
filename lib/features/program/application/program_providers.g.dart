// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isarHash() => r'141cf705a4c29277c855fd995ccb0e0c7bea5812';

/// Instancia única de Isar. Se inicializa una sola vez en `main()`:
///
/// ```dart
/// final dir = await getApplicationDocumentsDirectory();
/// final isar = await Isar.open([DailyRecordSchema, ProgramStateSchema],
///     directory: dir.path);
/// runApp(ProviderScope(
///   overrides: [isarProvider.overrideWithValue(isar)],
///   child: const LiveHardApp(),
/// ));
/// ```
///
/// Copied from [isar].
@ProviderFor(isar)
final isarProvider = Provider<Isar>.internal(
  isar,
  name: r'isarProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsarRef = ProviderRef<Isar>;
String _$programDateLogicHash() => r'913ddf6f0b1f1c970931933b491a3553caba72f6';

/// Servicio de reglas de calendario (Dart puro, sin estado).
///
/// Copied from [programDateLogic].
@ProviderFor(programDateLogic)
final programDateLogicProvider = Provider<ProgramDateLogic>.internal(
  programDateLogic,
  name: r'programDateLogicProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$programDateLogicHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProgramDateLogicRef = ProviderRef<ProgramDateLogic>;
String _$programRepositoryHash() => r'f09af85be28f1f40717f697c74f38c8463decf71';

/// Repositorio de datos (acceso a Isar). Vive tanto como la app.
///
/// Copied from [programRepository].
@ProviderFor(programRepository)
final programRepositoryProvider = Provider<ProgramRepository>.internal(
  programRepository,
  name: r'programRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$programRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProgramRepositoryRef = ProviderRef<ProgramRepository>;
String _$programStateHash() => r'd9a9c556292f8a4d3dc3ebee00df45def1e9e92d';

/// Estado del programa observado en vivo desde Isar (singleton id == 1).
///
/// Copied from [programState].
@ProviderFor(programState)
final programStateProvider = AutoDisposeStreamProvider<ProgramState?>.internal(
  programState,
  name: r'programStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$programStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProgramStateRef = AutoDisposeStreamProviderRef<ProgramState?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
