import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../program/application/mock_data.dart';
import '../../program/application/program_controller.dart';
import '../../program/application/program_providers.dart';
import '../../program/presentation/phase_schedule_screen.dart';

/// Flujo de primera vez: pide el Día 1 del 75 Hard (ancla del aniversario) y
/// luego abre el calendario para programar las Fases 1 y 2 (la 3 es estática).
///
/// Todo se persiste local vía [completeOnboarding]; también ofrece cargar un
/// programa de ejemplo (mock) para demo.
class OnboardingFlow extends ConsumerWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.flag, size: 72, color: Colors.red),
                const SizedBox(height: 16),
                Text('Bienvenido a LiveHard',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                const Text(
                  'La Fase 3 debe TERMINAR en el aniversario de tu 75 Hard. '
                  'Para programar tus fases, dinos cuándo fue el Día 1 de tu '
                  '75 Hard.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Elegir Día 1 del 75 Hard'),
                  onPressed: () => _pickHard75Day1(context, ref),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => _loadSample(context, ref),
                  child: const Text('Cargar datos de ejemplo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickHard75Day1(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 80)),
      firstDate: DateTime(now.year - 2),
      lastDate: now,
      helpText: 'Día 1 de tu 75 Hard',
    );
    if (picked == null || !context.mounted) return;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PhaseScheduleScreen(
          hard75Day1: picked,
          title: 'Programa tus fases',
          confirmLabel: 'Empezar',
          onConfirm: (p1, p2) async {
            await ref.read(programControllerProvider.notifier).completeOnboarding(
                  hard75Day1: picked,
                  phase1Start: p1,
                  phase2Start: p2,
                );
            // El estado cambia y HomeScreen reconstruye la vista de hoy.
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _loadSample(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(programRepositoryProvider);
    await seedSampleProgram(repo);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Programa de ejemplo cargado (${DateFormat('MMM d').format(DateTime.now())}).'),
        ),
      );
    }
  }
}
