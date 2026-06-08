# CLAUDE.md — LiveHard

Contexto del proyecto para Claude Code. Lee esto antes de trabajar.

## Qué es

App Flutter de rendición de cuentas diaria: clon de **75 Hard** + el programa
**Live Hard** (4 fases). El usuario marca tareas diarias; si falla, la racha se
reinicia. Se ejecuta como **app de escritorio de Windows** (Android no instalado).

## Stack

- **Flutter** (SDK Dart `^3.5.0`). Flutter 3.44.1 en `C:\src\flutter` (en PATH).
- **Riverpod** con generador de código (`riverpod_annotation` + `riverpod_generator`).
- **Isar** (base de datos local NoSQL, índices nativos sobre `DateTime`).
- `image_picker`, `path_provider`, `intl`.
- Arquitectura **feature-first**.

## Cómo correr

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # genera los *.g.dart
flutter run -d windows
flutter test                                                # 15 tests
flutter analyze                                             # 0 errores propios
```

Requiere **Modo Desarrollador** de Windows (symlinks de plugins).

### ⚠️ Conflicto de dependencias conocido
`isar_generator` 3.x exige `analyzer <6`, mientras `custom_lint`/`riverpod_lint`
exigen uno nuevo. **Solución:** `custom_lint` y `riverpod_lint` están comentados
en `dev_dependencies` (no se necesitan para ejecutar). Resuelve a `analyzer 5.13`.
Por eso `flutter analyze` muestra ~16 warnings **solo en archivos `*.g.dart`**
(`ProviderRef` deprecado, APIs `*ByIndex` experimentales de Isar): son benignos.

## Modelo de negocio (4 fases)

El usuario **ya hizo el 75 Hard** y la app **programa por adelantado** las Fases 1-3
en un calendario interactivo (NO se avanza de fase en vivo).

| Fase     | Duración | Regla de inicio |
|----------|----------|-----------------|
| 75 Hard  | 75 días  | Prerrequisito, hecho antes de usar la app (se asume completo). |
| Fase 1   | 30 días  | Tras terminar el 75 Hard. |
| Fase 2   | 30 días  | ≥ 30 días de **descanso** tras el fin de Fase 1; debe terminar antes de la Fase 3. |
| Fase 3   | 30 días  | **Estática**: debe **TERMINAR en el aniversario** del Día 1 del 75 Hard. |

### 🔑 Regla crítica de Fase 3 (NO revertir)
El brief original decía "Fase 3 inicia 30 días antes del aniversario", pero la
decisión vigente es que **la Fase 3 termina EN el aniversario**:
`phase3Start = aniversario − 29`, `phase3End = aniversario` (30 días inclusive).
Ver `mandatoryPhase3StartFor` en `program_date_logic.dart` y sus tests.

### Checklists por fase
Difieren por fase y están centralizados en `PhaseRules.tasksFor(phase)`
(`lib/core/enums/program_phase.dart`):
- **75 Hard / Fase 2**: 2 entrenamientos (1 afuera), 1 galón de agua, 10 páginas,
  dieta estricta, foto de progreso.
- **Fase 1**: base + ducha fría + visualización + 3 tareas del Power List.
- **Fase 3**: base + ducha fría + Power List + hablar con un extraño + acto de
  bondad (sin visualización).

## Mapa de archivos

```
lib/
  core/
    enums/program_phase.dart      # ProgramPhase, DailyTask, PhaseRules
    utils/date_x.dart             # dayOnly, daysUntil, addYears (math de días)
  features/
    onboarding/presentation/
      onboarding_flow.dart        # 1ª vez: pide Día 1 del 75 Hard + datos demo
    program/
      domain/models/
        program_state.dart        # singleton id=1: ancla 75H + phase1/2 start + flags
        daily_record.dart         # registro diario (booleans por tarea, notas, foto)
        phase_schedule.dart       # PhaseSchedule.fromState -> rangos + entryFor(día)
        phase_progress.dart       # progreso real por fase (desde DailyRecords)
        attempt_summary.dart      # (legacy, mock)
      application/
        program_date_logic.dart   # reglas de fecha PURAS + validateSchedule (testeado)
        program_controller.dart   # completeOnboarding, avance/reinicio (acciones)
        today_record_controller.dart  # registro de HOY (toggle tareas/notas/foto)
        phase_overview_provider.dart  # progreso real de todas las fases
        program_providers.dart    # isar, repo, programState (stream), date logic
        mock_data.dart            # mockProfile + seedSampleProgram(repo)
      data/program_repository.dart  # acceso a Isar (estado + registros)
      presentation/
        calendar_screen.dart      # progreso: tarjetas + calendario reales (Isar)
        phase_schedule_screen.dart  # calendario interactivo 3 colores (programar)
    profile/presentation/profile_screen.dart  # ajustes (mock) + reprogramar fases
  main.dart                       # entrypoint + HomeScreen + vista de HOY
test/unit/program_date_logic_test.dart        # reglas de fecha + PhaseSchedule
```

## Convenciones / notas

- **Fechas**: SIEMPRE normalizar con `DateX.dayOnly` antes de guardar/comparar.
  Rangos inclusivos; `finFase = inicio + (durationDays - 1)`.
- **`ProgramState`** es singleton (`id == 1`). `programStartDate` = Día 1 del 75 Hard.
  `currentPhase`/`currentPhaseStartDate` son **legacy**; la fase de HOY se **deriva**
  con `PhaseSchedule.entryFor(...)`.
- La lógica de fechas es **Dart puro con `now` inyectable** → testeable; no metas
  `DateTime.now()` directo en la lógica de negocio.
- **Tras editar modelos Isar o providers**, corre `build_runner` (regenera `*.g.dart`,
  que SÍ se commitean).
- El **perfil** del usuario todavía es mock (`mockProfile`); no hay store real aún.
- Pendiente: detección automática de racha rota (marcar día incompleto → reinicio).

## Memoria persistente

Hay notas en `~/.claude/.../memory/` (setup de Windows, decisión de Fase 3).
Mantenlas si cambias reglas de negocio o el flujo de build.
