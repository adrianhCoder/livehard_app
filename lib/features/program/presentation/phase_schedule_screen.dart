import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/enums/program_phase.dart';
import '../../../core/utils/date_x.dart';
import '../application/program_date_logic.dart';
import '../domain/models/phase_schedule.dart';

/// Colores de cada fase en el calendario.
const _phase1Color = Color(0xFFE53935); // rojo  — Fase 1
const _phase2Color = Color(0xFF1E88E5); // azul  — Fase 2
const _phase3Color = Color(0xFF43A047); // verde — Fase 3 (estática)

Color _colorFor(ProgramPhase phase) => switch (phase) {
      ProgramPhase.phase1 => _phase1Color,
      ProgramPhase.phase2 => _phase2Color,
      ProgramPhase.phase3 => _phase3Color,
      ProgramPhase.hard75 => Colors.grey,
    };

/// Calendario interactivo para programar las Fases 1 y 2 (la Fase 3 es
/// estática y va bloqueada). Reutilizable desde el onboarding y desde Perfil.
///
/// La app sugiere las fechas más tempranas válidas y el usuario las ajusta
/// tocando el día de inicio de la fase que esté editando.
class PhaseScheduleScreen extends StatefulWidget {
  const PhaseScheduleScreen({
    super.key,
    required this.hard75Day1,
    required this.onConfirm,
    this.initialPhase1Start,
    this.initialPhase2Start,
    this.title = 'Configurar fases',
    this.confirmLabel = 'Confirmar',
  });

  /// Día 1 del 75 Hard (ancla del aniversario / Fase 3).
  final DateTime hard75Day1;

  /// Se llama con las fechas elegidas al confirmar un calendario válido.
  final Future<void> Function(DateTime phase1Start, DateTime phase2Start)
      onConfirm;

  final DateTime? initialPhase1Start;
  final DateTime? initialPhase2Start;
  final String title;
  final String confirmLabel;

  @override
  State<PhaseScheduleScreen> createState() => _PhaseScheduleScreenState();
}

class _PhaseScheduleScreenState extends State<PhaseScheduleScreen> {
  static const _logic = ProgramDateLogic();

  late DateTime _phase1Start;
  late DateTime _phase2Start;

  /// Fase que se está editando al tocar el calendario (solo 1 o 2).
  ProgramPhase _editing = ProgramPhase.phase1;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _phase1Start = (widget.initialPhase1Start ??
            _logic.defaultPhase1StartFor(widget.hard75Day1))
        .dayOnly;
    _phase2Start = (widget.initialPhase2Start ??
            _logic.earliestPhase2StartFrom(_phase1Start))
        .dayOnly;
  }

  // -------- Cálculo de rangos y problemas --------

  DateTime get _phase3Start =>
      _logic.mandatoryPhase3StartFor(widget.hard75Day1);
  DateTime get _anniversary => widget.hard75Day1.dayOnly.addYears(1);

  DateRange get _r1 =>
      DateRange(_phase1Start, _logic.phaseEndDate(_phase1Start, ProgramPhase.phase1));
  DateRange get _r2 =>
      DateRange(_phase2Start, _logic.phaseEndDate(_phase2Start, ProgramPhase.phase2));
  DateRange get _r3 => DateRange(_phase3Start, _anniversary);

  List<String> get _problems => _logic.validateSchedule(
        hard75Day1: widget.hard75Day1,
        phase1Start: _phase1Start,
        phase2Start: _phase2Start,
      );

  ProgramPhase? _phaseOfDay(DateTime d) {
    if (_r1.contains(d)) return ProgramPhase.phase1;
    if (_r2.contains(d)) return ProgramPhase.phase2;
    if (_r3.contains(d)) return ProgramPhase.phase3;
    return null;
  }

  // -------- Interacción --------

  void _onDayTap(DateTime day) {
    final d = day.dayOnly;

    if (_editing == ProgramPhase.phase1) {
      final minP1 = _logic.earliestPhase1StartFor(widget.hard75Day1);
      if (d.isBefore(minP1)) {
        _snack('La Fase 1 no puede empezar antes del ${_fmt(minP1)} '
            '(después del 75 Hard y no en el pasado).');
        return;
      }
      setState(() {
        _phase1Start = d;
        // Reajusta la Fase 2 para que siga siendo válida tras mover la Fase 1.
        final minP2 = _logic.earliestPhase2StartFrom(d);
        final maxP2 = _logic.latestPhase2StartFor(widget.hard75Day1);
        if (_phase2Start.isBefore(minP2)) _phase2Start = minP2;
        if (_phase2Start.isAfter(maxP2)) _phase2Start = maxP2;
      });
    } else {
      final minP2 = _logic.earliestPhase2StartFrom(_phase1Start);
      final maxP2 = _logic.latestPhase2StartFor(widget.hard75Day1);
      if (d.isBefore(minP2)) {
        _snack('La Fase 2 debe empezar el ${_fmt(minP2)} o después '
            '(30 días de descanso tras la Fase 1).');
        return;
      }
      if (d.isAfter(maxP2)) {
        _snack('La Fase 2 debe terminar antes de la Fase 3. '
            'Inicio máximo: ${_fmt(maxP2)}.');
        return;
      }
      setState(() => _phase2Start = d);
    }
  }

  Future<void> _confirm() async {
    if (_problems.isNotEmpty) return;
    setState(() => _saving = true);
    try {
      await widget.onConfirm(_phase1Start, _phase2Start);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  static String _fmt(DateTime d) => DateFormat('MMM d, yyyy').format(d);

  // -------- UI --------

  @override
  Widget build(BuildContext context) {
    final months = _monthsToShow();
    final valid = _problems.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          _legendAndToggle(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: months.length,
              itemBuilder: (context, i) => _MonthView(
                month: months[i],
                colorOf: (d) {
                  final phase = _phaseOfDay(d);
                  return phase == null ? null : _colorFor(phase);
                },
                isStart: (d) =>
                    d.isSameDay(_phase1Start) ||
                    d.isSameDay(_phase2Start) ||
                    d.isSameDay(_phase3Start),
                onTap: _onDayTap,
              ),
            ),
          ),
          _bottomBar(valid),
        ],
      ),
    );
  }

  Widget _legendAndToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _legendDot(_phase1Color, 'Fase 1 · ${_fmt(_phase1Start)}'),
              _legendDot(_phase2Color, 'Fase 2 · ${_fmt(_phase2Start)}'),
              _legendDot(_phase3Color, 'Fase 3 (fija) · ${_fmt(_phase3Start)}'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Editando: '),
              const SizedBox(width: 8),
              SegmentedButton<ProgramPhase>(
                segments: const [
                  ButtonSegment(
                      value: ProgramPhase.phase1, label: Text('Fase 1')),
                  ButtonSegment(
                      value: ProgramPhase.phase2, label: Text('Fase 2')),
                ],
                selected: {_editing},
                onSelectionChanged: (s) => setState(() => _editing = s.first),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  Widget _bottomBar(bool valid) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!valid)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _problems.first,
                  style: const TextStyle(color: _phase1Color, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: (valid && !_saving) ? _confirm : null,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(widget.confirmLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Lista de meses (primer día de cada mes) desde hoy/Fase 1 hasta la Fase 3.
  List<DateTime> _monthsToShow() {
    final today = DateTime.now().dayOnly;
    final first = today.isBefore(_phase1Start) ? today : _phase1Start;
    var cursor = DateTime(first.year, first.month);
    final last = DateTime(_anniversary.year, _anniversary.month);
    final months = <DateTime>[];
    while (!cursor.isAfter(last)) {
      months.add(cursor);
      cursor = DateTime(cursor.year, cursor.month + 1);
    }
    return months;
  }
}

/// Rejilla de un mes (domingo a sábado).
class _MonthView extends StatelessWidget {
  const _MonthView({
    required this.month,
    required this.colorOf,
    required this.isStart,
    required this.onTap,
  });

  final DateTime month; // primer día del mes
  final Color? Function(DateTime) colorOf;
  final bool Function(DateTime) isStart;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlanks = DateTime(month.year, month.month, 1).weekday % 7; // dom=0
    final cells = leadingBlanks + daysInMonth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
          child: Text(
            DateFormat('MMMM yyyy').format(month),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const Row(
          children: [
            _Weekday('D'),
            _Weekday('L'),
            _Weekday('M'),
            _Weekday('M'),
            _Weekday('J'),
            _Weekday('V'),
            _Weekday('S'),
          ],
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.1,
          ),
          itemCount: cells,
          itemBuilder: (context, i) {
            if (i < leadingBlanks) return const SizedBox.shrink();
            final day = DateTime(month.year, month.month, i - leadingBlanks + 1);
            final color = colorOf(day);
            final start = isStart(day);
            return _DayCell(
              label: '${day.day}',
              color: color,
              isStart: start,
              onTap: () => onTap(day),
            );
          },
        ),
      ],
    );
  }
}

class _Weekday extends StatelessWidget {
  const _Weekday(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.label,
    required this.color,
    required this.isStart,
    required this.onTap,
  });

  final String label;
  final Color? color;
  final bool isStart;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final filled = color != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: filled ? color : Colors.transparent,
          shape: BoxShape.circle,
          border: isStart ? Border.all(color: Colors.black, width: 2) : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: filled ? FontWeight.bold : FontWeight.normal,
              color: filled ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
