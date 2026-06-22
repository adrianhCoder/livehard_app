import 'package:isar/isar.dart';

// Tras editar este archivo corre:  dart run build_runner build
part 'power_list_item.g.dart';

/// Una tarea crítica de la **Power List** definida por el usuario.
///
/// La Power List de Andy Frisella son tareas críticas alineadas a tus metas
/// que **repites cada día**: eliges una y se mantiene hasta que decides
/// reemplazarla (típicamente cuando ya se volvió hábito, ~21 días). Para
/// preservar el historial, "editar" una tarea NO muta este registro: se
/// **retira** el actual ([active] = false, [retiredDay]) y se crea uno nuevo
/// con un [startDay] fresco, de modo que la racha por tarea arranca de cero.
@collection
class PowerListItem {
  Id id = Isar.autoIncrement;

  /// Posición en la lista (1..5). Las 3 primeras son obligatorias en las
  /// fases que usan Power List; las 2 últimas son opcionales.
  @Index()
  late int slot;

  /// El texto de la tarea crítica, tal como lo escribió el usuario.
  late String text;

  /// Día (normalizado) en que esta tarea entró en vigor. La racha se cuenta
  /// desde aquí: al reemplazar la tarea, este valor se reinicia.
  late DateTime startDay;

  /// `true` mientras la tarea está vigente. Solo puede haber UN ítem activo
  /// por [slot]; los retirados se conservan como historial.
  @Index()
  bool active = true;

  /// Día en que se retiró (null mientras siga activa).
  DateTime? retiredDay;
}
