import 'package:flutter_test/flutter_test.dart';
import 'package:livehard_app/core/enums/program_phase.dart';
import 'package:livehard_app/core/utils/date_x.dart';
import 'package:livehard_app/features/program/domain/models/phase_schedule.dart';
import 'package:livehard_app/features/program/domain/models/program_state.dart';
import 'package:livehard_app/features/program/domain/models/streak_failure.dart';

void main() {
  // Calendario de referencia:
  //  75 Hard : 2025-01-01 .. 2025-03-16
  //  Fase 1  : 2025-04-01 .. 2025-04-30
  //  Fase 2  : 2025-06-01 .. 2025-06-30
  //  Fase 3  : 2025-12-03 .. 2026-01-01 (estática, termina en el aniversario)
  final schedule = PhaseSchedule.tryFromState(
    ProgramState()
      ..programStartDate = DateTime(2025, 1, 1)
      ..currentPhaseStartDate = DateTime(2025, 1, 1)
      ..phase1StartDate = DateTime(2025, 4, 1)
      ..phase2StartDate = DateTime(2025, 6, 1),
  )!;

  /// Construye el set de días completos para un rango [from..to] inclusive,
  /// excluyendo las fechas en [except] (los días "fallados").
  Set<DateTime> completedRange(DateTime from, DateTime to,
      {Set<DateTime> except = const {}}) {
    final days = <DateTime>{};
    for (var d = from.dayOnly;
        !d.isAfter(to.dayOnly);
        d = d.add(const Duration(days: 1)).dayOnly) {
      if (!except.contains(d)) days.add(d);
    }
    return days;
  }

  group('detectStreakFailure', () {
    test('sin días pasados (antes de la Fase 1) no hay fallo', () {
      final f = detectStreakFailure(
        schedule: schedule,
        completedDates: const {},
        now: DateTime(2025, 3, 1),
      );
      expect(f, isNull);
    });

    test('el día de HOY incompleto NO cuenta como fallo (sigue en curso)', () {
      // Día 5 de Fase 1 es hoy; los 4 previos están completos.
      final completed =
          completedRange(DateTime(2025, 4, 1), DateTime(2025, 4, 4));
      final f = detectStreakFailure(
        schedule: schedule,
        completedDates: completed,
        now: DateTime(2025, 4, 5),
      );
      expect(f, isNull);
    });

    test('detecta el primer día pasado sin completar en Fase 1', () {
      // Hoy es el día 10 de Fase 1; el día 3 (2025-04-03) quedó incompleto.
      final completed = completedRange(
        DateTime(2025, 4, 1),
        DateTime(2025, 4, 9),
        except: {DateTime(2025, 4, 3)},
      );
      final f = detectStreakFailure(
        schedule: schedule,
        completedDates: completed,
        now: DateTime(2025, 4, 10),
      );
      expect(f, isNotNull);
      expect(f!.phase, ProgramPhase.phase1);
      expect(f.dayNumber, 3);
      expect(f.date, DateTime(2025, 4, 3));
      expect(f.requiresFullReset, isFalse);
    });

    test('devuelve el fallo MÁS temprano cuando hay varios', () {
      final completed = completedRange(
        DateTime(2025, 4, 1),
        DateTime(2025, 4, 20),
        except: {DateTime(2025, 4, 5), DateTime(2025, 4, 12)},
      );
      final f = detectStreakFailure(
        schedule: schedule,
        completedDates: completed,
        now: DateTime(2025, 4, 21),
      );
      expect(f!.dayNumber, 5);
    });

    test('ningún fallo si todos los días pasados están completos', () {
      // Fase 1 completa entera; hoy es un día de descanso posterior.
      final completed =
          completedRange(DateTime(2025, 4, 1), DateTime(2025, 4, 30));
      final f = detectStreakFailure(
        schedule: schedule,
        completedDates: completed,
        now: DateTime(2025, 5, 15),
      );
      expect(f, isNull);
    });

    test('los huecos del periodo de descanso NO son fallos', () {
      // Fase 1 completa; estamos en Fase 2 día 5 con los previos completos.
      // Entre Fase 1 y Fase 2 (mayo) no se exige nada.
      final completed = {
        ...completedRange(DateTime(2025, 4, 1), DateTime(2025, 4, 30)),
        ...completedRange(DateTime(2025, 6, 1), DateTime(2025, 6, 4)),
      };
      final f = detectStreakFailure(
        schedule: schedule,
        completedDates: completed,
        now: DateTime(2025, 6, 5),
      );
      expect(f, isNull);
    });

    test('fallar la Fase 3 marca requiresFullReset', () {
      // Fases 1 y 2 completas; en Fase 3 el día 2 (2025-12-04) quedó incompleto.
      final completed = {
        ...completedRange(DateTime(2025, 4, 1), DateTime(2025, 4, 30)),
        ...completedRange(DateTime(2025, 6, 1), DateTime(2025, 6, 30)),
        ...completedRange(
          DateTime(2025, 12, 3),
          DateTime(2025, 12, 10),
          except: {DateTime(2025, 12, 4)},
        ),
      };
      final f = detectStreakFailure(
        schedule: schedule,
        completedDates: completed,
        now: DateTime(2025, 12, 11),
      );
      expect(f!.phase, ProgramPhase.phase3);
      expect(f.dayNumber, 2);
      expect(f.requiresFullReset, isTrue);
    });
  });
}
