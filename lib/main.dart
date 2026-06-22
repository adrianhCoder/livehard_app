import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'core/enums/program_phase.dart';
import 'core/utils/date_x.dart';
import 'features/onboarding/presentation/onboarding_flow.dart';
import 'features/program/application/dev_clock.dart';
import 'features/program/application/program_controller.dart';
import 'features/program/application/program_date_logic.dart';
import 'features/program/application/power_list_controller.dart';
import 'features/program/application/program_providers.dart';
import 'features/program/application/streak_failure_provider.dart';
import 'features/program/application/today_record_controller.dart';
import 'features/program/domain/models/phase_schedule.dart';
import 'features/program/domain/models/program_state.dart';
import 'features/program/presentation/calendar_screen.dart';
import 'features/program/presentation/failure_screen.dart';

Future<void> main() async {
  // Necesario antes de usar plugins (path_provider, Isar) en `main`.
  WidgetsFlutterBinding.ensureInitialized();

  // Abre la base de datos Isar una sola vez y la inyecta en Riverpod.
  final isar = await openIsar();

  runApp(
    ProviderScope(
      overrides: [isarProvider.overrideWithValue(isar)],
      child: const LiveHardApp(),
    ),
  );
}

class LiveHardApp extends StatelessWidget {
  const LiveHardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LiveHard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

/// Etiqueta de cada tarea con el texto exacto de la app de referencia (75 Hard).
String _taskLabel(DailyTask task) => switch (task) {
      DailyTask.workout1 => '45 Minute Workout',
      DailyTask.workout2 => '45 Minute Outdoor Workout',
      DailyTask.workoutOutside => 'One Workout Outdoors',
      DailyTask.waterGallon => 'Drink 1 Gallon of Water',
      DailyTask.reading10Pages => '10 Pages of Reading',
      DailyTask.strictDiet => 'Follow a Diet',
      DailyTask.progressPhoto => 'Take Progress Picture',
      DailyTask.coldShower => 'Cold Shower (5 min)',
      DailyTask.visualization => 'Visualization (10 min)',
      DailyTask.powerListTask1 => 'Power List · Task 1',
      DailyTask.powerListTask2 => 'Power List · Task 2',
      DailyTask.powerListTask3 => 'Power List · Task 3',
      DailyTask.talkToStranger => 'Talk to a Stranger',
      DailyTask.actOfKindness => 'Act of Kindness',
    };

/// Pantalla principal: muestra el estado del programa y, si está iniciado,
/// la checklist de tareas de HOY con el estilo de la app 75 Hard.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programAsync = ref.watch(programStateProvider);

    return Scaffold(
      bottomNavigationBar: kDebugMode ? const _DevClockBar() : null,
      body: SafeArea(
        child: programAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (program) {
            if (program == null || !program.onboardingComplete) {
              return const OnboardingFlow();
            }
            // Antes de la checklist, comprueba si la racha está rota: un día
            // pasado sin completar bloquea HOY con la pantalla "HAS FALLADO".
            final failureAsync = ref.watch(streakFailureProvider);
            return failureAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, __) => _TodayView(program: program),
              data: (failure) => failure != null
                  ? FailureScreen(failure: failure)
                  : _TodayView(program: program),
            );
          },
        ),
      ),
    );
  }
}

/// Vista del día actual con el estilo de 75 Hard.
class _TodayView extends ConsumerWidget {
  const _TodayView({required this.program});

  final ProgramState program;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(simulatedNowProvider);
    final schedule = PhaseSchedule.tryFromState(program);
    final status = schedule?.entryFor(now);

    // Estados sin checklist (antes de empezar, descanso o año completado).
    if (status == null || status.kind != TodayKind.active) {
      return _ScheduleStatusView(status: status, program: program);
    }

    final phase = status.phase!;
    final dayNumber = status.dayNumber!;
    // La Power List se renderiza en su propia sección (texto del usuario +
    // racha), así que la sacamos del listado genérico de tareas.
    final tasks = PhaseRules.tasksFor(phase)
        .where((t) => !PhaseRules.powerListSlots.contains(t))
        .toList();
    final recordAsync = ref.watch(todayRecordControllerProvider);
    final dateLabel =
        '${phase.label} · ${DateFormat('MMM d, yyyy').format(now)}';
    final controller = ref.read(todayRecordControllerProvider.notifier);

    return recordAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (record) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            // ---- Encabezado: logo, DAY N, fecha, calendario ----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const _SpadeLogo(size: 52),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'DAY $dayNumber',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateLabel,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_month_outlined,
                        size: 36, color: Colors.grey.shade800),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const CalendarScreen()),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // ---- Lista de tareas ----
            for (final task in tasks) ...[
              _TaskRow(
                label: _taskLabel(task),
                done: record?.isDone(task) ?? false,
                showCamera: task == DailyTask.progressPhoto,
                onToggle: () => controller.toggleTask(task),
                onPickPhoto: task == DailyTask.progressPhoto
                    ? () => _pickProgressPhoto(context, controller)
                    : null,
              ),
              const Divider(height: 1),
            ],

            // ---- Sección POWER LIST (solo Fases 1 y 3) ----
            if (PhaseRules.usesPowerList(phase)) const _PowerListSection(),

            // ---- Sección NOTES ----
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NOTES:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  const Divider(thickness: 1.5, color: Colors.black87),
                  _NotesField(
                    key: const ValueKey('today-notes'),
                    initial: record?.notes ?? '',
                    onSave: controller.setNotes,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickProgressPhoto(
      BuildContext context, TodayRecordController controller) async {
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        await controller.setProgressPhoto(file.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir la imagen: $e')),
        );
      }
    }
  }
}

/// Una fila de tarea al estilo 75 Hard: círculo rojo de check + título tachado.
class _TaskRow extends StatelessWidget {
  const _TaskRow({
    required this.label,
    required this.done,
    required this.onToggle,
    this.showCamera = false,
    this.onPickPhoto,
  });

  final String label;
  final bool done;
  final VoidCallback onToggle;
  final bool showCamera;
  final VoidCallback? onPickPhoto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Círculo de check.
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? Colors.red : Colors.transparent,
                border: Border.all(
                  color: done ? Colors.red : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: done
                  ? const Icon(Icons.check, color: Colors.white, size: 28)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          // Título + subtítulo.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: done ? Colors.grey.shade500 : Colors.black87,
                    decoration: done ? TextDecoration.lineThrough : null,
                    decorationColor: Colors.grey.shade500,
                    decorationThickness: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.add_alarm,
                        size: 18, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(
                      'Add Reminder',
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Botón de cámara (solo en "Take Progress Picture").
          if (showCamera)
            GestureDetector(
              onTap: onPickPhoto,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade700,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.add_a_photo,
                    color: Colors.white, size: 22),
              ),
            ),
        ],
      ),
    );
  }
}

/// Sección "POWER LIST": tareas críticas que el usuario define y **mantiene
/// día a día** hasta reemplazarlas. Muestra la racha por tarea y, a los ~21
/// días, sugiere reemplazarla (ya es hábito). 3 obligatorias + hasta 2
/// opcionales.
class _PowerListSection extends ConsumerWidget {
  const _PowerListSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewAsync = ref.watch(powerListControllerProvider);
    final pl = ref.read(powerListControllerProvider.notifier);
    final today = ref.read(todayRecordControllerProvider.notifier);

    return viewAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: Text('Error Power List: $e'),
      ),
      data: (slots) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                const Text('POWER LIST',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(width: 8),
                Text('· ${PhaseRules.powerListCount} tareas críticas',
                    style:
                        TextStyle(fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
          ),
          const Divider(
              thickness: 1.5,
              color: Colors.black87,
              indent: 16,
              endIndent: 16),
          for (final slot in slots) ...[
            _PowerListRow(
              view: slot,
              onToggle: slot.isDefined
                  ? () => today.toggleTask(slot.task)
                  : () => _editDialog(context, pl, slot.slot, null),
              onEdit: () => _editDialog(context, pl, slot.slot, slot.text),
            ),
            const Divider(height: 1),
          ],
        ],
      ),
    );
  }

  Future<void> _editDialog(BuildContext context, PowerListController pl,
      int slot, String? initial) async {
    final text = await _promptPowerListText(context, initial);
    if (text == null || text.trim().isEmpty) return;
    await pl.setText(slot, text);
  }
}

/// Pide al usuario el texto de una tarea crítica. Devuelve `null` si cancela.
Future<String?> _promptPowerListText(BuildContext context, String? initial) {
  final controller = TextEditingController(text: initial ?? '');
  final title =
      initial == null ? 'Define tu tarea crítica' : 'Editar / reemplazar';
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'p. ej. Escribir 500 palabras de mi libro',
            ),
            onSubmitted: (v) => Navigator.of(ctx).pop(v),
          ),
          if (initial != null) ...[
            const SizedBox(height: 10),
            Text(
              'Cambiar el texto cuenta como una tarea nueva: la racha se '
              'reinicia.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.of(ctx).pop(controller.text),
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}

/// Una fila de la Power List: check + texto del usuario + racha 🔥 + acciones.
class _PowerListRow extends StatelessWidget {
  const _PowerListRow({
    required this.view,
    required this.onToggle,
    required this.onEdit,
  });

  final PowerListSlotView view;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final defined = view.isDefined;
    final done = view.doneToday;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Círculo de check (o "+" si la ranura está vacía).
          GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: done ? Colors.red : Colors.transparent,
                border: Border.all(
                  color: done
                      ? Colors.red
                      : (defined ? Colors.grey.shade400 : Colors.grey.shade300),
                  width: 2,
                ),
              ),
              child: done
                  ? const Icon(Icons.check, color: Colors.white, size: 24)
                  : (defined
                      ? null
                      : Icon(Icons.add, color: Colors.grey.shade400, size: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  defined ? view.text! : 'Define tu tarea crítica ${view.slot}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    fontStyle: defined ? FontStyle.normal : FontStyle.italic,
                    color: !defined
                        ? Colors.grey.shade500
                        : (done ? Colors.grey.shade500 : Colors.black87),
                    decoration: done ? TextDecoration.lineThrough : null,
                    decorationColor: Colors.grey.shade500,
                    decorationThickness: 2,
                  ),
                ),
                if (defined) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department,
                          size: 16,
                          color: view.streak > 0
                              ? Colors.deepOrange
                              : Colors.grey.shade400),
                      const SizedBox(width: 4),
                      Text(
                        '${view.streak} día${view.streak == 1 ? '' : 's'} seguidos',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  if (view.isHabit)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Text(
                          '✔ Ya es hábito · toca ✎ para reemplazarla',
                          style: TextStyle(
                              fontSize: 12, color: Colors.green.shade800),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
          if (defined)
            IconButton(
              icon: Icon(Icons.edit, size: 20, color: Colors.grey.shade600),
              onPressed: onEdit,
              tooltip: 'Editar / reemplazar',
            ),
        ],
      ),
    );
  }
}

/// Vista para los días que no son de checklist: antes de empezar la Fase 1,
/// en un descanso entre fases, o cuando ya se completó el año. En los descansos
/// ofrece iniciar la próxima fase ahora o ajustar su fecha (salvo la Fase 3,
/// que es estática).
class _ScheduleStatusView extends ConsumerWidget {
  const _ScheduleStatusView({required this.status, required this.program});

  final TodayStatus? status;
  final ProgramState program;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (icon, title, subtitle) = _content();
    final s = status;
    final nextPhase = s?.nextPhase;
    final showActions = s != null &&
        (s.kind == TodayKind.beforeStart || s.kind == TodayKind.waiting) &&
        nextPhase != null;
    final opts = showActions
        ? ref.read(programDateLogicProvider).optionsForNextPhase(
              program,
              nextPhase,
              now: ref.watch(simulatedNowProvider),
            )
        : null;

    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.calendar_month_outlined,
                size: 32, color: Colors.grey.shade800),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CalendarScreen()),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 72, color: Colors.red),
                const SizedBox(height: 20),
                Text(title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade700)),
                if (opts != null) ...[
                  const SizedBox(height: 28),
                  SizedBox(width: 320, child: _PhaseStartActions(options: opts)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  (IconData, String, String) _content() {
    final s = status;
    if (s == null) return (Icons.error_outline, 'Sin programa', 'Configura tus fases.');
    switch (s.kind) {
      case TodayKind.beforeStart:
        return (
          Icons.hourglass_top,
          'Tu ${s.nextPhase!.label} empieza en ${s.daysUntilNext} día(s)',
          'Prepárate. La cuenta regresiva ya corre.'
        );
      case TodayKind.waiting:
        return (
          Icons.self_improvement,
          'Descanso',
          '${s.nextPhase!.label} empieza en ${s.daysUntilNext} día(s).'
        );
      case TodayKind.done:
        return (
          Icons.emoji_events,
          '¡Completaste el año Live Hard!',
          'Terminaste las 4 fases. 🔥'
        );
      case TodayKind.active:
        return (Icons.check, 'En curso', '');
    }
  }
}

/// Botones de la pantalla de descanso: "Iniciar ahora" (si HOY es válido) y
/// "Ajustar fecha de inicio". Para la Fase 3 (estática) solo muestra la nota
/// de que su fecha es fija.
class _PhaseStartActions extends ConsumerWidget {
  const _PhaseStartActions({required this.options});

  final PhaseStartOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final o = options;

    if (!o.adjustable) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              o.note ?? 'Fecha fija.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (o.note != null) ...[
          Text(
            o.note!,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),
        ],
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: o.canStartToday ? () => _apply(context, ref, _today(ref)) : null,
          icon: const Icon(Icons.play_arrow),
          label: Text('Iniciar ${o.phase.label} ahora'),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: () => _adjust(context, ref),
          icon: const Icon(Icons.edit_calendar),
          label: const Text('Ajustar fecha de inicio'),
        ),
      ],
    );
  }

  DateTime _today(WidgetRef ref) => ref.read(simulatedNowProvider).dayOnly;

  Future<void> _adjust(BuildContext context, WidgetRef ref) async {
    final today = _today(ref);
    final earliest = options.earliest ?? today;
    final latest = options.latest ?? earliest.add(const Duration(days: 365));
    final initial = today.isBefore(earliest)
        ? earliest
        : (today.isAfter(latest) ? latest : today);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: earliest,
      lastDate: latest,
    );
    if (picked != null && context.mounted) {
      await _apply(context, ref, picked);
    }
  }

  Future<void> _apply(BuildContext context, WidgetRef ref, DateTime date) async {
    try {
      await ref
          .read(programControllerProvider.notifier)
          .setPhaseStart(phase: options.phase, date: date);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              '${options.phase.label} programada para ${DateFormat('MMM d, yyyy').format(date)}.'),
        ));
      }
    } on ScheduleException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.problems.join('\n'))));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No se pudo programar: $e')));
      }
    }
  }
}

/// Barra de desarrollo (solo en debug): "viaja en el tiempo" sumando días al
/// reloj simulado para probar el avance de fases y la detección de racha rota
/// sin esperar días reales. Ver [DevClock] / [simulatedNowProvider].
class _DevClockBar extends ConsumerWidget {
  const _DevClockBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = ref.watch(simulatedNowProvider);
    final offset = ref.watch(devClockProvider);
    final clock = ref.read(devClockProvider.notifier);

    return Material(
      color: Colors.amber.shade200,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'DEV · ${DateFormat('EEE MMM d').format(now)}'
                  '  (${offset >= 0 ? '+' : ''}$offset d)',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              _DevButton(label: '−1d', onTap: () => clock.advance(-1)),
              _DevButton(label: '+1d', onTap: () => clock.advance(1)),
              _DevButton(label: '+10d', onTap: () => clock.advance(10)),
              _DevButton(label: 'Reset', onTap: clock.reset),
              _DevButton(
                label: 'Wipe',
                color: Colors.red.shade700,
                onTap: () => _wipe(context, ref, clock),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Borra todos los datos (estado + registros) tras confirmar, y reinicia el
  /// reloj. La app vuelve al onboarding para empezar una prueba desde cero.
  Future<void> _wipe(
      BuildContext context, WidgetRef ref, DevClock clock) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Borrar todos los datos'),
        content: const Text(
            'Solo para pruebas: elimina el programa y todos los registros. '
            'Volverás al onboarding. ¿Continuar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Borrar todo'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(programControllerProvider.notifier).wipeEverythingForDev();
      clock.reset();
    }
  }
}

class _DevButton extends StatelessWidget {
  const _DevButton({required this.label, required this.onTap, this.color});

  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color ?? Colors.black87,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ),
    );
  }
}

/// Logo de pica (♠) con "75" dentro y "HARD" debajo.
class _SpadeLogo extends StatelessWidget {
  const _SpadeLogo({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(CupertinoIcons.suit_spade_fill,
                size: size, color: Colors.black),
            Positioned(
              top: size * 0.18,
              child: Text(
                '75',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: size * 0.3,
                ),
              ),
            ),
          ],
        ),
        Text(
          'HARD',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: size * 0.24,
            letterSpacing: 1,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

/// Campo de notas con estado propio para no perder el cursor en cada guardado.
class _NotesField extends StatefulWidget {
  const _NotesField({super.key, required this.initial, required this.onSave});

  final String initial;
  final ValueChanged<String> onSave;

  @override
  State<_NotesField> createState() => _NotesFieldState();
}

class _NotesFieldState extends State<_NotesField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: null,
      minLines: 4,
      onChanged: widget.onSave,
      style: const TextStyle(fontSize: 16),
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: 'Escribe tus notas del día…',
      ),
    );
  }
}
