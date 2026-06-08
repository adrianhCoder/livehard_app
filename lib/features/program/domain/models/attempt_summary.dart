import '../../../../core/enums/program_phase.dart';

/// Resumen de UN intento (racha) de una fase, para la pantalla de progreso.
///
/// Por ahora se alimenta de mock data; más adelante se derivará de los
/// [DailyRecord] guardados en Isar (un intento = el tramo entre un inicio de
/// fase y el siguiente reinicio/avance).
class AttemptSummary {
  const AttemptSummary({
    required this.phase,
    required this.startDate,
    required this.completedDays,
    this.imagePath,
    this.isCurrent = false,
  });

  /// Fase a la que pertenece el intento (define cuántos días dura el calendario).
  final ProgramPhase phase;

  /// Día 1 del intento.
  final DateTime startDate;

  /// Días completados dentro de esta racha (se pintan en rojo en el calendario).
  final int completedDays;

  /// Ruta local de la foto de portada del intento (mock: `null`).
  final String? imagePath;

  /// `true` para el intento activo (borde rojo + ícono de editar calendario).
  final bool isCurrent;

  /// Total de días que exige la fase (75 Hard = 75; Fase 1/2/3 = 30).
  int get totalDays => phase.durationDays;
}
