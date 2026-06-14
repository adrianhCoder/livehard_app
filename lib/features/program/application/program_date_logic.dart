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

/// Opciones para (re)programar el inicio de la próxima fase desde la pantalla
/// de descanso. La Fase 3 es estática: [adjustable] == false.
class PhaseStartOptions {
  const PhaseStartOptions({
    required this.phase,
    required this.adjustable,
    required this.canStartToday,
    this.earliest,
    this.latest,
    this.note,
  });

  final ProgramPhase phase;

  /// `false` para la Fase 3 (fecha fija): no se puede iniciar ni mover.
  final bool adjustable;

  /// `true` si HOY es una fecha válida de inicio (habilita "Iniciar ahora").
  final bool canStartToday;

  /// Primera y última fecha seleccionable al ajustar (inclusive).
  final DateTime? earliest;
  final DateTime? latest;

  /// Explicación legible (descanso restante, fecha fija, etc.).
  final String? note;
}

/// Reglas de calendario del programa Live Hard. **Dart puro y sin estado**:
/// recibe siempre las fechas (o el [ProgramState]) y un `now` inyectable para
/// poder testear.
///
/// Convenciones (rangos inclusivos, fechas normalizadas con [DateX.dayOnly]):
///  - Cada fase dura [ProgramPhase.durationDays] días: 75 Hard = 75, Fases = 30.
///  - `finDeFase = inicio + (durationDays - 1)`.
class ProgramDateLogic {
  const ProgramDateLogic();

  /// Días mínimos de descanso obligatorio tras terminar la Fase 1
  /// antes de poder iniciar la Fase 2.
  static const int phase2RestDays = 30;

  // ----------------------------------------------------------------
  // Helpers de fase genéricos.
  // ----------------------------------------------------------------

  /// Último día (inclusive) de una fase que empieza en [start].
  DateTime phaseEndDate(DateTime start, ProgramPhase phase) =>
      start.dayOnly.add(Duration(days: phase.durationDays - 1));

  /// Último día (inclusive) del 75 Hard a partir del Día 1.
  DateTime hard75LastDay(ProgramState state) =>
      phaseEndDate(state.programStartDate, ProgramPhase.hard75);

  // ----------------------------------------------------------------
  // FASE 3 — ventana ESTÁTICA que TERMINA en el aniversario del Día 1.
  // ----------------------------------------------------------------

  /// Aniversario del Día 1 de 75 Hard (programStartDate + 1 año).
  DateTime anniversaryOf75Hard(ProgramState state) =>
      state.programStartDate.dayOnly.addYears(1);

  /// Último día de la Fase 3 = el aniversario.
  DateTime phase3End(ProgramState state) => anniversaryOf75Hard(state);

  /// Día 1 OBLIGATORIO de la Fase 3 a partir del Día 1 del 75 Hard.
  /// La Fase 3 ocupa los 30 días que TERMINAN en el aniversario.
  DateTime mandatoryPhase3StartFor(DateTime hard75Day1) => hard75Day1.dayOnly
      .addYears(1)
      .subtract(Duration(days: ProgramPhase.phase3.durationDays - 1));

  /// Día 1 obligatorio de la Fase 3 derivado del [state].
  DateTime mandatoryPhase3Start(ProgramState state) =>
      mandatoryPhase3StartFor(state.programStartDate);

  // ----------------------------------------------------------------
  // FASE 1 — empieza después de terminar el 75 Hard.
  // ----------------------------------------------------------------

  /// Primera fecha válida para iniciar la Fase 1: el día siguiente al fin del
  /// 75 Hard, y nunca en el pasado.
  DateTime earliestPhase1StartFor(DateTime hard75Day1, {DateTime? now}) {
    final today = (now ?? DateTime.now()).dayOnly;
    final afterHard75 =
        phaseEndDate(hard75Day1, ProgramPhase.hard75).add(const Duration(days: 1));
    return afterHard75.isAfter(today) ? afterHard75 : today;
  }

  /// Sugerencia por defecto de inicio de Fase 1: hoy + 7 días (o el mínimo
  /// válido si ese mínimo es posterior).
  DateTime defaultPhase1StartFor(DateTime hard75Day1, {DateTime? now}) {
    final today = (now ?? DateTime.now()).dayOnly;
    final inAWeek = today.add(const Duration(days: 7));
    final earliest = earliestPhase1StartFor(hard75Day1, now: now);
    return inAWeek.isAfter(earliest) ? inAWeek : earliest;
  }

  // ----------------------------------------------------------------
  // FASE 2 — descanso obligatorio de 30 días tras terminar la Fase 1,
  //          y debe terminar antes de que empiece la Fase 3.
  // ----------------------------------------------------------------

  /// Primera fecha válida para iniciar la Fase 2 dado el inicio de la Fase 1:
  /// fin de la Fase 1 + 30 días de descanso.
  DateTime earliestPhase2StartFrom(DateTime phase1Start) =>
      phaseEndDate(phase1Start, ProgramPhase.phase1)
          .add(const Duration(days: phase2RestDays));

  /// Última fecha válida para iniciar la Fase 2 de modo que termine antes de
  /// que empiece la Fase 3 (estática).
  DateTime latestPhase2StartFor(DateTime hard75Day1) =>
      mandatoryPhase3StartFor(hard75Day1)
          .subtract(Duration(days: ProgramPhase.phase2.durationDays));

  /// ¿Puede el usuario iniciar la Fase 2 hoy? (modelo legacy de avance en vivo)
  PhaseGate canStartPhase2(ProgramState state, {DateTime? now}) {
    final today = (now ?? DateTime.now()).dayOnly;
    final completed = state.phase1CompletedDate;
    if (completed == null) {
      return PhaseGate(
        allowed: false,
        earliestDate: today,
        reason: 'Primero debes completar la Fase 1.',
      );
    }

    final earliest = completed.dayOnly.add(const Duration(days: phase2RestDays));
    final remaining = today.daysUntil(earliest);
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

  /// ¿Puede iniciarse la Fase 3 hoy? La ventana es EXACTA (un solo día).
  PhaseGate canStartPhase3(ProgramState state, {DateTime? now}) {
    final today = (now ?? DateTime.now()).dayOnly;
    final start = mandatoryPhase3Start(state);
    final diff = today.daysUntil(start);

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
  // Opciones de (re)programación de la PRÓXIMA fase (pantalla de descanso).
  // ----------------------------------------------------------------

  /// Calcula si la próxima [phase] se puede iniciar hoy y en qué ventana de
  /// fechas se puede reprogramar, según las reglas vigentes:
  ///  - Fase 1: desde hoy (el 75 Hard ya terminó), con tope para que quepan el
  ///    descanso + la Fase 2 antes de la Fase 3.
  ///  - Fase 2: mínimo [phase2RestDays] días de descanso tras la Fase 1, y debe
  ///    terminar antes de la Fase 3.
  ///  - Fase 3: **estática**, no es ajustable ([PhaseStartOptions.adjustable]
  ///    == false).
  PhaseStartOptions optionsForNextPhase(ProgramState state, ProgramPhase phase,
      {DateTime? now}) {
    final today = (now ?? DateTime.now()).dayOnly;

    switch (phase) {
      case ProgramPhase.phase1:
        final restMin = earliestPhase1StartFor(state.programStartDate, now: now);
        final earliest = restMin.isAfter(today) ? restMin : today;
        // La Fase 1 debe empezar con margen para descanso (30) + Fase 2 (30).
        final latest = mandatoryPhase3Start(state)
            .subtract(Duration(days: phase2RestDays + ProgramPhase.phase2.durationDays + ProgramPhase.phase1.durationDays - 1));
        final hasRoom = !earliest.isAfter(latest);
        return PhaseStartOptions(
          phase: phase,
          adjustable: hasRoom,
          canStartToday: hasRoom && !today.isAfter(latest),
          earliest: earliest,
          latest: latest,
          note: hasRoom
              ? null
              : 'No hay espacio para la Fase 1 antes de la Fase 3.',
        );

      case ProgramPhase.phase2:
        final p1 = state.phase1StartDate;
        if (p1 == null) {
          return PhaseStartOptions(
            phase: phase,
            adjustable: false,
            canStartToday: false,
            note: 'Primero programa la Fase 1.',
          );
        }
        final restMin = earliestPhase2StartFrom(p1);
        final earliest = restMin.isAfter(today) ? restMin : today;
        final latest = latestPhase2StartFor(state.programStartDate);
        final hasRoom = !earliest.isAfter(latest);
        final restRemaining = today.daysUntil(restMin);
        return PhaseStartOptions(
          phase: phase,
          adjustable: hasRoom,
          canStartToday: hasRoom && !today.isBefore(restMin) && !today.isAfter(latest),
          earliest: earliest,
          latest: latest,
          note: restRemaining > 0
              ? 'Mínimo $phase2RestDays días de descanso: disponible desde el ${_fmt(restMin)} (faltan $restRemaining día[s]).'
              : (hasRoom ? null : 'Ya no cabe la Fase 2 antes de la Fase 3.'),
        );

      case ProgramPhase.phase3:
        final start = mandatoryPhase3Start(state);
        return PhaseStartOptions(
          phase: phase,
          adjustable: false,
          canStartToday: false,
          earliest: start,
          latest: start,
          note: 'La Fase 3 tiene fecha fija (termina en el aniversario de tu '
              'Día 1) y no se puede mover.',
        );

      case ProgramPhase.hard75:
        return PhaseStartOptions(
          phase: phase,
          adjustable: false,
          canStartToday: false,
        );
    }
  }

  // ----------------------------------------------------------------
  // Validación del calendario completo (onboarding / reconfiguración).
  // ----------------------------------------------------------------

  /// Devuelve la lista de problemas (vacía = horario válido) para un calendario
  /// propuesto. Trabaja con fechas crudas porque corre ANTES de persistir.
  List<String> validateSchedule({
    required DateTime hard75Day1,
    required DateTime phase1Start,
    required DateTime phase2Start,
    DateTime? now,
  }) {
    final problems = <String>[];
    final day1 = hard75Day1.dayOnly;
    final p1 = phase1Start.dayOnly;
    final p2 = phase2Start.dayOnly;

    final minP1 = earliestPhase1StartFor(day1, now: now);
    final p3Start = mandatoryPhase3StartFor(day1);
    final minP2 = earliestPhase2StartFrom(p1);
    final maxP2 = latestPhase2StartFor(day1);

    if (p1.isBefore(minP1)) {
      problems.add(
          'La Fase 1 debe empezar el ${_fmt(minP1)} o después (tras el 75 Hard y no en el pasado).');
    }
    if (p2.isBefore(minP2)) {
      problems.add(
          'La Fase 2 debe empezar el ${_fmt(minP2)} o después ($phase2RestDays días de descanso tras la Fase 1).');
    }
    if (p2.isAfter(maxP2)) {
      problems.add(
          'La Fase 2 debe terminar antes de la Fase 3 (inicio máximo: ${_fmt(maxP2)}, Fase 3 inicia ${_fmt(p3Start)}).');
    }
    if (minP2.isAfter(maxP2)) {
      problems.add(
          'Con esa fecha de Fase 1 no cabe la Fase 2 antes de la Fase 3. Adelanta la Fase 1.');
    }
    return problems;
  }

  // ----------------------------------------------------------------
  // Helpers de racha / día actual (modelo legacy de avance en vivo).
  // ----------------------------------------------------------------

  /// Número de día (1-based) dentro de la fase actual para una fecha dada.
  int dayNumberInPhase(ProgramState state, {DateTime? now}) {
    final today = (now ?? DateTime.now()).dayOnly;
    return state.currentPhaseStartDate.dayOnly.daysUntil(today) + 1;
  }

  /// ¿Se ha alcanzado el último día de la fase actual?
  bool isPhaseComplete(ProgramState state, {DateTime? now}) =>
      dayNumberInPhase(state, now: now) >= state.currentPhase.durationDays;

  static String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
