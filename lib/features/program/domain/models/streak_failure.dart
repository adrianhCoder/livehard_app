import '../../../../core/enums/program_phase.dart';
import '../../../../core/utils/date_x.dart';
import 'phase_schedule.dart';

/// Una racha rota detectada: el PRIMER día pasado de una fase activa que no
/// quedó completado al 100%. Es el equivalente a "fallaste el día N".
class StreakFailure {
  const StreakFailure({
    required this.phase,
    required this.dayNumber,
    required this.date,
  });

  /// Fase en la que se rompió la racha.
  final ProgramPhase phase;

  /// Número de día (1-based) dentro de la fase que se falló.
  final int dayNumber;

  /// Fecha calendario del día fallado (normalizada al día).
  final DateTime date;

  /// Fallar la Fase 3 es especial: obliga a reiniciar TODO el 75 Hard desde 0.
  /// Las Fases 1 y 2 solo reinician esa fase.
  bool get requiresFullReset => phase == ProgramPhase.phase3;
}

/// Detecta la racha rota más temprana del calendario. **Dart puro y testeable**
/// (con `now` inyectable, sin tocar la base de datos).
///
/// Recorre las fases programables en orden cronológico (Fase 1 → 2 → 3) y busca
/// el primer día ESTRICTAMENTE anterior a hoy que cae dentro de una fase y que
/// no está en [completedDates]. El día de HOY nunca cuenta como fallo (sigue en
/// curso); los días futuros tampoco.
///
/// [completedDates] son las fechas (normalizadas con [DateX.dayOnly]) de los
/// días marcados como completos (todas las tareas de su fase hechas).
StreakFailure? detectStreakFailure({
  required PhaseSchedule schedule,
  required Set<DateTime> completedDates,
  DateTime? now,
}) {
  final today = (now ?? DateTime.now()).dayOnly;

  for (final entry in schedule.phaseRanges) {
    final phase = entry.key;
    final range = entry.value;

    // La fase aún no ha empezado: no hay días pasados que evaluar.
    if (!range.start.isBefore(today)) continue;

    for (var n = 1; n <= range.lengthInDays; n++) {
      final date = range.start.add(Duration(days: n - 1)).dayOnly;

      // En cuanto llegamos a hoy o al futuro dejamos de evaluar esta fase.
      if (!date.isBefore(today)) break;

      if (!completedDates.contains(date)) {
        return StreakFailure(phase: phase, dayNumber: n, date: date);
      }
    }
  }
  return null;
}
