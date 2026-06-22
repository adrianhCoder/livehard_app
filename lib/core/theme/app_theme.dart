import 'package:flutter/material.dart';

/// Paleta de marca LiveHard, inspirada en el estilo 1st Phorm / Andy Frisella:
/// negros profundos, rojo agresivo y tipografía bold.
class AppColors {
  const AppColors._();

  /// Fondo principal (casi negro).
  static const Color ink = Color(0xFF0C0C0E);

  /// Superficie elevada (tarjetas, filas, diálogos).
  static const Color surface = Color(0xFF18181B);

  /// Superficie aún más elevada / bordes sutiles.
  static const Color surfaceAlt = Color(0xFF232328);

  /// Rojo de marca (tipo 1st Phorm).
  static const Color red = Color(0xFFE11D1D);

  /// Rojo oscuro para gradientes y estados presionados.
  static const Color redDeep = Color(0xFF7A0F12);

  /// Texto principal.
  static const Color text = Color(0xFFF5F5F5);

  /// Texto secundario / atenuado.
  static const Color textMuted = Color(0xFF9A9AA2);

  /// Líneas divisorias sutiles.
  static const Color divider = Color(0x1FFFFFFF);

  /// Gradiente de héroe (negro → rojo profundo) para encabezados y portadas.
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF000000), Color(0xFF1A0406), redDeep],
    stops: [0.0, 0.55, 1.0],
  );
}

/// Tema oscuro de la app. Centraliza colores, tipografía y estilos de
/// componentes para que toda la UI sea coherente con la marca.
ThemeData buildLiveHardTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: 'Roboto',
  );

  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.red,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.red,
    secondary: AppColors.red,
    surface: AppColors.surface,
    onSurface: AppColors.text,
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.ink,
    colorScheme: scheme,
    dividerColor: AppColors.divider,
    dividerTheme: const DividerThemeData(color: AppColors.divider, space: 1),
    dialogTheme: const DialogThemeData(backgroundColor: AppColors.surface),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.surfaceAlt,
      contentTextStyle: TextStyle(color: AppColors.text),
      behavior: SnackBarBehavior.floating,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: AppColors.text,
      displayColor: AppColors.text,
    ),
    iconTheme: const IconThemeData(color: AppColors.text),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.red,
        foregroundColor: Colors.white,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        side: const BorderSide(color: Color(0x33FFFFFF)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.red),
    ),
  );
}
