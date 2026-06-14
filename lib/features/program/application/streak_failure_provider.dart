import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/date_x.dart';
import '../domain/models/phase_schedule.dart';
import '../domain/models/streak_failure.dart';
import 'dev_clock.dart';
import 'program_providers.dart';

// Tras editar: dart run build_runner build --delete-conflicting-outputs
part 'streak_failure_provider.g.dart';

/// Detecta si la racha está rota AHORA: el primer día pasado de una fase activa
/// que no quedó completo. Devuelve `null` si la racha sigue viva (o si aún no
/// hay calendario programado).
///
/// Es autoDispose: la vista de HOY lo observa y se recalcula tras marcar días
/// anteriores (backfill) o reiniciar una fase. Invalídalo después de mutar
/// registros para refrescar el aviso.
@riverpod
Future<StreakFailure?> streakFailure(StreakFailureRef ref) async {
  final program = ref.watch(programStateProvider).valueOrNull;
  if (program == null || !program.onboardingComplete) return null;

  final schedule = PhaseSchedule.tryFromState(program);
  if (schedule == null) return null;

  final repo = ref.watch(programRepositoryProvider);
  final records =
      await repo.recordsBetween(schedule.phase1.start, schedule.phase3.end);

  final completed = <DateTime>{
    for (final r in records)
      if (r.isComplete) r.date.dayOnly,
  };

  return detectStreakFailure(
    schedule: schedule,
    completedDates: completed,
    now: ref.watch(simulatedNowProvider),
  );
}
