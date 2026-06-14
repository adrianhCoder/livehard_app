import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'core/enums/program_phase.dart';
import 'features/onboarding/presentation/onboarding_flow.dart';
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
    final schedule = PhaseSchedule.tryFromState(program);
    final status = schedule?.entryFor(DateTime.now());

    // Estados sin checklist (antes de empezar, descanso o año completado).
    if (status == null || status.kind != TodayKind.active) {
      return _ScheduleStatusView(status: status);
    }

    final phase = status.phase!;
    final dayNumber = status.dayNumber!;
    final tasks = PhaseRules.tasksFor(phase);
    final recordAsync = ref.watch(todayRecordControllerProvider);
    final dateLabel =
        '${phase.label} · ${DateFormat('MMM d, yyyy').format(DateTime.now())}';
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

/// Vista para los días que no son de checklist: antes de empezar la Fase 1,
/// en un descanso entre fases, o cuando ya se completó el año.
class _ScheduleStatusView extends StatelessWidget {
  const _ScheduleStatusView({required this.status});

  final TodayStatus? status;

  @override
  Widget build(BuildContext context) {
    final (icon, title, subtitle) = _content();
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
