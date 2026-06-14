// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_failure_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$streakFailureHash() => r'd2e0b7c81ce51988029dfe980adbb15ee08ec1d7';

/// Detecta si la racha está rota AHORA: el primer día pasado de una fase activa
/// que no quedó completo. Devuelve `null` si la racha sigue viva (o si aún no
/// hay calendario programado).
///
/// Es autoDispose: la vista de HOY lo observa y se recalcula tras marcar días
/// anteriores (backfill) o reiniciar una fase. Invalídalo después de mutar
/// registros para refrescar el aviso.
///
/// Copied from [streakFailure].
@ProviderFor(streakFailure)
final streakFailureProvider =
    AutoDisposeFutureProvider<StreakFailure?>.internal(
  streakFailure,
  name: r'streakFailureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$streakFailureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StreakFailureRef = AutoDisposeFutureProviderRef<StreakFailure?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
