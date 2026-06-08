import 'package:flutter_test/flutter_test.dart';
import 'package:livehard_app/core/enums/program_phase.dart';
import 'package:livehard_app/features/program/application/program_date_logic.dart';
import 'package:livehard_app/features/program/domain/models/phase_schedule.dart';
import 'package:livehard_app/features/program/domain/models/program_state.dart';

void main() {
  const logic = ProgramDateLogic();

  ProgramState stateWith({
    required DateTime programStart,
    DateTime? phase1Completed,
    DateTime? phase1Start,
    DateTime? phase2Start,
  }) {
    return ProgramState()
      ..programStartDate = programStart
      ..currentPhaseStartDate = programStart
      ..phase1CompletedDate = phase1Completed
      ..phase1StartDate = phase1Start
      ..phase2StartDate = phase2Start;
  }

  group('Fase 2 — descanso obligatorio de 30 días (avance en vivo)', () {
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

  group('Fase 3 — 30 días que TERMINAN en el aniversario del Día 1', () {
    final state = stateWith(programStart: DateTime(2025, 3, 10));

    test('la Fase 3 termina en el aniversario', () {
      // Aniversario: 2026-03-10. Inicio Fase 3 = aniversario - 29 = 2026-02-09.
      expect(logic.mandatoryPhase3Start(state), DateTime(2026, 2, 9));
      expect(logic.phase3End(state), DateTime(2026, 3, 10));
    });

    test('solo se permite el día exacto', () {
      expect(logic.canStartPhase3(state, now: DateTime(2026, 2, 8)).allowed,
          isFalse);
      expect(logic.canStartPhase3(state, now: DateTime(2026, 2, 9)).allowed,
          isTrue);
      expect(logic.canStartPhase3(state, now: DateTime(2026, 2, 10)).allowed,
          isFalse);
    });
  });

  group('Helpers de programación', () {
    final day1 = DateTime(2025, 1, 1);

    test('earliestPhase2StartFrom = fin de Fase 1 + 30 días', () {
      // Fase 1: 2025-04-01..2025-04-30; +30 => 2025-05-30.
      expect(logic.earliestPhase2StartFrom(DateTime(2025, 4, 1)),
          DateTime(2025, 5, 30));
    });

    test('latestPhase2StartFor deja terminar la Fase 2 antes de la Fase 3', () {
      // Fase 3 inicia 2025-12-03; -30 => 2025-11-03.
      expect(logic.latestPhase2StartFor(day1), DateTime(2025, 11, 3));
    });

    test('earliestPhase1StartFor nunca cae en el pasado', () {
      final now = DateTime(2025, 6, 1);
      expect(logic.earliestPhase1StartFor(day1, now: now), now);
    });
  });

  group('validateSchedule', () {
    final day1 = DateTime(2025, 1, 1);
    final now = DateTime(2025, 3, 20);

    test('calendario válido no tiene problemas', () {
      final problems = logic.validateSchedule(
        hard75Day1: day1,
        phase1Start: DateTime(2025, 4, 1),
        phase2Start: DateTime(2025, 6, 1),
        now: now,
      );
      expect(problems, isEmpty);
    });

    test('Fase 2 demasiado temprano (sin descanso) es inválida', () {
      final problems = logic.validateSchedule(
        hard75Day1: day1,
        phase1Start: DateTime(2025, 4, 1),
        phase2Start: DateTime(2025, 5, 1), // < 2025-05-30
        now: now,
      );
      expect(problems, isNotEmpty);
    });
  });

  group('PhaseSchedule.entryFor', () {
    final schedule = PhaseSchedule.tryFromState(stateWith(
      programStart: DateTime(2025, 1, 1),
      phase1Start: DateTime(2025, 4, 1),
      phase2Start: DateTime(2025, 6, 1),
    ))!;

    test('día activo de Fase 1 con su número de día', () {
      final s = schedule.entryFor(DateTime(2025, 4, 10));
      expect(s.kind, TodayKind.active);
      expect(s.phase, ProgramPhase.phase1);
      expect(s.dayNumber, 10);
    });

    test('antes de empezar la Fase 1', () {
      final s = schedule.entryFor(DateTime(2025, 3, 1));
      expect(s.kind, TodayKind.beforeStart);
      expect(s.nextPhase, ProgramPhase.phase1);
    });

    test('descanso entre Fase 1 y Fase 2', () {
      final s = schedule.entryFor(DateTime(2025, 5, 15));
      expect(s.kind, TodayKind.waiting);
      expect(s.nextPhase, ProgramPhase.phase2);
    });

    test('Fase 3 termina en el aniversario y luego done', () {
      expect(schedule.entryFor(DateTime(2026, 1, 1)).phase, ProgramPhase.phase3);
      expect(schedule.entryFor(DateTime(2026, 2, 1)).kind, TodayKind.done);
    });
  });
}
