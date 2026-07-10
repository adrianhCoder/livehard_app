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

  /// Clave de persistencia a nivel de día: `'yyyy-MM-dd'`. Su orden
  /// lexicográfico coincide con el cronológico (sirve para rangos en la base
  /// de datos) y, al truncar la hora, normaliza a día de facto al guardar.
  String get dayKey => '${year.toString().padLeft(4, '0')}-'
      '${month.toString().padLeft(2, '0')}-'
      '${day.toString().padLeft(2, '0')}';
}

/// Inversa de [DateX.dayKey]: reconstruye la fecha (medianoche local).
DateTime parseDayKey(String key) => DateTime.parse(key);

/// Como [parseDayKey] pero tolera `null` (campos de fecha opcionales).
DateTime? parseDayKeyOrNull(String? key) =>
    key == null ? null : DateTime.parse(key);
