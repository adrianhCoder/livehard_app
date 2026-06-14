import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enums/program_phase.dart';
import '../../../core/utils/date_x.dart';
import '../domain/models/phase_progress.dart';
import '../domain/models/phase_schedule.dart';
import 'dev_clock.dart';
import 'program_providers.dart';

// Tras editar: dart run build_runner build --delete-conflicting-outputs
part 'phase_overview_provider.g.dart';

/// Progreso real de todas las fases (75 Hard + Fases 1-3) calculado desde el
/// [ProgramState] y los [DailyRecord] de Isar. Lo consume la pantalla de
/// progreso. Es autoDispose: se recalcula cada vez que se abre la pantalla, así
/// refleja las tareas marcadas durante la sesión.
@riverpod
Future<List<PhaseProgress>> phaseOverview(PhaseOverviewRef ref) async {
  final program = ref.watch(programStateProvider).valueOrNull;
  if (program == null) return const [];

  final schedule = PhaseSchedule.tryFromState(program);
  if (schedule == null) return const [];

  final repo = ref.watch(programRepositoryProvider);
  final today = ref.watch(simulatedNowProvider).dayOnly;
  final todayStatus = schedule.entryFor(today);

  final list = <PhaseProgress>[];

  // 75 Hard: prerrequisito ya cumplido para poder programar las fases.
  list.add(PhaseProgress(
    phase: ProgramPhase.hard75,
    range: schedule.hard75,
    completedDays: {for (var d = 1; d <= schedule.hard75.lengthInDays; d++) d},
  ));

  for (final entry in schedule.phaseRanges) {
    final phase = entry.key;
    final range = entry.value;

    final records = await repo.recordsForPhase(phase);
    final completed = <int>{};
    final partial = <int>{};
    for (final r in records) {
      if (r.isComplete) {
        completed.add(r.dayNumber);
      } else if (r.completionRatio > 0) {
        partial.add(r.dayNumber);
      }
    }

    final currentDay =
        (todayStatus.kind == TodayKind.active && todayStatus.phase == phase)
            ? todayStatus.dayNumber
            : null;

    list.add(PhaseProgress(
      phase: phase,
      range: range,
      completedDays: completed,
      partialDays: partial,
      currentDay: currentDay,
    ));
  }
  return list;
}
