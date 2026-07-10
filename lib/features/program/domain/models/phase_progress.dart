import '../../../../core/enums/program_phase.dart';
import 'phase_schedule.dart';

/// Progreso real de UNA fase, derivado de los [DailyRecord] guardados en la base de datos.
/// Alimenta las tarjetas y el calendario de la pantalla de progreso.
class PhaseProgress {
  PhaseProgress({
    required this.phase,
    required this.range,
    required this.completedDays,
    this.partialDays = const {},
    this.currentDay,
  });

  final ProgramPhase phase;
  final DateRange range;

  /// Números de día (1-based) totalmente completados.
  final Set<int> completedDays;

  /// Días con registro pero incompletos (alguna tarea hecha, no todas).
  final Set<int> partialDays;

  /// Número de día de HOY dentro de esta fase, o `null` si no está activa.
  final int? currentDay;

  bool get isCurrent => currentDay != null;
  int get completedCount => completedDays.length;
  int get totalDays => range.lengthInDays;
  DateTime get startDate => range.start;
}
