import 'package:sembast/sembast.dart';

import '../../../core/enums/program_phase.dart';
import '../../../core/utils/date_x.dart';
import '../domain/models/daily_record.dart';
import '../domain/models/power_list_item.dart';
import '../domain/models/program_state.dart';

/// Capa de acceso a datos sobre sembast. Encapsula TODAS las lecturas y
/// escrituras de [ProgramState] (singleton id == 1), [DailyRecord] y
/// [PowerListItem].
///
/// Reglas que mantiene este repositorio:
///  - Las fechas siempre se normalizan a `dayOnly` antes de guardar/buscar
///    (y se persisten como `dayKey` `'yyyy-MM-dd'`, cuyo orden lexicográfico
///    coincide con el cronológico → los rangos funcionan).
///  - El [ProgramState] vive bajo el id fijo `1`.
///  - Solo puede existir UN [DailyRecord] por fecha: los guardados hacen
///    upsert por fecha (paridad con el índice único `replace` que daba Isar).
class ProgramRepository {
  ProgramRepository(this._db);

  final Database _db;

  /// Id fijo del documento singleton de estado.
  static const int stateId = 1;

  static final _states = intMapStoreFactory.store('program_state');
  static final _records = intMapStoreFactory.store('daily_records');
  static final _powerItems = intMapStoreFactory.store('power_list_items');

  // ================================================================
  // ProgramState (singleton)
  // ================================================================

  /// Lee el estado actual del programa, o `null` si aún no se ha iniciado.
  Future<ProgramState?> getState() async {
    final map = await _states.record(stateId).get(_db);
    return map == null ? null : ProgramState.fromMap(stateId, map);
  }

  /// Observa el estado del programa en vivo (emite el valor actual de
  /// inmediato, incluido `null` si todavía no existe).
  Stream<ProgramState?> watchState() =>
      _states.record(stateId).onSnapshot(_db).map(
            (snap) =>
                snap == null ? null : ProgramState.fromMap(stateId, snap.value),
          );

  /// Persiste el estado, forzando siempre el id singleton.
  Future<void> saveState(ProgramState state) async {
    state.id = stateId;
    await _states.record(stateId).put(_db, state.toMap());
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

  Finder _byDate(DateTime date) =>
      Finder(filter: Filter.equals('date', date.dayOnly.dayKey));

  /// Devuelve el registro de [date] (normalizada al día) o `null`.
  Future<DailyRecord?> getRecordForDate(DateTime date) async {
    final snap = await _records.findFirst(_db, finder: _byDate(date));
    return snap == null ? null : DailyRecord.fromMap(snap.key, snap.value);
  }

  /// Observa el registro de [date] en vivo. Emite de inmediato (`null`
  /// mientras no exista) y en cada cambio.
  Stream<DailyRecord?> watchRecordForDate(DateTime date) =>
      _records.query(finder: _byDate(date)).onSnapshots(_db).map(
            (snaps) => snaps.isEmpty
                ? null
                : DailyRecord.fromMap(snaps.first.key, snaps.first.value),
          );

  /// Guarda (crea o actualiza) un registro diario. El upsert por fecha evita
  /// duplicados del mismo día.
  Future<void> saveRecord(DailyRecord record) async {
    await _db.transaction((txn) => _upsertRecord(txn, record));
  }

  /// Guarda varios registros en una sola transacción (p. ej. el backfill que
  /// completa de golpe todos los días anteriores). Cada registro pasa por el
  /// mismo upsert por fecha: la mezcla de existentes y nuevos no duplica días.
  Future<void> saveRecords(List<DailyRecord> records) async {
    await _db.transaction((txn) async {
      for (final r in records) {
        await _upsertRecord(txn, r);
      }
    });
  }

  /// Upsert por fecha. Si el registro ya trae clave ([DailyRecord.id]) se
  /// escribe sobre ella; si no, se busca un registro existente del mismo día
  /// para reutilizar su clave; en último caso se crea uno nuevo.
  Future<void> _upsertRecord(DatabaseClient txn, DailyRecord record) async {
    record.date = record.date.dayOnly;
    final key = record.id ??
        (await _records.findFirst(txn, finder: _byDate(record.date)))?.key;
    if (key == null) {
      record.id = await _records.add(txn, record.toMap());
    } else {
      record.id = key;
      await _records.record(key).put(txn, record.toMap());
    }
  }

  /// Todos los registros de una fase, ordenados por fecha ascendente.
  Future<List<DailyRecord>> recordsForPhase(ProgramPhase phase) async {
    final snaps = await _records.find(
      _db,
      finder: Finder(
        filter: Filter.equals('phase', phase.name),
        sortOrders: [SortOrder('date')],
      ),
    );
    return [for (final s in snaps) DailyRecord.fromMap(s.key, s.value)];
  }

  /// Registros dentro de un rango de fechas (inclusive), ordenados por fecha.
  Future<List<DailyRecord>> recordsBetween(DateTime from, DateTime to) async {
    final snaps = await _records.find(
      _db,
      finder: Finder(
        filter: Filter.and([
          Filter.greaterThanOrEquals('date', from.dayOnly.dayKey),
          Filter.lessThanOrEquals('date', to.dayOnly.dayKey),
        ]),
        sortOrders: [SortOrder('date')],
      ),
    );
    return [for (final s in snaps) DailyRecord.fromMap(s.key, s.value)];
  }

  /// Borra todos los registros de una fase. Se usa al REINICIAR esa fase: el
  /// progreso vuelve a cero. Los registros se etiquetan con su fase al crearse.
  Future<void> deleteRecordsForPhase(ProgramPhase phase) async {
    await _records.delete(
      _db,
      finder: Finder(filter: Filter.equals('phase', phase.name)),
    );
  }

  /// Borra TODOS los registros diarios. Se usa al reiniciar el programa entero
  /// (fallo de Fase 3 → se rehace todo desde el 75 Hard).
  Future<void> deleteAllRecords() async {
    await _records.delete(_db);
  }

  // ================================================================
  // PowerListItem (tareas críticas definidas por el usuario)
  // ================================================================

  static final _activeItemsFinder = Finder(
    filter: Filter.equals('active', true),
    sortOrders: [SortOrder('slot')],
  );

  /// Todas las tareas de Power List vigentes, ordenadas por slot (1..5).
  Future<List<PowerListItem>> activePowerListItems() async {
    final snaps = await _powerItems.find(_db, finder: _activeItemsFinder);
    return [for (final s in snaps) PowerListItem.fromMap(s.key, s.value)];
  }

  /// Observa las tareas vigentes en vivo (emite el valor actual de inmediato).
  Stream<List<PowerListItem>> watchActivePowerListItems() =>
      _powerItems.query(finder: _activeItemsFinder).onSnapshots(_db).map(
            (snaps) =>
                [for (final s in snaps) PowerListItem.fromMap(s.key, s.value)],
          );

  /// Define o **reemplaza** el texto de la tarea en [slot]. Si ya había una
  /// activa con texto distinto, se retira (conserva historial) y se crea una
  /// nueva con [today] como `startDay` (la racha por tarea arranca de cero).
  /// Si el texto no cambia, no hace nada.
  Future<void> setPowerListText(int slot, String text, DateTime today) async {
    final day = today.dayOnly;
    await _db.transaction((txn) async {
      final current = await _activeForSlot(txn, slot);
      if (current != null && current.text == text) return;
      if (current != null) {
        current
          ..active = false
          ..retiredDay = day;
        await _powerItems.record(current.id!).put(txn, current.toMap());
      }
      final fresh = PowerListItem()
        ..slot = slot
        ..text = text
        ..startDay = day
        ..active = true;
      fresh.id = await _powerItems.add(txn, fresh.toMap());
    });
  }

  Future<PowerListItem?> _activeForSlot(DatabaseClient dbc, int slot) async {
    final snap = await _powerItems.findFirst(
      dbc,
      finder: Finder(
        filter: Filter.and([
          Filter.equals('slot', slot),
          Filter.equals('active', true),
        ]),
      ),
    );
    return snap == null ? null : PowerListItem.fromMap(snap.key, snap.value);
  }

  /// **Solo dev:** borra el estado y TODOS los registros, dejando la base como
  /// recién instalada (la app vuelve al onboarding).
  Future<void> wipeAll() async {
    await _db.transaction((txn) async {
      await _records.delete(txn);
      await _states.delete(txn);
      await _powerItems.delete(txn);
    });
  }
}
