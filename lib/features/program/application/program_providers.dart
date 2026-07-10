import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast.dart';

import '../data/db_factory_io.dart'
    if (dart.library.js_interop) '../data/db_factory_web.dart';
import '../data/program_repository.dart';
import '../domain/models/program_state.dart';
import 'program_date_logic.dart';

// Tras editar: dart run build_runner build --delete-conflicting-outputs
part 'program_providers.g.dart';

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
@Riverpod(keepAlive: true)
Database database(DatabaseRef ref) => throw UnimplementedError(
    'Sobrescribe databaseProvider en main() con la base de datos abierta.');

/// Abre la base de datos de la plataforma: archivo en escritorio/móvil,
/// IndexedDB en Flutter Web (resuelto por import condicional).
Future<Database> openAppDatabase() => openPlatformDatabase();

/// Servicio de reglas de calendario (Dart puro, sin estado).
@Riverpod(keepAlive: true)
ProgramDateLogic programDateLogic(ProgramDateLogicRef ref) =>
    const ProgramDateLogic();

/// Repositorio de datos (acceso a sembast). Vive tanto como la app.
@Riverpod(keepAlive: true)
ProgramRepository programRepository(ProgramRepositoryRef ref) =>
    ProgramRepository(ref.watch(databaseProvider));

/// Estado del programa observado en vivo (singleton id == 1).
@riverpod
Stream<ProgramState?> programState(ProgramStateRef ref) =>
    ref.watch(programRepositoryProvider).watchState();
