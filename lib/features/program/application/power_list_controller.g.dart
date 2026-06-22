// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'power_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activePowerListHash() => r'bbce4dba3479baa032b83ea3ed812d5a79894f2d';

/// Stream de las tareas de Power List vigentes (reacciona a altas/bajas).
///
/// Copied from [activePowerList].
@ProviderFor(activePowerList)
final activePowerListProvider =
    AutoDisposeStreamProvider<List<PowerListItem>>.internal(
  activePowerList,
  name: r'activePowerListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activePowerListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActivePowerListRef = AutoDisposeStreamProviderRef<List<PowerListItem>>;
String _$powerListControllerHash() =>
    r'd8b7f42fd9105259fd9993272f96026c05f4a9c4';

/// Observa y muta la Power List del usuario (3 tareas críticas persistentes).
///
/// Copied from [PowerListController].
@ProviderFor(PowerListController)
final powerListControllerProvider = AutoDisposeAsyncNotifierProvider<
    PowerListController, List<PowerListSlotView>>.internal(
  PowerListController.new,
  name: r'powerListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$powerListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PowerListController
    = AutoDisposeAsyncNotifier<List<PowerListSlotView>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
