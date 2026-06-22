import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_x.dart';
import '../../program/application/dev_clock.dart';
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
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(CupertinoIcons.suit_spade_fill,
                          size: 96, color: Colors.white),
                      Positioned(
                        top: 18,
                        child: Text('75',
                            style: TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.w900,
                                fontSize: 30)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const Text('BIENVENIDO A LIVEHARD',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.white)),
                  const SizedBox(height: 12),
                  const Text(
                    'La Fase 3 debe TERMINAR en el aniversario de tu 75 Hard. '
                    'Para programar tus fases, dinos cuándo fue el Día 1 de tu '
                    '75 Hard.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 28),
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                    ),
                    icon: const Icon(Icons.calendar_today),
                    label: const Text('Elegir Día 1 del 75 Hard'),
                    onPressed: () => _pickHard75Day1(context, ref),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => _loadSample(context, ref),
                    child: const Text('Cargar datos de ejemplo',
                        style: TextStyle(color: Colors.white60)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickHard75Day1(BuildContext context, WidgetRef ref) async {
    final today = ref.read(simulatedNowProvider).dayOnly;
    // El Día 1 del 75 Hard siempre está en el pasado (el 75 Hard ya se
    // completó antes de usar la app), así que el último día seleccionable
    // es ayer, nunca hoy ni el futuro.
    final lastSelectable = today.subtract(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: lastSelectable.subtract(const Duration(days: 79)),
      firstDate: DateTime(today.year - 2),
      lastDate: lastSelectable,
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
