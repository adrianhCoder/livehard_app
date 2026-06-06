import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/enums/program_phase.dart';
import '../../../core/utils/date_x.dart';
import '../domain/models/program_state.dart';
import 'program_date_logic.dart';
import 'program_providers.dart';

// Tras editar: dart run build_runner build --delete-conflicting-outputs
part 'program_controller.g.dart';

/// Se lanza al intentar iniciar una fase fuera de su ventana de calendario.
/// Lleva el [PhaseGate] para que la UI muestre la razón y la fecha permitida.
class PhaseGateException implements Exception {
  PhaseGateException(this.gate);

  final PhaseGate gate;

  @override
  String toString() => gate.reason ?? 'No se puede iniciar la fase todavía.';
}

/// Controlador de acciones sobre el [ProgramState]: iniciar el programa,
/// avanzar de fase, registrar fallos y reinicios.
///
/// Es un notifier "de acciones" (su estado es `void`): la UI lee el estado en
/// vivo desde [programStateProvider]; aquí solo viven las mutaciones.
@riverpod
class ProgramController extends _$ProgramController {
  @override
  void build() {}

  ProgramRepository get _repo => ref.read(programRepositoryProvider);
  ProgramDateLogic get _logic => ref.read(programDateLogicProvider);

  ProgramState _requireState() {
    final state = _repo.getState();
    if (state == null) {
      throw StateError('No hay un programa iniciado.');
    }
    return state;
  }

  /// Arranca el programa en la Fase 75 Hard. [startDate] por defecto es hoy.
  Future<void> startProgram({DateTime? startDate}) async {
    await _repo.startProgram((startDate ?? DateTime.now()).dayOnly);
  }

  /// Marca la Fase 1 como completada hoy. Necesario porque la Fase 2 exige
  /// 30 días de descanso CONTADOS desde esta fecha (ver [ProgramDateLogic]).
  Future<void> markPhase1Completed({DateTime? now}) async {
    final state = _requireState();
    state.phase1CompletedDate = (now ?? DateTime.now()).dayOnly;
    await _repo.saveState(state);
  }

  /// Avanza a la siguiente fase respetando las puertas de calendario.
  ///
  /// Lanza [PhaseGateException] si la fase destino tiene una ventana de inicio
  /// (Fase 2: descanso de 30 días; Fase 3: fecha exacta) y hoy no la cumple.
  /// Lanza [StateError] si ya se está en la última fase.
  Future<void> advanceToNextPhase({DateTime? now}) async {
    final state = _requireState();
    final next = state.currentPhase.next;
    if (next == null) {
      throw StateError('Ya estás en la última fase del programa.');
    }

    // Valida la ventana de inicio de la fase destino.
    final gate = switch (next) {
      ProgramPhase.phase2 => _logic.canStartPhase2(state, now: now),
      ProgramPhase.phase3 => _logic.canStartPhase3(state, now: now),
      _ => null,
    };
    if (gate != null && !gate.allowed) {
      throw PhaseGateException(gate);
    }

    state.currentPhase = next;
    state.currentPhaseStartDate = (now ?? DateTime.now()).dayOnly;
    await _repo.saveState(state);
  }

  /// Registra que se rompió la racha y reinicia la fase ACTUAL desde hoy.
  /// Guarda el intento fallido (fase, día alcanzado y motivo opcional).
  Future<void> restartCurrentPhase({String? reason, DateTime? now}) async {
    final state = _requireState();
    final today = (now ?? DateTime.now()).dayOnly;

    state.failedAttempts = [
      ...state.failedAttempts,
      FailedAttempt.create(
        failedAt: today,
        phase: state.currentPhase,
        dayReached: _logic.dayNumberInPhase(state, now: today),
        reason: reason,
      ),
    ];
    state.currentPhaseStartDate = today;
    await _repo.saveState(state);
  }

  /// Falla del año en Fase 3: marca [ProgramState.yearFailed] y deja registro.
  /// No reinicia fechas automáticamente; eso lo decide el flujo de la UI
  /// (p. ej. ofrecer arrancar un programa nuevo con [startProgram]).
  Future<void> markYearFailed({String? reason, DateTime? now}) async {
    final state = _requireState();
    final today = (now ?? DateTime.now()).dayOnly;

    state.yearFailed = true;
    state.failedAttempts = [
      ...state.failedAttempts,
      FailedAttempt.create(
        failedAt: today,
        phase: state.currentPhase,
        dayReached: _logic.dayNumberInPhase(state, now: today),
        reason: reason ?? 'Año reprobado en Fase 3.',
      ),
    ];
    await _repo.saveState(state);
  }
}
