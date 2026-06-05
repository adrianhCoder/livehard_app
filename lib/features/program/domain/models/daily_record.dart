import 'package:isar/isar.dart';

import '../../../../core/enums/program_phase.dart';

// Tras editar este archivo corre:  dart run build_runner build
part 'daily_record.g.dart';

/// Registro de UN día del programa: el estado de cada tarea, la fecha,
/// las notas y la ruta local de la foto de progreso.
@collection
class DailyRecord {
  Id id = Isar.autoIncrement;

  /// Fecha del día (normalizada a medianoche local). Indexada y única para
  /// permitir queries rápidas por rango y evitar dos registros del mismo día.
  @Index(unique: true, replace: true)
  late DateTime date;

  /// Fase a la que pertenece el día.
  @enumerated
  late ProgramPhase phase;

  /// Número de día dentro de la fase (1..durationDays).
  late int dayNumber;

  // ---- Estado de cada tarea (booleanos) ----
  bool workout1 = false;
  bool workout2 = false;
  bool workoutOutside = false;
  bool waterGallon = false;
  bool reading10Pages = false;
  bool strictDiet = false;
  bool progressPhoto = false;
  bool coldShower = false;
  bool visualization = false;
  bool powerListTask1 = false;
  bool powerListTask2 = false;
  bool powerListTask3 = false;
  bool talkToStranger = false;
  bool actOfKindness = false;

  /// Notas libres del día.
  String notes = '';

  /// Ruta local (en el sandbox de la app) de la foto de progreso.
  String? imagePath;

  // -----------------------------------------------------------------
  // Helpers — mapean el enum [DailyTask] a sus campos booleanos para que
  // la UI pueda leer/escribir tareas dinámicamente sin un switch gigante.
  // -----------------------------------------------------------------

  /// Lee el estado de una tarea concreta.
  bool isDone(DailyTask task) => switch (task) {
        DailyTask.workout1 => workout1,
        DailyTask.workout2 => workout2,
        DailyTask.workoutOutside => workoutOutside,
        DailyTask.waterGallon => waterGallon,
        DailyTask.reading10Pages => reading10Pages,
        DailyTask.strictDiet => strictDiet,
        DailyTask.progressPhoto => progressPhoto,
        DailyTask.coldShower => coldShower,
        DailyTask.visualization => visualization,
        DailyTask.powerListTask1 => powerListTask1,
        DailyTask.powerListTask2 => powerListTask2,
        DailyTask.powerListTask3 => powerListTask3,
        DailyTask.talkToStranger => talkToStranger,
        DailyTask.actOfKindness => actOfKindness,
      };

  /// Marca/desmarca una tarea concreta.
  void setDone(DailyTask task, bool value) {
    switch (task) {
      case DailyTask.workout1:
        workout1 = value;
      case DailyTask.workout2:
        workout2 = value;
      case DailyTask.workoutOutside:
        workoutOutside = value;
      case DailyTask.waterGallon:
        waterGallon = value;
      case DailyTask.reading10Pages:
        reading10Pages = value;
      case DailyTask.strictDiet:
        strictDiet = value;
      case DailyTask.progressPhoto:
        progressPhoto = value;
      case DailyTask.coldShower:
        coldShower = value;
      case DailyTask.visualization:
        visualization = value;
      case DailyTask.powerListTask1:
        powerListTask1 = value;
      case DailyTask.powerListTask2:
        powerListTask2 = value;
      case DailyTask.powerListTask3:
        powerListTask3 = value;
      case DailyTask.talkToStranger:
        talkToStranger = value;
      case DailyTask.actOfKindness:
        actOfKindness = value;
    }
  }

  /// `true` solo si TODAS las tareas exigidas por la fase están hechas.
  /// Esta es la regla que decide si la racha continúa o se reinicia.
  @ignore
  bool get isComplete =>
      PhaseRules.tasksFor(phase).every(isDone);

  /// Progreso 0.0–1.0 para la barra de la UI.
  @ignore
  double get completionRatio {
    final tasks = PhaseRules.tasksFor(phase);
    if (tasks.isEmpty) return 0;
    final done = tasks.where(isDone).length;
    return done / tasks.length;
  }
}
