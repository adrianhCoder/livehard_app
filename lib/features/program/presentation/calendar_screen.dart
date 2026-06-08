import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/program_phase.dart';
import '../../profile/presentation/profile_screen.dart';
import '../application/mock_data.dart';
import '../application/phase_overview_provider.dart';
import '../application/program_controller.dart';
import '../application/program_providers.dart';
import '../domain/models/phase_progress.dart';
import 'phase_schedule_screen.dart';

/// Pantalla de progreso: tarjetas por fase (75 Hard + Fases 1-3) y el
/// calendario de la fase seleccionada, todo con datos reales de Isar.
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
            final idx =
                (_selected ?? (defaultIdx < 0 ? 0 : defaultIdx)).clamp(0, phases.length - 1);
            final current = phases[idx];

            return Column(
              children: [
                _Header(onSettings: _openSettings),
                _ProfileRow(profile: mockProfile),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
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
            await ref.read(programControllerProvider.notifier).completeOnboarding(
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

/// Hoja de detalle de un día: lee el [DailyRecord] real de Isar.
class _DayDetailSheet extends ConsumerWidget {
  const _DayDetailSheet(
      {required this.phase, required this.day, required this.date});

  final ProgramPhase phase;
  final int day;
  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(programRepositoryProvider);
    final record = repo.getRecordForDate(date);
    final tasks = PhaseRules.tasksFor(phase);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${phase.label} · Día $day',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(DateFormat('EEEE, MMM d, yyyy').format(date),
              style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 16),
          if (record == null)
            const Text('Sin registro para este día.',
                style: TextStyle(color: Colors.grey))
          else ...[
            for (final t in tasks)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Icon(
                      record.isDone(t)
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 20,
                      color: record.isDone(t) ? Colors.red : Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(t.label)),
                  ],
                ),
              ),
            if (record.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text('Notas:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(record.notes),
            ],
          ],
        ],
      ),
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
            Text('DAY 1: ${DateFormat('MMM d, yyyy').format(progress.startDate)}',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
            const SizedBox(height: 2),
            Text('Completed ${progress.completedCount} Days',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
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
/// futuros en negro; el día de hoy con borde.
class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({required this.progress, required this.onDayTap});

  final PhaseProgress progress;
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
        final isToday = progress.currentDay == day;

        final color = done
            ? Colors.red
            : partial
                ? Colors.orange
                : Colors.black;

        return GestureDetector(
          onTap: () => onDayTap(day),
          child: Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  isToday ? Border.all(color: Colors.black, width: 2) : null,
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
