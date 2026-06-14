// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$programControllerHash() => r'5d01c752296922f99f6eb2bb9d6da01d26e87982';

/// Controlador de acciones sobre el [ProgramState]: iniciar el programa,
/// avanzar de fase, registrar fallos y reinicios.
///
/// Es un notifier "de acciones" (su estado es `void`): la UI lee el estado en
/// vivo desde [programStateProvider]; aquí solo viven las mutaciones.
///
/// Copied from [ProgramController].
@ProviderFor(ProgramController)
final programControllerProvider =
    AutoDisposeNotifierProvider<ProgramController, void>.internal(
  ProgramController.new,
  name: r'programControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$programControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProgramController = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
