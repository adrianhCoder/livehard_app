import '../../../core/enums/program_phase.dart';
import '../data/program_repository.dart';
import '../domain/models/attempt_summary.dart';
import '../domain/models/program_state.dart';
import 'program_date_logic.dart';

/// Perfil del usuario (MOCK). Más adelante saldrá de auth / almacenamiento
/// local. Centralizado aquí para que la UI de progreso y la de ajustes lean
/// la misma fuente mientras no haya backend.
class UserProfile {
  const UserProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.dayEndTime,
    required this.lastSync,
    this.avatarAsset,
    this.oneHourLeftNotification = true,
    this.savePicsToPhone = true,
    this.theme = 'Light',
  });

  final String firstName;
  final String lastName;
  final String email;

  /// Hora a la que "termina" el día del programa (ej. "12:05 am").
  final String dayEndTime;

  /// Última sincronización (para la fila "Sync Now").
  final DateTime lastSync;

  /// Asset del avatar (mock: `null` → se usa un placeholder).
  final String? avatarAsset;

  final bool oneHourLeftNotification;
  final bool savePicsToPhone;
  final String theme;

  String get fullName => '$firstName $lastName';
}

/// Perfil de ejemplo mostrado mientras usamos mock data.
final UserProfile mockProfile = UserProfile(
  firstName: 'Adrianh',
  lastName: 'De Lucio',
  email: 'raullader877@gmail.com',
  dayEndTime: '12:05 am',
  lastSync: DateTime(2026, 6, 7, 22, 2),
);

/// Intentos de ejemplo. El más reciente (activo) va primero.
///
/// Nota: el modelo es genérico por fase, así que la cuadrícula del calendario
/// se adapta sola — un intento de [ProgramPhase.phase1] mostrará 30 días en
/// lugar de 75.
final List<AttemptSummary> mockAttempts = <AttemptSummary>[
  AttemptSummary(
    phase: ProgramPhase.hard75,
    startDate: DateTime(2026, 4, 27),
    completedDays: 42,
    isCurrent: true,
  ),
  AttemptSummary(
    phase: ProgramPhase.hard75,
    startDate: DateTime(2026, 3, 30),
    completedDays: 9,
  ),
  AttemptSummary(
    phase: ProgramPhase.hard75,
    startDate: DateTime(2026, 3, 1),
    completedDays: 5,
  ),
  // Ejemplo de otra fase para demostrar que el calendario se adapta (30 días).
  AttemptSummary(
    phase: ProgramPhase.phase1,
    startDate: DateTime(2026, 1, 15),
    completedDays: 12,
  ),
];

/// Siembra en Isar un programa de ejemplo (modo demo): 75 Hard terminado hace
/// poco, Fase 1 en una semana, Fase 2 en su fecha más temprana y Fase 3 fija.
/// Permite ver la app poblada sin pasar por el onboarding.
Future<void> seedSampleProgram(ProgramRepository repo, {DateTime? now}) async {
  const logic = ProgramDateLogic();
  final today = (now ?? DateTime.now());
  final hard75Day1 =
      DateTime(today.year, today.month, today.day).subtract(const Duration(days: 80));
  final phase1Start = logic.defaultPhase1StartFor(hard75Day1, now: today);
  final phase2Start = logic.earliestPhase2StartFrom(phase1Start);

  final state = ProgramState()
    ..programStartDate = hard75Day1
    ..phase1StartDate = phase1Start
    ..phase2StartDate = phase2Start
    ..currentPhase = ProgramPhase.phase1
    ..currentPhaseStartDate = phase1Start
    ..onboardingComplete = true;
  await repo.saveState(state);
}
