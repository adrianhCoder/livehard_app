import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../application/phase_overview_provider.dart';
import '../application/program_controller.dart';
import '../application/streak_failure_provider.dart';
import '../domain/models/streak_failure.dart';

/// Pantalla bloqueante de "HAS FALLADO". Aparece en lugar de la checklist de HOY
/// cuando [detectStreakFailure] encuentra un día pasado sin completar.
///
/// Ofrece dos caminos, como la app de referencia:
///  - **Marcar días anteriores y continuar**: completa automáticamente TODOS los
///    días anteriores (por si en realidad sí cumpliste y olvidaste marcar) y
///    vuelve a HOY.
///  - **Reiniciar**: lleva a la confirmación "START OVER". Fallar la Fase 3 es
///    especial: reinicia TODO el programa desde el 75 Hard.
class FailureScreen extends ConsumerStatefulWidget {
  const FailureScreen({super.key, required this.failure});

  final StreakFailure failure;

  @override
  ConsumerState<FailureScreen> createState() => _FailureScreenState();
}

class _FailureScreenState extends ConsumerState<FailureScreen> {
  bool _busy = false;

  /// Marca de golpe todos los días anteriores y refresca la detección de racha.
  /// Al limpiarse la racha, `HomeScreen` vuelve a mostrar la vista de HOY.
  Future<void> _markPastAndContinue() async {
    setState(() => _busy = true);
    try {
      await ref.read(programControllerProvider.notifier).completePastDays();
      ref.invalidate(streakFailureProvider);
      ref.invalidate(phaseOverviewProvider);
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudieron marcar los días: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final failure = widget.failure;
    final fullReset = failure.requiresFullReset;
    final dateLabel = DateFormat('EEEE, MMM d, yyyy').format(failure.date);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.dangerous_outlined,
                  color: Colors.red, size: 88),
              const SizedBox(height: 20),
              Text(
                fullReset ? 'HAS FALLADO LA FASE 3' : 'HAS FALLADO',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'No marcaste todos los requisitos de\n'
                '${failure.phase.label} · Día ${failure.dayNumber}\n$dateLabel',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 17),
              ),
              const SizedBox(height: 16),
              Text(
                fullReset
                    ? 'Fallar la Fase 3 reinicia TODO el programa: vuelves al '
                        '75 Hard desde el Día 0.'
                    : 'Tu racha se rompió. Puedes dar por hechos los días '
                        'anteriores o reiniciar la fase desde cero.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade200, fontSize: 15),
              ),
              const SizedBox(height: 36),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white54),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _busy ? null : _markPastAndContinue,
                child: _busy
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text(
                        'Marcar días anteriores y continuar',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _busy
                    ? null
                    : () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                RestartConfirmScreen(failure: failure),
                          ),
                        ),
                child: Text(
                  fullReset ? 'Reiniciar todo el programa' : 'Reiniciar la fase',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Confirmación destructiva: hay que escribir literalmente "START OVER" para
/// habilitar el botón, y elegir cuándo reiniciar (hoy o una fecha futura).
class RestartConfirmScreen extends ConsumerStatefulWidget {
  const RestartConfirmScreen({super.key, required this.failure});

  final StreakFailure failure;

  @override
  ConsumerState<RestartConfirmScreen> createState() =>
      _RestartConfirmScreenState();
}

class _RestartConfirmScreenState extends ConsumerState<RestartConfirmScreen> {
  static const _phrase = 'START OVER';

  final _controller = TextEditingController();
  DateTime _startDate = DateTime.now();
  bool _busy = false;

  bool get _confirmed => _controller.text.trim().toUpperCase() == _phrase;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _restart() async {
    setState(() => _busy = true);
    final controller = ref.read(programControllerProvider.notifier);
    final f = widget.failure;
    try {
      if (f.requiresFullReset) {
        await controller.restartEntireProgram(
          newHard75Day1: _startDate,
          dayReached: f.dayNumber,
        );
      } else {
        await controller.restartPhaseFrom(
          phase: f.phase,
          newStart: _startDate,
          dayReached: f.dayNumber,
          reason: 'Racha rota en ${f.phase.label} · Día ${f.dayNumber}.',
        );
      }
      ref.invalidate(streakFailureProvider);
      ref.invalidate(phaseOverviewProvider);
      if (mounted) {
        // Vuelve a la raíz; la vista de HOY reflejará el calendario reiniciado.
        Navigator.of(context).popUntil((r) => r.isFirst);
      }
    } on ScheduleException catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        _showProblems(e.problems);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _busy = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No se pudo reiniciar: $e')));
      }
    }
  }

  void _showProblems(List<String> problems) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Esa fecha no encaja'),
        content: Text(
          '${problems.join('\n\n')}\n\nElige otra fecha de inicio.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.failure;
    final fullReset = f.requiresFullReset;
    final dateLabel = DateFormat('EEEE, MMM d, yyyy').format(_startDate);

    return Scaffold(
      appBar: AppBar(
        title: Text(fullReset ? 'Reiniciar todo' : 'Reiniciar ${f.phase.label}'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              fullReset
                  ? 'Vas a borrar TODO tu progreso y empezar de nuevo desde el '
                      '75 Hard. Esta acción no se puede deshacer.'
                  : 'Vas a borrar el progreso de ${f.phase.label} (y de las '
                      'fases posteriores) y reprogramarla. Esta acción no se '
                      'puede deshacer.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 28),
            const Text('¿Cuándo quieres reiniciar?',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(dateLabel, style: const TextStyle(fontSize: 16)),
                ),
                TextButton.icon(
                  onPressed: _busy ? null : _pickDate,
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: const Text('Cambiar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed:
                    _busy ? null : () => setState(() => _startDate = DateTime.now()),
                child: const Text('Empezar hoy'),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Escribe "START OVER" para confirmar:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              enabled: !_busy,
              autocorrect: false,
              textCapitalization: TextCapitalization.characters,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'START OVER',
              ),
            ),
            const SizedBox(height: 28),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: (_confirmed && !_busy) ? _restart : null,
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      fullReset
                          ? 'Reiniciar todo el programa'
                          : 'Reiniciar ${f.phase.label}',
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
