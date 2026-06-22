import '../../../../core/utils/date_x.dart';

/// Umbral de la regla de Andy Frisella: si haces la misma tarea crítica este
/// número de días seguidos, ya se volvió **hábito** y conviene reemplazarla.
const int kPowerListHabitDays = 21;

/// Calcula la racha (días consecutivos completados) de UNA tarea de la Power
/// List, de forma **pura y testeable**.
///
/// - [today] y [startDay] se asumen normalizados a día (`dayOnly`).
/// - [doneByDay] indica, por día, si la tarea se completó.
/// - La racha cuenta hacia atrás desde hoy. Si HOY aún no está hecha, no
///   rompe la racha: se cuenta desde ayer (el día sigue "en curso").
/// - Nunca cuenta días anteriores a [startDay] (cuando la tarea entró en vigor).
int powerListStreak({
  required DateTime today,
  required DateTime startDay,
  required Map<DateTime, bool> doneByDay,
}) {
  final start = startDay.dayOnly;
  // Si hoy ya está hecha, la racha incluye hoy; si no, empieza en ayer.
  var day = (doneByDay[today.dayOnly] ?? false)
      ? today.dayOnly
      : today.dayOnly.subtract(const Duration(days: 1));

  var streak = 0;
  while (!day.isBefore(start) && (doneByDay[day] ?? false)) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }
  return streak;
}

/// `true` si la racha alcanzó el umbral de hábito (~21 días) → sugerir reemplazo.
bool powerListIsHabit(int streak) => streak >= kPowerListHabitDays;
