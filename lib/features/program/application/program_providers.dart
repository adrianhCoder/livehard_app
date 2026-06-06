import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/program_repository.dart';
import '../domain/models/daily_record.dart';
import '../domain/models/program_state.dart';
import 'program_date_logic.dart';

// Tras editar: dart run build_runner build --delete-conflicting-outputs
part 'program_providers.g.dart';

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
@Riverpod(keepAlive: true)
Isar isar(IsarRef ref) =>
    throw UnimplementedError('Sobrescribe isarProvider en main() con la instancia abierta.');

/// Abre Isar de forma autónoma (útil si prefieres no overridear en main).
Future<Isar> openIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [DailyRecordSchema, ProgramStateSchema],
    directory: dir.path,
  );
}

/// Servicio de reglas de calendario (Dart puro, sin estado).
@Riverpod(keepAlive: true)
ProgramDateLogic programDateLogic(ProgramDateLogicRef ref) =>
    const ProgramDateLogic();

/// Repositorio de datos (acceso a Isar). Vive tanto como la app.
@Riverpod(keepAlive: true)
ProgramRepository programRepository(ProgramRepositoryRef ref) =>
    ProgramRepository(ref.watch(isarProvider));

/// Estado del programa observado en vivo desde Isar (singleton id == 1).
@riverpod
Stream<ProgramState?> programState(ProgramStateRef ref) {
  final isar = ref.watch(isarProvider);
  return isar.programStates.watchObject(1, fireImmediately: true);
}
