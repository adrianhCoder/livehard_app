import 'package:isar/isar.dart';

import '../../../core/enums/program_phase.dart';
import '../../../core/utils/date_x.dart';
import '../domain/models/daily_record.dart';
import '../domain/models/program_state.dart';

/// Capa de acceso a datos sobre Isar. Encapsula TODAS las lecturas/escrituras
/// de [ProgramState] (singleton id == 1) y de los [DailyRecord].
///
/// Reglas que mantiene este repositorio:
///  - Las fechas siempre se normalizan a `dayOnly` antes de guardar/buscar,
///    para que las comparaciones por día sean deterministas (sin horas).
///  - El [ProgramState] vive bajo el id fijo `1`.
class ProgramRepository {
  ProgramRepository(this._isar);

  final Isar _isar;

  /// Id fijo del documento singleton de estado.
  static const int stateId = 1;

  // ================================================================
  // ProgramState (singleton)
  // ================================================================

  /// Lee el estado actual del programa, o `null` si aún no se ha iniciado.
  ProgramState? getState() => _isar.programStates.getSync(stateId);

  /// Observa el estado del programa en vivo (emite inmediatamente).
  Stream<ProgramState?> watchState() =>
      _isar.programStates.watchObject(stateId, fireImmediately: true);

  /// Persiste el estado, forzando siempre el id singleton.
  Future<void> saveState(ProgramState state) async {
    state.id = stateId;
    await _isar.writeTxn(() => _isar.programStates.put(state));
  }

  /// Crea el estado inicial al arrancar el programa por primera vez.
  /// La fecha de inicio se normaliza al día.
  Future<ProgramState> startProgram(DateTime startDate) async {
    final day = startDate.dayOnly;
    final state = ProgramState()
      ..id = stateId
      ..programStartDate = day
      ..currentPhase = ProgramPhase.hard75
      ..currentPhaseStartDate = day;
    await saveState(state);
    return state;
  }

  // ================================================================
  // DailyRecord
  // ================================================================

  /// Devuelve el registro de [date] (normalizada al día) o `null`.
  DailyRecord? getRecordForDate(DateTime date) =>
      _isar.dailyRecords.filter().dateEqualTo(date.dayOnly).findFirstSync();

  /// Observa el registro de [date] en vivo. Emite `null` mientras no exista.
  Stream<DailyRecord?> watchRecordForDate(DateTime date) => _isar.dailyRecords
      .filter()
      .dateEqualTo(date.dayOnly)
      .watch(fireImmediately: true)
      .map((results) => results.isEmpty ? null : results.first);

  /// Guarda (crea o actualiza) un registro diario. El índice único sobre
  /// `date` con `replace: true` evita duplicados del mismo día.
  Future<void> saveRecord(DailyRecord record) async {
    record.date = record.date.dayOnly;
    await _isar.writeTxn(() => _isar.dailyRecords.put(record));
  }

  /// Todos los registros de una fase, ordenados por fecha ascendente.
  Future<List<DailyRecord>> recordsForPhase(ProgramPhase phase) =>
      _isar.dailyRecords.filter().phaseEqualTo(phase).sortByDate().findAll();

  /// Registros dentro de un rango de fechas (inclusive), ordenados por fecha.
  Future<List<DailyRecord>> recordsBetween(DateTime from, DateTime to) =>
      _isar.dailyRecords
          .filter()
          .dateBetween(from.dayOnly, to.dayOnly)
          .sortByDate()
          .findAll();

  /// Borra todos los registros de una fase. Se usa al REINICIAR esa fase: el
  /// progreso vuelve a cero. Los registros se etiquetan con su fase al crearse.
  Future<void> deleteRecordsForPhase(ProgramPhase phase) async {
    await _isar.writeTxn(
      () => _isar.dailyRecords.filter().phaseEqualTo(phase).deleteAll(),
    );
  }

  /// Borra TODOS los registros diarios. Se usa al reiniciar el programa entero
  /// (fallo de Fase 3 → se rehace todo desde el 75 Hard).
  Future<void> deleteAllRecords() async {
    await _isar.writeTxn(() => _isar.dailyRecords.clear());
  }
}
