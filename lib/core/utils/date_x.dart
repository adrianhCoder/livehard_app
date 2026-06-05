/// Utilidades de fecha "a nivel de día" — ignoran la hora y la zona horaria
/// para que las comparaciones de rachas/calendario sean deterministas.
extension DateX on DateTime {
  /// Devuelve la fecha a medianoche local (00:00:00). Úsalo SIEMPRE antes de
  /// guardar o comparar fechas de días.
  DateTime get dayOnly => DateTime(year, month, day);

  /// Diferencia en días completos (calendario) entre this y [other],
  /// inmune a horas y a cambios de horario de verano.
  int daysUntil(DateTime other) =>
      other.dayOnly.difference(dayOnly).inDays;

  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  /// Aniversario (+N años) preservando el día. Maneja 29-feb degradando a 28.
  DateTime addYears(int years) {
    final m = month;
    final d = day;
    // Si el día no existe en el año destino (29-feb), cae al último día válido.
    final lastDay = DateTime(year + years, m + 1, 0).day;
    return DateTime(year + years, m, d > lastDay ? lastDay : d);
  }
}
