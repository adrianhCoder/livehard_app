import 'package:flutter_test/flutter_test.dart';
import 'package:livehard_app/core/utils/date_x.dart';
import 'package:livehard_app/features/program/domain/models/power_list_logic.dart';

void main() {
  // Día de referencia para todos los tests.
  final today = DateTime(2026, 6, 21);
  DateTime day(int offsetFromToday) =>
      today.add(Duration(days: offsetFromToday)).dayOnly;

  /// Construye el mapa "día -> hecho" para los offsets indicados (0 = hoy,
  /// -1 = ayer, ...). Todos esos días quedan en `true`; el resto, ausentes.
  Map<DateTime, bool> done(List<int> offsets) =>
      {for (final o in offsets) day(o): true};

  group('powerListStreak', () {
    test('cuenta días consecutivos terminando HOY cuando hoy está hecho', () {
      final streak = powerListStreak(
        today: today,
        startDay: day(-10),
        doneByDay: done([0, -1, -2]),
      );
      expect(streak, 3);
    });

    test('si HOY no está hecho, la racha cuenta hasta ayer (día en curso)', () {
      final streak = powerListStreak(
        today: today,
        startDay: day(-10),
        doneByDay: done([-1, -2, -3]), // hoy ausente
      );
      expect(streak, 3);
    });

    test('un hueco rompe la racha', () {
      final streak = powerListStreak(
        today: today,
        startDay: day(-10),
        doneByDay: done([0, -1, -3, -4]), // falta el día -2
      );
      expect(streak, 2);
    });

    test('nunca cuenta días anteriores al startDay (tarea recién creada)', () {
      // Aunque haya historial previo, la tarea arrancó hace 2 días.
      final streak = powerListStreak(
        today: today,
        startDay: day(-2),
        doneByDay: done([0, -1, -2, -3, -4, -5]),
      );
      expect(streak, 3); // hoy, -1, -2 (no cuenta -3 en adelante)
    });

    test('sin días hechos => racha 0', () {
      final streak = powerListStreak(
        today: today,
        startDay: day(-10),
        doneByDay: const {},
      );
      expect(streak, 0);
    });
  });

  group('powerListIsHabit', () {
    test('es hábito al alcanzar 21 días', () {
      expect(powerListIsHabit(20), isFalse);
      expect(powerListIsHabit(21), isTrue);
      expect(powerListIsHabit(30), isTrue);
    });
  });
}
