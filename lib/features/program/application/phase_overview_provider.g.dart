// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phase_overview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$phaseOverviewHash() => r'aea41edbb43d3c92431bd0c1feb213253592114a';

/// Progreso real de todas las fases (75 Hard + Fases 1-3) calculado desde el
/// [ProgramState] y los [DailyRecord] de Isar. Lo consume la pantalla de
/// progreso. Es autoDispose: se recalcula cada vez que se abre la pantalla, así
/// refleja las tareas marcadas durante la sesión.
///
/// Copied from [phaseOverview].
@ProviderFor(phaseOverview)
final phaseOverviewProvider =
    AutoDisposeFutureProvider<List<PhaseProgress>>.internal(
  phaseOverview,
  name: r'phaseOverviewProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$phaseOverviewHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PhaseOverviewRef = AutoDisposeFutureProviderRef<List<PhaseProgress>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
