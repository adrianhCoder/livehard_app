import '../../../core/enums/program_phase.dart';
import '../../../core/utils/date_x.dart';
import '../domain/models/program_state.dart';

/// Resultado de evaluar si una fase con regla de fecha puede iniciarse hoy.
class PhaseGate {
  const PhaseGate({
    required this.allowed,
    required this.earliestDate,
    this.latestDate,
    this.reason,
  });

  /// `true` si HOY está dentro de la ventana permitida para iniciar.
  final bool allowed;

  /// Primera fecha en la que se puede iniciar la fase.
  final DateTime earliestDate;

  /// Última fecha válida (solo Fase 3 tiene ventana exacta). `null` = sin tope.
  final DateTime? latestDate;

  /// Explicación legible para mostrar en la UI.
  final String? reason;
}

/// Reglas de calendario del programa Live Hard. **Dart puro y sin estado**:
/// recibe siempre el [ProgramState] y un `now` inyectable para poder testear.
class ProgramDateLogic {
  const ProgramDateLogic();

  /// Días mínimos de descanso obligatorio tras terminar la Fase 1
  /// antes de poder iniciar la Fase 2.
  static const int phase2RestDays = 30;

  /// La Fase 3 debe iniciar exactamente este número de días ANTES del
  /// aniversario del Día 1 de 75 Hard.
  static const int phase3DaysBeforeAnniversary = 30;

  // ----------------------------------------------------------------
  // FASE 2 — espera obligatoria de 30 días tras terminar la Fase 1.
  // ----------------------------------------------------------------

  /// Primera fecha en la que se puede iniciar la Fase 2.
  /// Lanza si la Fase 1 aún no ha sido completada.
  DateTime earliestPhase2Start(ProgramState state) {
    final completed = state.phase1CompletedDate;
    if (completed == null) {
      throw StateError(
          'No se puede calcular el inicio de Fase 2: la Fase 1 no está completada.');
    }
    return completed.dayOnly.add(const Duration(days: phase2RestDays));
  }

  /// ¿Puede el usuario iniciar la Fase 2 hoy?
  PhaseGate canStartPhase2(ProgramState state, {DateTime? now}) {
    final today = (now ?? DateTime.now()).dayOnly;

    if (state.phase1CompletedDate == null) {
      // Sin Fase 1 terminada no hay fecha base; devolvemos puerta cerrada.
      return PhaseGate(
        allowed: false,
        earliestDate: today,
        reason: 'Primero debes completar la Fase 1.',
      );
    }

    final earliest = earliestPhase2Start(state);
    final remaining = today.daysUntil(earliest); // >0 = aún faltan días

    if (remaining > 0) {
      return PhaseGate(
        allowed: false,
        earliestDate: earliest,
        reason:
            'Faltan $remaining día(s) de descanso obligatorio para iniciar la Fase 2.',
      );
    }

    return PhaseGate(
      allowed: true,
      earliestDate: earliest,
      reason: 'Descanso de $phase2RestDays días cumplido. Puedes iniciar la Fase 2.',
    );
  }

  // ----------------------------------------------------------------
  // FASE 3 — debe iniciar exactamente 30 días antes del aniversario
  //          del Día 1 de 75 Hard.
  // ----------------------------------------------------------------

  /// Aniversario del Día 1 de 75 Hard (programStartDate + 1 año).
  DateTime anniversaryOf75Hard(ProgramState state) =>
      state.programStartDate.dayOnly.addYears(1);

  /// Fecha OBLIGATORIA de inicio de la Fase 3.
  DateTime mandatoryPhase3Start(ProgramState state) => anniversaryOf75Hard(state)
      .subtract(const Duration(days: phase3DaysBeforeAnniversary));

  /// ¿Puede iniciarse la Fase 3 hoy? La ventana es EXACTA (un solo día).
  ///
  /// `daysUntilStart` en la razón ayuda a la UI a mostrar la cuenta regresiva.
  PhaseGate canStartPhase3(ProgramState state, {DateTime? now}) {
    final today = (now ?? DateTime.now()).dayOnly;
    final start = mandatoryPhase3Start(state);
    final diff = today.daysUntil(start); // 0 = hoy es el día exacto

    if (diff > 0) {
      return PhaseGate(
        allowed: false,
        earliestDate: start,
        latestDate: start,
        reason: 'La Fase 3 inicia en $diff día(s) (fecha fija de calendario).',
      );
    }
    if (diff < 0) {
      return PhaseGate(
        allowed: false,
        earliestDate: start,
        latestDate: start,
        reason:
            'Pasó la fecha obligatoria de inicio de la Fase 3 hace ${-diff} día(s).',
      );
    }
    return PhaseGate(
      allowed: true,
      earliestDate: start,
      latestDate: start,
      reason: 'Hoy es el día exacto para iniciar la Fase 3.',
    );
  }

  // ----------------------------------------------------------------
  // Helpers de racha / día actual.
  // ----------------------------------------------------------------

  /// Número de día (1-based) dentro de la fase actual para una fecha dada.
  int dayNumberInPhase(ProgramState state, {DateTime? now}) {
    final today = (now ?? DateTime.now()).dayOnly;
    return state.currentPhaseStartDate.dayOnly.daysUntil(today) + 1;
  }

  /// ¿Se ha alcanzado el último día de la fase actual?
  bool isPhaseComplete(ProgramState state, {DateTime? now}) =>
      dayNumberInPhase(state, now: now) >= state.currentPhase.durationDays;
}
