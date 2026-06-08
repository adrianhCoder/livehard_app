import '../../../../core/enums/program_phase.dart';
import '../../../../core/utils/date_x.dart';
import '../../application/program_date_logic.dart';
import 'program_state.dart';

/// Rango de fechas inclusivo, normalizado a día.
class DateRange {
  DateRange(DateTime start, DateTime end)
      : start = start.dayOnly,
        end = end.dayOnly;

  final DateTime start;
  final DateTime end;

  bool contains(DateTime date) {
    final d = date.dayOnly;
    return !d.isBefore(start) && !d.isAfter(end);
  }

  /// Número de día (1-based) de [date] dentro del rango.
  int dayNumber(DateTime date) => start.daysUntil(date.dayOnly) + 1;

  int get lengthInDays => start.daysUntil(end) + 1;
}

/// En qué punto del programa cae un día concreto.
enum TodayKind {
  /// Antes de que empiece la Fase 1.
  beforeStart,

  /// Día activo de una fase (con [TodayStatus.phase] y [TodayStatus.dayNumber]).
  active,

  /// En un periodo de descanso/espera antes de la siguiente fase.
  waiting,

  /// Ya terminó la Fase 3.
  done,
}

/// Estado del día de HOY derivado del calendario.
class TodayStatus {
  const TodayStatus._(
    this.kind, {
    this.phase,
    this.dayNumber,
    this.nextPhase,
    this.daysUntilNext,
  });

  const TodayStatus.active(ProgramPhase phase, int dayNumber)
      : this._(TodayKind.active, phase: phase, dayNumber: dayNumber);

  const TodayStatus.waiting(ProgramPhase nextPhase, int daysUntilNext,
      {bool beforeStart = false})
      : this._(
          beforeStart ? TodayKind.beforeStart : TodayKind.waiting,
          nextPhase: nextPhase,
          daysUntilNext: daysUntilNext,
        );

  const TodayStatus.done() : this._(TodayKind.done);

  final TodayKind kind;

  /// Fase activa (solo cuando [kind] == active).
  final ProgramPhase? phase;

  /// Día 1-based dentro de la fase activa.
  final int? dayNumber;

  /// Próxima fase (cuando [kind] es beforeStart / waiting).
  final ProgramPhase? nextPhase;

  /// Días que faltan para [nextPhase].
  final int? daysUntilNext;
}

/// Calendario completo de un programa: rangos de cada fase derivados del
/// [ProgramState]. Lo consumen el calendario interactivo (colores) y la vista
/// de hoy (fase/día o cuenta regresiva).
class PhaseSchedule {
  PhaseSchedule({
    required this.hard75,
    required this.phase1,
    required this.phase2,
    required this.phase3,
  });

  final DateRange hard75;
  final DateRange phase1;
  final DateRange phase2;
  final DateRange phase3;

  /// Construye el calendario si el [state] ya tiene programadas las Fases 1 y 2.
  /// Devuelve `null` si todavía falta programar (onboarding incompleto).
  static PhaseSchedule? tryFromState(ProgramState state) {
    final p1 = state.phase1StartDate;
    final p2 = state.phase2StartDate;
    if (p1 == null || p2 == null) return null;

    const logic = ProgramDateLogic();
    return PhaseSchedule(
      hard75: DateRange(
        state.programStartDate,
        logic.phaseEndDate(state.programStartDate, ProgramPhase.hard75),
      ),
      phase1: DateRange(p1, logic.phaseEndDate(p1, ProgramPhase.phase1)),
      phase2: DateRange(p2, logic.phaseEndDate(p2, ProgramPhase.phase2)),
      phase3: DateRange(
        logic.mandatoryPhase3Start(state),
        logic.phase3End(state),
      ),
    );
  }

  /// Rangos de las 3 fases programables, en orden (para pintar el calendario).
  List<MapEntry<ProgramPhase, DateRange>> get phaseRanges => [
        MapEntry(ProgramPhase.phase1, phase1),
        MapEntry(ProgramPhase.phase2, phase2),
        MapEntry(ProgramPhase.phase3, phase3),
      ];

  /// Fase a la que pertenece [date], o `null` si cae fuera (descanso/antes).
  ProgramPhase? phaseOfDay(DateTime date) {
    for (final entry in phaseRanges) {
      if (entry.value.contains(date)) return entry.key;
    }
    return null;
  }

  /// Estado de [date] respecto al programa.
  TodayStatus entryFor(DateTime date) {
    final d = date.dayOnly;

    if (phase1.contains(d)) {
      return TodayStatus.active(ProgramPhase.phase1, phase1.dayNumber(d));
    }
    if (phase2.contains(d)) {
      return TodayStatus.active(ProgramPhase.phase2, phase2.dayNumber(d));
    }
    if (phase3.contains(d)) {
      return TodayStatus.active(ProgramPhase.phase3, phase3.dayNumber(d));
    }

    if (d.isBefore(phase1.start)) {
      return TodayStatus.waiting(ProgramPhase.phase1, d.daysUntil(phase1.start),
          beforeStart: true);
    }
    if (d.isBefore(phase2.start)) {
      return TodayStatus.waiting(ProgramPhase.phase2, d.daysUntil(phase2.start));
    }
    if (d.isBefore(phase3.start)) {
      return TodayStatus.waiting(ProgramPhase.phase3, d.daysUntil(phase3.start));
    }
    return const TodayStatus.done();
  }
}
