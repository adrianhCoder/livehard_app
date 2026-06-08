import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../program/application/mock_data.dart';
import '../../program/application/program_controller.dart';
import '../../program/application/program_providers.dart';
import '../../program/presentation/phase_schedule_screen.dart';

/// Pantalla "Edit Profile & Settings".
///
/// Por ahora lee/escribe sobre [mockProfile] en memoria (los toggles tienen
/// estado local). El resto de filas son acciones de UI sin lógica todavía.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _oneHourLeft = mockProfile.oneHourLeftNotification;
  bool _savePics = mockProfile.savePicsToPhone;

  /// Abre el calendario para reprogramar las fases del programa actual.
  Future<void> _reconfigurePhases() async {
    final program = ref.read(programStateProvider).valueOrNull;
    if (program == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aún no hay un programa configurado.')),
      );
      return;
    }
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
            if (mounted) Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lastSync =
        DateFormat('MM/dd/yyyy hh:mm a').format(mockProfile.lastSync);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // ---- Back ----
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text('Edit Profile & Settings',
                  style: TextStyle(fontSize: 18, color: Colors.black87)),
            ),

            // ---- Avatar con lápiz de edición ----
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue.shade200,
                    child:
                        const Icon(Icons.person, size: 44, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle),
                      child: const CircleAvatar(
                        radius: 13,
                        backgroundColor: Color(0xFFE0E0E0),
                        child: Icon(Icons.edit, size: 15, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),

            // ---- Campos editables ----
            _FieldRow(label: 'First Name', value: mockProfile.firstName),
            _FieldRow(label: 'Last Name', value: mockProfile.lastName),
            _FieldRow(label: 'E-Mail', value: mockProfile.email),
            _FieldRow(label: 'Day End Time', value: mockProfile.dayEndTime),

            // ---- Toggles ----
            _ToggleRow(
              label: '"1 hour left" notification',
              value: _oneHourLeft,
              onChanged: (v) => setState(() => _oneHourLeft = v),
            ),
            _ToggleRow(
              label: 'Save progress pics to phone',
              value: _savePics,
              onChanged: (v) => setState(() => _savePics = v),
            ),

            // ---- Valor simple ----
            _ValueRow(label: 'Theme', value: mockProfile.theme),

            // ---- Acciones ----
            _FieldRow(label: 'Sync Now', value: 'Last Sync: $lastSync'),
            _ActionRow(
                label: 'Reprogramar fases', onTap: _reconfigurePhases),
            const _ActionRow(label: 'Live Hard Program Overview'),
            const _ActionRow(label: 'Sign Out'),

            const SizedBox(height: 16),

            // ---- Botones inferiores ----
            Container(
              color: const Color(0xFFEFEFEF),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: const Column(
                children: [
                  _BlackButton(label: 'Get Help/Report a Problem'),
                  SizedBox(height: 14),
                  _BlackButton(label: 'Share Live Hard with a Friend'),
                  SizedBox(height: 14),
                  _BlackButton(label: 'Delete Account'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fila con etiqueta pequeña arriba, valor abajo y chevron a la derecha.
class _FieldRow extends StatelessWidget {
  const _FieldRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(value, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

/// Fila de acción simple (una sola línea) con chevron.
class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap ?? () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
                Icon(Icons.chevron_right, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

/// Fila con interruptor a la derecha.
class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: Colors.teal,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

/// Fila con un valor de solo lectura a la derecha (ej. Theme: Light).
class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontSize: 16))),
              Text(value,
                  style:
                      TextStyle(fontSize: 16, color: Colors.grey.shade700)),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}

/// Botón negro full-width de la sección inferior.
class _BlackButton extends StatelessWidget {
  const _BlackButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
