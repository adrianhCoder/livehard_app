import '../../../../core/enums/program_phase.dart';
import '../../../../core/utils/date_x.dart';

/// Registro de UN día del programa: el estado de cada tarea, la fecha,
/// las notas y la ruta local de la foto de progreso.
class DailyRecord {
  /// Clave del record en sembast (`null` hasta la primera persistencia).
  int? id;

  /// Fecha del día (normalizada a medianoche local). Única por día: el
  /// repositorio hace upsert por fecha para evitar dos registros del mismo día.
  late DateTime date;

  /// Fase a la que pertenece el día.
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
  bool get isComplete =>
      PhaseRules.tasksFor(phase).every(isDone);

  /// Progreso 0.0–1.0 para la barra de la UI.
  double get completionRatio {
    final tasks = PhaseRules.tasksFor(phase);
    if (tasks.isEmpty) return 0;
    final done = tasks.where(isDone).length;
    return done / tasks.length;
  }

  // -----------------------------------------------------------------
  // Serialización sembast. El `id` NO viaja en el map: la clave del record
  // es la fuente de verdad y `fromMap` la asigna al leer.
  // -----------------------------------------------------------------

  Map<String, Object?> toMap() => {
        'date': date.dayKey,
        'phase': phase.name,
        'dayNumber': dayNumber,
        'workout1': workout1,
        'workout2': workout2,
        'workoutOutside': workoutOutside,
        'waterGallon': waterGallon,
        'reading10Pages': reading10Pages,
        'strictDiet': strictDiet,
        'progressPhoto': progressPhoto,
        'coldShower': coldShower,
        'visualization': visualization,
        'powerListTask1': powerListTask1,
        'powerListTask2': powerListTask2,
        'powerListTask3': powerListTask3,
        'talkToStranger': talkToStranger,
        'actOfKindness': actOfKindness,
        'notes': notes,
        'imagePath': imagePath,
      };

  /// Defaults defensivos en los campos opcionales: permite añadir campos al
  /// esquema sin escribir migraciones (los maps viejos simplemente no los traen).
  static DailyRecord fromMap(int id, Map<String, Object?> map) => DailyRecord()
    ..id = id
    ..date = parseDayKey(map['date']! as String)
    ..phase = ProgramPhase.values.byName(map['phase']! as String)
    ..dayNumber = (map['dayNumber'] as num?)?.toInt() ?? 1
    ..workout1 = map['workout1'] as bool? ?? false
    ..workout2 = map['workout2'] as bool? ?? false
    ..workoutOutside = map['workoutOutside'] as bool? ?? false
    ..waterGallon = map['waterGallon'] as bool? ?? false
    ..reading10Pages = map['reading10Pages'] as bool? ?? false
    ..strictDiet = map['strictDiet'] as bool? ?? false
    ..progressPhoto = map['progressPhoto'] as bool? ?? false
    ..coldShower = map['coldShower'] as bool? ?? false
    ..visualization = map['visualization'] as bool? ?? false
    ..powerListTask1 = map['powerListTask1'] as bool? ?? false
    ..powerListTask2 = map['powerListTask2'] as bool? ?? false
    ..powerListTask3 = map['powerListTask3'] as bool? ?? false
    ..talkToStranger = map['talkToStranger'] as bool? ?? false
    ..actOfKindness = map['actOfKindness'] as bool? ?? false
    ..notes = map['notes'] as String? ?? ''
    ..imagePath = map['imagePath'] as String?;
}
