import 'package:flutter_test/flutter_test.dart';
import 'package:livehard_app/core/enums/program_phase.dart';
import 'package:livehard_app/features/program/application/program_date_logic.dart';
import 'package:livehard_app/features/program/domain/models/program_state.dart';

void main() {
  const logic = ProgramDateLogic();

  ProgramState stateWith({
    required DateTime programStart,
    DateTime? phase1Completed,
  }) {
    return ProgramState()
      ..programStartDate = programStart
      ..currentPhaseStartDate = programStart
      ..phase1CompletedDate = phase1Completed;
  }

  group('Fase 2 — descanso obligatorio de 30 días', () {
    final state = stateWith(
      programStart: DateTime(2025, 1, 1),
      phase1Completed: DateTime(2025, 6, 1),
    );

    test('bloqueada el día 29 después de terminar Fase 1', () {
      final gate = logic.canStartPhase2(state, now: DateTime(2025, 6, 30));
      expect(gate.allowed, isFalse);
    });

    test('permitida exactamente a los 30 días', () {
      final gate = logic.canStartPhase2(state, now: DateTime(2025, 7, 1));
      expect(gate.allowed, isTrue);
    });

    test('bloqueada si la Fase 1 no se ha completado', () {
      final noPhase1 = stateWith(programStart: DateTime(2025, 1, 1));
      final gate = logic.canStartPhase2(noPhase1, now: DateTime(2026, 1, 1));
      expect(gate.allowed, isFalse);
    });
  });

  group('Fase 3 — 30 días antes del aniversario del Día 1', () {
    final state = stateWith(programStart: DateTime(2025, 3, 10));

    test('la fecha obligatoria es aniversario - 30 días', () {
      // Aniversario: 2026-03-10  ->  inicio Fase 3: 2026-02-08
      expect(logic.mandatoryPhase3Start(state), DateTime(2026, 2, 8));
    });

    test('solo se permite el día exacto', () {
      expect(logic.canStartPhase3(state, now: DateTime(2026, 2, 7)).allowed,
          isFalse);
      expect(logic.canStartPhase3(state, now: DateTime(2026, 2, 8)).allowed,
          isTrue);
      expect(logic.canStartPhase3(state, now: DateTime(2026, 2, 9)).allowed,
          isFalse);
    });
  });

  group('Número de día dentro de la fase', () {
    test('el día de inicio es el día 1', () {
      final state = stateWith(programStart: DateTime(2025, 1, 1))
        ..currentPhaseStartDate = DateTime(2025, 1, 1);
      expect(logic.dayNumberInPhase(state, now: DateTime(2025, 1, 1)), 1);
      expect(logic.dayNumberInPhase(state, now: DateTime(2025, 1, 10)), 10);
    });
  });
}
