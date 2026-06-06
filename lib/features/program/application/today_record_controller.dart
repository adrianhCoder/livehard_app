import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enums/program_phase.dart';
import '../../../core/utils/date_x.dart';
import '../domain/models/daily_record.dart';
import 'program_providers.dart';

// Tras editar: dart run build_runner build --delete-conflicting-outputs
part 'today_record_controller.g.dart';

/// Observa y muta el [DailyRecord] de HOY.
///
/// `build` emite el registro de hoy en vivo desde Isar (o `null` mientras no
/// exista todavía). Las mutaciones crean el registro de forma perezosa: solo
/// se persiste cuando el usuario marca la primera tarea / nota / foto.
@riverpod
class TodayRecordController extends _$TodayRecordController {
  @override
  Stream<DailyRecord?> build() {
    final repo = ref.watch(programRepositoryProvider);
    return repo.watchRecordForDate(DateTime.now());
  }

  /// Obtiene el registro de hoy si existe; si no, construye uno nuevo en memoria
  /// con la fase y el número de día derivados del [ProgramState] actual.
  DailyRecord _ensureTodayRecord() {
    final repo = ref.read(programRepositoryProvider);
    final today = DateTime.now().dayOnly;

    final existing = repo.getRecordForDate(today);
    if (existing != null) return existing;

    final program = ref.read(programStateProvider).valueOrNull;
    if (program == null) {
      throw StateError(
          'No se puede crear el registro de hoy: el programa no está iniciado.');
    }
    final logic = ref.read(programDateLogicProvider);

    return DailyRecord()
      ..date = today
      ..phase = program.currentPhase
      ..dayNumber = logic.dayNumberInPhase(program, now: today);
  }

  /// Marca o desmarca una tarea de hoy y persiste el cambio.
  Future<void> setTask(DailyTask task, bool value) async {
    final repo = ref.read(programRepositoryProvider);
    final record = _ensureTodayRecord()..setDone(task, value);
    await repo.saveRecord(record);
  }

  /// Alterna el estado de una tarea (útil para checkboxes/taps).
  Future<void> toggleTask(DailyTask task) async {
    final record = _ensureTodayRecord();
    await setTask(task, !record.isDone(task));
  }

  /// Guarda las notas libres del día.
  Future<void> setNotes(String notes) async {
    final repo = ref.read(programRepositoryProvider);
    final record = _ensureTodayRecord()..notes = notes;
    await repo.saveRecord(record);
  }

  /// Guarda la ruta local de la foto de progreso y marca la tarea como hecha.
  Future<void> setProgressPhoto(String imagePath) async {
    final repo = ref.read(programRepositoryProvider);
    final record = _ensureTodayRecord()
      ..imagePath = imagePath
      ..setDone(DailyTask.progressPhoto, true);
    await repo.saveRecord(record);
  }
}
