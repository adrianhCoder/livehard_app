// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$databaseHash() => r'5e5344f7fc09ef502ca00b06e90df9490c706d99';

/// Instancia única de la base de datos (sembast). Se inicializa una sola vez
/// en `main()`:
///
/// ```dart
/// final db = await openAppDatabase();
/// runApp(ProviderScope(
///   overrides: [databaseProvider.overrideWithValue(db)],
///   child: const LiveHardApp(),
/// ));
/// ```
///
/// Copied from [database].
@ProviderFor(database)
final databaseProvider = Provider<Database>.internal(
  database,
  name: r'databaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$databaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DatabaseRef = ProviderRef<Database>;
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
String _$programRepositoryHash() => r'412acaeb01ffde49ff115d55591e398c620e4b8c';

/// Repositorio de datos (acceso a sembast). Vive tanto como la app.
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
String _$programStateHash() => r'c458d97b64db956180ed65747d838e1813c0607d';

/// Estado del programa observado en vivo (singleton id == 1).
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
