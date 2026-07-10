import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/program_phase.dart';
import '../../../core/utils/date_x.dart';
import '../../profile/presentation/profile_screen.dart';
import '../application/dev_clock.dart';
import '../application/mock_data.dart';
import '../application/phase_overview_provider.dart';
import '../application/program_controller.dart';
import '../application/program_providers.dart';
import '../application/streak_failure_provider.dart';
import '../domain/models/daily_record.dart';
import '../domain/models/phase_progress.dart';
import 'phase_schedule_screen.dart';

/// Pantalla de progreso: tarjetas por fase (75 Hard + Fases 1-3) y el
/// calendario de la fase seleccionada, todo con datos reales de la base de datos.
///
/// Los días totalmente completados se pintan en rojo; los parciales en ámbar;
/// el día de hoy lleva borde. Tocar un día abre el detalle de su registro.
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  /// Índice de la fase seleccionada; `null` = aún sin elegir (usa la activa).
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(phaseOverviewProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (phases) {
            if (phases.isEmpty) {
              return Column(
                children: [
                  _Header(onSettings: _openSettings),
                  const Expanded(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Aún no has programado tus fases.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            final defaultIdx = phases.indexWhere((p) => p.isCurrent);
            final idx = (_selected ?? (defaultIdx < 0 ? 0 : defaultIdx))
                .clamp(0, phases.length - 1);
            final current = phases[idx];

            return Column(
              children: [
                _Header(onSettings: _openSettings),
                _ProfileRow(profile: mockProfile),
                const SizedBox(height: 12),
                SizedBox(
                  height: 168,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: phases.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, i) => _PhaseCard(
                      progress: phases[i],
                      selected: i == idx,
                      onTap: () => setState(() => _selected = i),
                      onEdit: phases[i].isCurrent ? _reschedule : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _CalendarGrid(
                    progress: current,
                    today: ref.watch(simulatedNowProvider).dayOnly,
                    onDayTap: (day) => _showDayDetail(current, day),
                  ),
                ),
                _FaqFooter(phaseLabel: current.phase.label),
              ],
            );
          },
        ),
      ),
    );
  }

  void _openSettings() => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
      );

  Future<void> _reschedule() async {
    final program = ref.read(programStateProvider).valueOrNull;
    if (program == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhaseScheduleScreen(
          hard75Day1: program.programStartDate,
          initialPhase1Start: program.phase1StartDate,
          initialPhase2Start: program.phase2StartDate,
          title: 'Reprogramar fases',
          confirmLabel: 'Guardar',
          onConfirm: (p1, p2) async {
            await ref
                .read(programControllerProvider.notifier)
                .completeOnboarding(
                  hard75Day1: program.programStartDate,
                  phase1Start: p1,
                  phase2Start: p2,
                );
            ref.invalidate(phaseOverviewProvider);
            if (mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  void _showDayDetail(PhaseProgress p, int day) {
    final date = p.startDate.add(Duration(days: day - 1));
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => _DayDetailSheet(phase: p.phase, day: day, date: date),
    );
  }
}

/// Hoja de detalle de un día. Los días de HOY o anteriores son EDITABLES (sirve
/// para "marcar los días anteriores" tras una racha rota); los futuros son de
/// solo lectura. Cada cambio se persiste y refresca el aviso de racha rota.
class _DayDetailSheet extends ConsumerStatefulWidget {
  const _DayDetailSheet(
      {required this.phase, required this.day, required this.date});

  final ProgramPhase phase;
  final int day;
  final DateTime date;

  @override
  ConsumerState<_DayDetailSheet> createState() => _DayDetailSheetState();
}

class _DayDetailSheetState extends ConsumerState<_DayDetailSheet> {
  /// Stream del registro de este día, cacheado en el State: recrearlo en cada
  /// build reiniciaría la suscripción (ConnectionState.waiting) y parpadearía.
  late final Stream<DailyRecord?> _recordStream;

  @override
  void initState() {
    super.initState();
    _recordStream =
        ref.read(programRepositoryProvider).watchRecordForDate(widget.date);
  }

  /// Lee (o crea en memoria) el registro de este día, SIEMPRE desde la base
  /// de datos para no pisar cambios concurrentes.
  Future<DailyRecord> _recordForDay() async =>
      await ref.read(programRepositoryProvider).getRecordForDate(widget.date) ??
      (DailyRecord()
        ..date = widget.date
        ..phase = widget.phase
        ..dayNumber = widget.day);

  Future<void> _persist(DailyRecord record) async {
    await ref.read(programRepositoryProvider).saveRecord(record);
    // Refresca el calendario y la detección de racha rota; la propia sheet se
    // repinta sola vía [_recordStream].
    ref.invalidate(phaseOverviewProvider);
    ref.invalidate(streakFailureProvider);
  }

  Future<void> _toggle(DailyTask task) async {
    final record = await _recordForDay();
    record.setDone(task, !record.isDone(task));
    await _persist(record);
  }

  /// Marca o desmarca TODAS las tareas de la fase para este día de una vez.
  /// Es el "completar día" del backfill: deja el día como completo (o vacío).
  Future<void> _setAll(bool done) async {
    final record = await _recordForDay();
    for (final t in PhaseRules.tasksFor(widget.phase)) {
      record.setDone(t, done);
    }
    await _persist(record);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = PhaseRules.tasksFor(widget.phase);
    final editable =
        !widget.date.dayOnly.isAfter(ref.watch(simulatedNowProvider).dayOnly);

    return StreamBuilder<DailyRecord?>(
      stream: _recordStream,
      builder: (context, snapshot) {
        final record = snapshot.data;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.phase.label} · Día ${widget.day}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(DateFormat('EEEE, MMM d, yyyy').format(widget.date),
                  style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 16),
              if (!editable && record == null)
                const Text('Día futuro: sin registro todavía.',
                    style: TextStyle(color: Colors.grey))
              else ...[
                if (editable) ...[
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: (record?.isComplete ?? false)
                            ? Colors.grey.shade600
                            : Colors.red,
                      ),
                      onPressed: () => _setAll(!(record?.isComplete ?? false)),
                      icon: Icon((record?.isComplete ?? false)
                          ? Icons.remove_done
                          : Icons.done_all),
                      label: Text((record?.isComplete ?? false)
                          ? 'Desmarcar día'
                          : 'Completar día'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                for (final t in tasks)
                  InkWell(
                    onTap: editable ? () => _toggle(t) : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Icon(
                            (record?.isDone(t) ?? false)
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: 22,
                            color: (record?.isDone(t) ?? false)
                                ? Colors.red
                                : Colors.grey,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(t.label)),
                        ],
                      ),
                    ),
                  ),
                if (editable) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Toca una tarea para marcarla, o usa "Completar día" para '
                    'marcarlas todas.',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
                if (record != null && record.notes.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text('Notas:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(record.notes),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Encabezado: flecha atrás + "Settings" con engrane.
class _Header extends StatelessWidget {
  const _Header({required this.onSettings});

  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const Spacer(),
          InkWell(
            onTap: onSettings,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Text('Settings',
                      style: TextStyle(fontSize: 18, color: Colors.black87)),
                  SizedBox(width: 6),
                  Icon(Icons.settings, color: Colors.black87),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar + nombre + "Day Ends:".
class _ProfileRow extends StatelessWidget {
  const _ProfileRow({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.blue.shade200,
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.fullName,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('Day Ends: ${profile.dayEndTime}',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tarjeta de una fase con datos reales de progreso.
class _PhaseCard extends StatelessWidget {
  const _PhaseCard({
    required this.progress,
    required this.selected,
    required this.onTap,
    this.onEdit,
  });

  final PhaseProgress progress;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.red : Colors.grey.shade300,
            width: selected ? 3 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    progress.phase.label.toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                ),
                if (progress.isCurrent)
                  GestureDetector(
                    onTap: onEdit,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.edit_calendar,
                          color: Colors.white, size: 16),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
                'DAY 1: ${DateFormat('MMM d, yyyy').format(progress.startDate)}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
            const SizedBox(height: 2),
            Text('Completed ${progress.completedCount} Days',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            if (progress.isCurrent)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('Hoy: día ${progress.currentDay}',
                    style: const TextStyle(fontSize: 12, color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}

/// Cuadrícula de días de la fase. Completados en rojo, parciales en ámbar,
/// futuros en negro; el día de hoy con borde negro. Los días PASADOS sin
/// completar (racha rota) se marcan con un anillo rojo para que sea obvio cuáles
/// hay que "marcar" en el backfill.
class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.progress,
    required this.today,
    required this.onDayTap,
  });

  final PhaseProgress progress;
  final DateTime today;
  final ValueChanged<int> onDayTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.2,
      ),
      itemCount: progress.totalDays,
      itemBuilder: (context, i) {
        final day = i + 1;
        final done = progress.completedDays.contains(day);
        final partial = progress.partialDays.contains(day);
        final date = progress.startDate.add(Duration(days: i)).dayOnly;
        final isToday = date == today;
        // Día pasado (anterior a hoy) que no quedó completo: racha rota.
        final missed = date.isBefore(today) && !done;

        final color = done
            ? Colors.red
            : partial
                ? Colors.orange
                : missed
                    ? Colors.red.shade300
                    : Colors.black;

        return GestureDetector(
          onTap: () => onDayTap(day),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: isToday
                  ? Border.all(color: Colors.black, width: 2)
                  : missed
                      ? Border.all(color: Colors.red, width: 2)
                      : null,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Pie con la ayuda y el enlace a FAQ.
class _FaqFooter extends StatelessWidget {
  const _FaqFooter({required this.phaseLabel});

  final String phaseLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Toca un día para ver su detalle',
              style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 18),
              const SizedBox(width: 6),
              Text('$phaseLabel Program FAQ'),
            ],
          ),
        ],
      ),
    );
  }
}
