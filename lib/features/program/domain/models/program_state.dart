import 'package:isar/isar.dart';

import '../../../../core/enums/program_phase.dart';

part 'program_state.g.dart';

/// Estado global del recorrido del usuario. Se espera un único documento
/// (singleton) con [id] == 1. Guarda la fecha de inicio del programa,
/// la fase actual y el historial de intentos fallidos.
@collection
class ProgramState {
  /// ID fijo: solo existe una instancia de estado por usuario/dispositivo.
  Id id = 1;

  /// Día 1 del 75 Hard original. Es el ancla para el cálculo del aniversario
  /// que determina la fecha obligatoria de la Fase 3.
  late DateTime programStartDate;

  /// `true` cuando el usuario terminó el onboarding (ya dio la fecha del 75
  /// Hard y programó las fases). Mientras sea `false`, la app muestra el wizard.
  bool onboardingComplete = false;

  // -----------------------------------------------------------------
  // Programación de fases (modelo "agendado por adelantado").
  // La fase/día de HOY se DERIVA de estas fechas (ver PhaseSchedule); ya no se
  // avanza de fase en vivo. Fase 3 es estática: se calcula desde el aniversario.
  // -----------------------------------------------------------------

  /// Día 1 programado de la Fase 1 (`null` hasta que se agenda).
  DateTime? phase1StartDate;

  /// Día 1 programado de la Fase 2 (`null` hasta que se agenda).
  DateTime? phase2StartDate;

  /// Fase en curso. **Legacy/secundario**: se conserva para no romper el flujo
  /// de avance en vivo; la vista de hoy usa [PhaseSchedule] en su lugar.
  @enumerated
  ProgramPhase currentPhase = ProgramPhase.hard75;

  /// Día 1 de la fase ACTUAL en el modelo legacy de avance en vivo.
  late DateTime currentPhaseStartDate;

  /// Fecha en que se completó la Fase 1. Necesaria para validar la espera
  /// obligatoria de 30 días antes de poder iniciar la Fase 2. `null` si aún
  /// no se ha terminado la Fase 1.
  DateTime? phase1CompletedDate;

  /// `true` si el usuario reprobó el año en Fase 3 y debe reiniciar todo.
  bool yearFailed = false;

  /// Historial de intentos fallidos (objetos embebidos).
  List<FailedAttempt> failedAttempts = [];
}

/// Un intento fallido: qué fase, cuándo falló y a qué día había llegado.
@embedded
class FailedAttempt {
  late DateTime failedAt;

  @enumerated
  late ProgramPhase phase;

  /// Día de la fase en el que se rompió la racha.
  late int dayReached;

  /// Nota opcional (qué regla se rompió).
  String? reason;

  FailedAttempt();

  FailedAttempt.create({
    required this.failedAt,
    required this.phase,
    required this.dayReached,
    this.reason,
  });
}
