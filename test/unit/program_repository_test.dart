import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';

import 'package:livehard_app/core/enums/program_phase.dart';
import 'package:livehard_app/features/program/data/program_repository.dart';
import 'package:livehard_app/features/program/domain/models/daily_record.dart';
import 'package:livehard_app/features/program/domain/models/program_state.dart';

/// Tests del repositorio sobre sembast EN MEMORIA (sin disco): verifican la
/// serialización de los modelos y las semánticas que la app da por hechas
/// (upsert único por fecha, rangos inclusivos, emisión inicial de los streams).
void main() {
  late Database db;
  late ProgramRepository repo;

  setUp(() async {
    // Factory nueva por test: bases de datos totalmente aisladas.
    db = await newDatabaseFactoryMemory().openDatabase('test.db');
    repo = ProgramRepository(db);
  });

  tearDown(() => db.close());

  DateTime day(int n) => DateTime(2026, 1, n);

  DailyRecord record(int n, ProgramPhase phase) => DailyRecord()
    ..date = day(n)
    ..phase = phase
    ..dayNumber = n;

  group('ProgramState', () {
    test('getState devuelve null mientras no hay programa', () async {
      expect(await repo.getState(), isNull);
    });

    test('round-trip completo: enums, fechas opcionales e intentos fallidos',
        () async {
      final state = ProgramState()
        ..programStartDate = DateTime(2025, 5, 1)
        ..onboardingComplete = true
        ..phase1StartDate = DateTime(2025, 8, 1)
        ..phase2StartDate = null
        ..currentPhase = ProgramPhase.phase1
        ..currentPhaseStartDate = DateTime(2025, 8, 1)
        ..yearFailed = false
        ..failedAttempts = [
          FailedAttempt.create(
            failedAt: DateTime(2025, 6, 10),
            phase: ProgramPhase.hard75,
            dayReached: 40,
            reason: 'dieta',
          ),
        ];
      await repo.saveState(state);

      final loaded = await repo.getState();
      expect(loaded, isNotNull);
      expect(loaded!.id, ProgramRepository.stateId);
      expect(loaded.programStartDate, DateTime(2025, 5, 1));
      expect(loaded.onboardingComplete, isTrue);
      expect(loaded.phase1StartDate, DateTime(2025, 8, 1));
      expect(loaded.phase2StartDate, isNull);
      expect(loaded.currentPhase, ProgramPhase.phase1);
      expect(loaded.currentPhaseStartDate, DateTime(2025, 8, 1));
      expect(loaded.phase1CompletedDate, isNull);
      expect(loaded.yearFailed, isFalse);

      final attempt = loaded.failedAttempts.single;
      expect(attempt.failedAt, DateTime(2025, 6, 10));
      expect(attempt.phase, ProgramPhase.hard75);
      expect(attempt.dayReached, 40);
      expect(attempt.reason, 'dieta');

      // La lista viene materializada como lista mutable NUEVA (los snapshots
      // de sembast son inmutables): el patrón `state.failedAttempts.add` /
      // `[...spread]` del controller no debe fallar.
      expect(() => loaded.failedAttempts.add(attempt), returnsNormally);
    });

    test('watchState emite null de inmediato, el estado al guardar y null tras wipeAll',
        () async {
      final emissions = <ProgramState?>[];
      final sub = repo.watchState().listen(emissions.add);
      await pumpEventQueue();
      expect(emissions, [null]);

      await repo.startProgram(DateTime(2026, 2, 1));
      await pumpEventQueue();
      expect(emissions.last?.programStartDate, DateTime(2026, 2, 1));
      expect(emissions.last?.currentPhase, ProgramPhase.hard75);

      await repo.wipeAll();
      await pumpEventQueue();
      expect(emissions.last, isNull);

      await sub.cancel();
    });
  });

  group('DailyRecord', () {
    test('round-trip completo: las 14 tareas, notas y foto', () async {
      final r = record(7, ProgramPhase.phase3)
        ..notes = 'buen día'
        ..imagePath = '/fotos/7.jpg';
      for (final t in DailyTask.values) {
        r.setDone(t, true);
      }
      await repo.saveRecord(r);

      final loaded = await repo.getRecordForDate(day(7));
      expect(loaded, isNotNull);
      expect(loaded!.phase, ProgramPhase.phase3);
      expect(loaded.dayNumber, 7);
      for (final t in DailyTask.values) {
        expect(loaded.isDone(t), isTrue, reason: 'tarea $t');
      }
      expect(loaded.notes, 'buen día');
      expect(loaded.imagePath, '/fotos/7.jpg');
    });

    test('saveRecord hace upsert por fecha: el mismo día nunca se duplica',
        () async {
      await repo.saveRecord(record(5, ProgramPhase.phase1)..workout1 = true);
      // Objeto NUEVO en memoria (sin id) para el mismo día: debe reemplazar.
      await repo.saveRecord(record(5, ProgramPhase.phase1)..waterGallon = true);

      final all = await repo.recordsBetween(day(1), day(31));
      expect(all, hasLength(1));
      expect(all.single.waterGallon, isTrue);
      // Reemplazo completo, como el índice único `replace` de Isar.
      expect(all.single.workout1, isFalse);
    });

    test('saveRecords (bulk) mezcla existentes y nuevos sin duplicar días',
        () async {
      await repo.saveRecord(record(1, ProgramPhase.phase1));
      final existing = (await repo.getRecordForDate(day(1)))!
        ..reading10Pages = true; // registro leído de la base: trae id.
      final fresh = record(2, ProgramPhase.phase1); // día nuevo, sin id.
      final duplicate = record(1, ProgramPhase.phase1) // mismo día 1, sin id.
        ..strictDiet = true;

      await repo.saveRecords([existing, fresh, duplicate]);

      final all = await repo.recordsBetween(day(1), day(31));
      expect(all, hasLength(2));
      expect(all.first.date, day(1));
      // El último write del batch gana (upsert secuencial en una transacción).
      expect(all.first.strictDiet, isTrue);
      expect(all.last.date, day(2));
    });

    test('recordsBetween es inclusivo en ambos extremos y ordena por fecha',
        () async {
      for (final n in [3, 1, 5, 2]) {
        await repo.saveRecord(record(n, ProgramPhase.phase2));
      }

      final inRange = await repo.recordsBetween(day(1), day(3));
      expect(inRange.map((r) => r.date).toList(), [day(1), day(2), day(3)]);
    });

    test('watchRecordForDate emite null para un día sin registro y el registro tras guardarlo',
        () async {
      final emissions = <DailyRecord?>[];
      final sub = repo.watchRecordForDate(day(9)).listen(emissions.add);
      await pumpEventQueue();
      expect(emissions, [null]);

      await repo.saveRecord(record(9, ProgramPhase.phase2)..coldShower = true);
      await pumpEventQueue();
      expect(emissions.last?.coldShower, isTrue);

      await sub.cancel();
    });

    test('deleteRecordsForPhase borra solo esa fase; recordsForPhase filtra',
        () async {
      await repo.saveRecord(record(1, ProgramPhase.phase1));
      await repo.saveRecord(record(2, ProgramPhase.phase1));
      await repo.saveRecord(record(10, ProgramPhase.phase2));

      expect(await repo.recordsForPhase(ProgramPhase.phase1), hasLength(2));

      await repo.deleteRecordsForPhase(ProgramPhase.phase1);

      expect(await repo.recordsForPhase(ProgramPhase.phase1), isEmpty);
      final remaining = await repo.recordsBetween(day(1), day(31));
      expect(remaining.single.phase, ProgramPhase.phase2);
    });
  });

  group('PowerListItem', () {
    test('watchActivePowerListItems emite lista vacía de inmediato (la Power List depende de ello)',
        () async {
      expect(await repo.watchActivePowerListItems().first, isEmpty);
    });

    test('setPowerListText crea, ignora textos idénticos y reemplaza retirando',
        () async {
      await repo.setPowerListText(1, 'Leer 30 min', DateTime(2026, 3, 1));
      var active = await repo.activePowerListItems();
      expect(active.single.text, 'Leer 30 min');
      expect(active.single.startDay, DateTime(2026, 3, 1));
      final firstId = active.single.id;

      // Mismo texto → no-op: conserva id y startDay (la racha no se reinicia).
      await repo.setPowerListText(1, 'Leer 30 min', DateTime(2026, 3, 15));
      active = await repo.activePowerListItems();
      expect(active.single.id, firstId);
      expect(active.single.startDay, DateTime(2026, 3, 1));

      // Texto nuevo → retira el anterior y crea otro con racha fresca.
      await repo.setPowerListText(1, 'Meditar', DateTime(2026, 3, 20));
      active = await repo.activePowerListItems();
      expect(active.single.text, 'Meditar');
      expect(active.single.startDay, DateTime(2026, 3, 20));
      expect(active.single.id, isNot(firstId));
    });

    test('activePowerListItems ordena por slot', () async {
      final when = DateTime(2026, 4, 1);
      await repo.setPowerListText(3, 'C', when);
      await repo.setPowerListText(1, 'A', when);
      await repo.setPowerListText(2, 'B', when);

      final active = await repo.activePowerListItems();
      expect(active.map((i) => i.slot).toList(), [1, 2, 3]);
      expect(active.map((i) => i.text).toList(), ['A', 'B', 'C']);
    });
  });
}
