/// Las 4 fases del programa Live Hard.
///
/// Se persiste el **nombre** del valor (`phase.name`, ver `toMap` de los
/// modelos), así que reordenar es seguro pero **nunca renombres ni borres
/// valores** una vez en producción (`values.byName` lanzaría al leer datos viejos).
enum ProgramPhase {
  hard75,
  phase1,
  phase2,
  phase3;

  /// Duración en días de cada fase.
  int get durationDays => switch (this) {
        ProgramPhase.hard75 => 75,
        ProgramPhase.phase1 => 30,
        ProgramPhase.phase2 => 30,
        ProgramPhase.phase3 => 30,
      };

  String get label => switch (this) {
        ProgramPhase.hard75 => '75 Hard',
        ProgramPhase.phase1 => 'Fase 1',
        ProgramPhase.phase2 => 'Fase 2',
        ProgramPhase.phase3 => 'Fase 3',
      };

  /// La fase siguiente en la progresión, o `null` si es la última.
  ProgramPhase? get next => switch (this) {
        ProgramPhase.hard75 => ProgramPhase.phase1,
        ProgramPhase.phase1 => ProgramPhase.phase2,
        ProgramPhase.phase2 => ProgramPhase.phase3,
        ProgramPhase.phase3 => null,
      };
}

/// Identidad de cada tarea diaria. Centraliza qué tareas aplican por fase
/// (ver [PhaseRules]) y permite renderizar la checklist dinámicamente.
enum DailyTask {
  workout1, // entrenamiento 1
  workout2, // entrenamiento 2 (uno de los dos debe ser al aire libre)
  workoutOutside, // confirma que al menos un entrenamiento fue afuera
  waterGallon, // 1 galón de agua
  reading10Pages, // 10 páginas de lectura (no ficción)
  strictDiet, // dieta estricta, sin alcohol ni cheat meals
  progressPhoto, // foto de progreso diaria
  coldShower, // ducha fría 5 min        (Fase 1 y 3)
  visualization, // visualización 10 min  (solo Fase 1)
  powerListTask1, // 3 tareas del Power List (Fase 1 y 3)
  powerListTask2,
  powerListTask3,
  talkToStranger, // hablar con un extraño (solo Fase 3)
  actOfKindness; // 1 acto de bondad      (solo Fase 3)

  String get label => switch (this) {
        DailyTask.workout1 => 'Entrenamiento 1',
        DailyTask.workout2 => 'Entrenamiento 2',
        DailyTask.workoutOutside => 'Un entrenamiento fue al aire libre',
        DailyTask.waterGallon => '1 galón de agua',
        DailyTask.reading10Pages => '10 páginas de lectura',
        DailyTask.strictDiet => 'Dieta estricta (sin alcohol / cheat meals)',
        DailyTask.progressPhoto => 'Foto de progreso',
        DailyTask.coldShower => 'Ducha fría (5 min)',
        DailyTask.visualization => 'Visualización (10 min)',
        DailyTask.powerListTask1 => 'Power List · Tarea 1',
        DailyTask.powerListTask2 => 'Power List · Tarea 2',
        DailyTask.powerListTask3 => 'Power List · Tarea 3',
        DailyTask.talkToStranger => 'Hablar con un extraño',
        DailyTask.actOfKindness => 'Un acto de bondad',
      };
}

/// Define qué tareas exige cada fase (single source of truth de las reglas).
class PhaseRules {
  const PhaseRules._();

  /// Las 3 ranuras de la Power List, en orden de slot (1..3). Todas son
  /// obligatorias en las fases que usan Power List (Fase 1 y 3).
  static const List<DailyTask> powerListSlots = [
    DailyTask.powerListTask1,
    DailyTask.powerListTask2,
    DailyTask.powerListTask3,
  ];

  /// Cuántas tareas de la Power List hay (todas obligatorias).
  static const int powerListCount = 3;

  /// Mapea un número de slot (1..3) a su [DailyTask] correspondiente.
  static DailyTask powerListTaskForSlot(int slot) => powerListSlots[slot - 1];

  /// `true` si la fase usa la Power List (Fase 1 y Fase 3).
  static bool usesPowerList(ProgramPhase phase) =>
      tasksFor(phase).contains(DailyTask.powerListTask1);

  // Reglas base de 75 Hard, compartidas por todas las fases.
  static const List<DailyTask> _base = [
    DailyTask.workout1,
    DailyTask.workout2,
    DailyTask.workoutOutside,
    DailyTask.waterGallon,
    DailyTask.reading10Pages,
    DailyTask.strictDiet,
    DailyTask.progressPhoto,
  ];

  /// Tareas requeridas para que un día cuente como completado en [phase].
  static List<DailyTask> tasksFor(ProgramPhase phase) => switch (phase) {
        // 75 Hard y Fase 2 comparten exactamente las mismas reglas.
        ProgramPhase.hard75 || ProgramPhase.phase2 => _base,

        // Fase 1 = base + ducha fría + visualización + Power List (3).
        ProgramPhase.phase1 => [
            ..._base,
            DailyTask.coldShower,
            DailyTask.visualization,
            DailyTask.powerListTask1,
            DailyTask.powerListTask2,
            DailyTask.powerListTask3,
          ],

        // Fase 3 = base + Fase 1 SIN visualización + extraño + acto de bondad.
        ProgramPhase.phase3 => [
            ..._base,
            DailyTask.coldShower,
            DailyTask.powerListTask1,
            DailyTask.powerListTask2,
            DailyTask.powerListTask3,
            DailyTask.talkToStranger,
            DailyTask.actOfKindness,
          ],
      };
}
