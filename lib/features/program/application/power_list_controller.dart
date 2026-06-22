import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enums/program_phase.dart';
import '../../../core/utils/date_x.dart';
import '../domain/models/daily_record.dart';
import '../domain/models/power_list_item.dart';
import '../domain/models/power_list_logic.dart';
import 'dev_clock.dart';
import 'program_providers.dart';
import 'today_record_controller.dart';

// Tras editar: dart run build_runner build --delete-conflicting-outputs
part 'power_list_controller.g.dart';

/// Estado de UNA ranura de la Power List, listo para pintar en la UI.
class PowerListSlotView {
  const PowerListSlotView({
    required this.slot,
    required this.task,
    required this.text,
    required this.doneToday,
    required this.streak,
  });

  /// Número de slot (1..3).
  final int slot;

  /// Tarea diaria asociada (para leer/escribir el [DailyRecord] de hoy).
  final DailyTask task;

  /// Texto definido por el usuario, o `null` si la ranura está sin definir.
  final String? text;

  /// Si la tarea está marcada como hecha HOY.
  final bool doneToday;

  /// Días consecutivos completados de esta tarea (0 si no está definida).
  final int streak;

  bool get isDefined => text != null;

  /// `true` cuando la racha llegó al umbral de hábito (~21 días) → reemplazar.
  bool get isHabit => isDefined && powerListIsHabit(streak);
}

/// Observa y muta la Power List del usuario (3 tareas críticas persistentes).
@riverpod
class PowerListController extends _$PowerListController {
  @override
  Future<List<PowerListSlotView>> build() async {
    final repo = ref.watch(programRepositoryProvider);
    final today = ref.watch(simulatedNowProvider).dayOnly;

    // Re-emite en vivo cuando cambian las tareas o el registro de hoy.
    final items = await ref.watch(activePowerListProvider.future);
    final todayRecord = ref.watch(todayRecordControllerProvider).valueOrNull;
    final bySlot = {for (final it in items) it.slot: it};

    // Historial para calcular rachas (desde el startDay más antiguo hasta hoy).
    final records = items.isEmpty
        ? const <DailyRecord>[]
        : await repo.recordsBetween(
            items.map((e) => e.startDay.dayOnly).reduce(
                  (a, b) => a.isBefore(b) ? a : b,
                ),
            today,
          );

    final slots = <PowerListSlotView>[];
    for (var slot = 1; slot <= PhaseRules.powerListCount; slot++) {
      final item = bySlot[slot];
      final task = PhaseRules.powerListTaskForSlot(slot);

      var streak = 0;
      if (item != null) {
        final doneByDay = <DateTime, bool>{
          for (final r in records) r.date.dayOnly: r.isDone(task),
        };
        // El registro de hoy aún no persistido se refleja al instante.
        if (todayRecord != null) {
          doneByDay[today] = todayRecord.isDone(task);
        }
        streak = powerListStreak(
          today: today,
          startDay: item.startDay,
          doneByDay: doneByDay,
        );
      }

      slots.add(PowerListSlotView(
        slot: slot,
        task: task,
        text: item?.text,
        doneToday: todayRecord?.isDone(task) ?? false,
        streak: streak,
      ));
    }

    return slots;
  }

  /// Define o reemplaza el texto de la tarea en [slot].
  Future<void> setText(int slot, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final repo = ref.read(programRepositoryProvider);
    final today = ref.read(simulatedNowProvider);
    await repo.setPowerListText(slot, trimmed, today);
  }
}

/// Stream de las tareas de Power List vigentes (reacciona a altas/bajas).
@riverpod
Stream<List<PowerListItem>> activePowerList(ActivePowerListRef ref) {
  final repo = ref.watch(programRepositoryProvider);
  return repo.watchActivePowerListItems();
}
