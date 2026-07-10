# CLAUDE.md — LiveHard

Contexto del proyecto para Claude Code. Lee esto antes de trabajar.

## Qué es

App Flutter de rendición de cuentas diaria: clon de **75 Hard** + el programa
**Live Hard** (4 fases). El usuario marca tareas diarias; si falla, la racha se
reinicia. Corre como **app de escritorio** (Windows/macOS/Linux) y como
**Flutter Web** (Android no instalado).

## Stack

- **Flutter** (SDK Dart `^3.5.0`; probado con Flutter 3.44.x).
- **Riverpod** con generador de código (`riverpod_annotation` + `riverpod_generator`).
- **sembast** (base de datos local documental y reactiva, Dart puro):
  archivo `livehard.db` en escritorio/móvil, **IndexedDB** en web
  (`sembast_web`, elegido por import condicional en `program_providers.dart`).
  Migrada desde Isar 3, que no compila a web (dart:ffi + literales int64).
- `image_picker`, `path_provider`, `intl`.
- Arquitectura **feature-first**.

## Cómo correr

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # *.g.dart de riverpod
flutter run -d windows          # escritorio (o -d macos / -d linux)
flutter build web --release --no-web-resources-cdn   # web; sirve build/web en un puerto
# ⚠️ SIEMPRE con --no-web-resources-cdn: sin él, canvaskit se baja del CDN de
# gstatic y las redes que lo bloquean ven pantalla blanca (pasó el 2026-07-10).
flutter test                                                # 43 tests
flutter analyze                 # 0 errores propios (solo infos en *.g.dart)
```

En Windows requiere **Modo Desarrollador** (symlinks de plugins).

### Persistencia (reglas importantes)
- Los modelos **no usan codegen**: serializan a mano con `toMap()`/`fromMap()`.
  build_runner solo regenera los providers de riverpod.
- Las fechas se persisten como string `'yyyy-MM-dd'` (`DateX.dayKey`): el orden
  lexicográfico == cronológico, así funcionan los rangos.
- Los enums se persisten por **nombre** (`.name`): reordenar es seguro,
  **renombrar valores está prohibido** (rompería datos existentes).
- Un solo `DailyRecord` por fecha: el repositorio hace **upsert por fecha**
  (también en `saveRecords` bulk).
- Los datos de instalaciones viejas con Isar NO se migran (la app arranca
  limpia); el archivo `.isar` viejo ya no se puede leer sin la dependencia.
- `custom_lint`/`riverpod_lint` siguen comentados en `dev_dependencies`; el
  conflicto original con `isar_generator` ya no existe — reactivarlos es un
  follow-up pendiente.

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

### Power List (tareas críticas del usuario)
Confirmado con la doc oficial de Frisella: la Fase 2 **NO** lleva Power List
(es idéntica al 75 Hard). La Power List son **3 tareas críticas** (todas
obligatorias) que el usuario **define y mantiene día a día** hasta reemplazarlas
(~21 días = hábito). Solo aplica a Fase 1 y Fase 3.
- `PhaseRules.powerListCount` (3) = nº de ranuras; `powerListSlots` mapea
  slot→`DailyTask`. Las 3 entran en `tasksFor`, así que bloquean la racha.
- El texto vive en la colección `PowerListItem` (slot 1-3, `active`,
  `startDay`, `retiredDay`). Editar/reemplazar = retirar el actual + crear uno
  nuevo con `startDay` fresco → la racha por tarea arranca de cero.
- Racha por tarea: `power_list_logic.dart` (PURO, testeado). A los 21 días
  (`kPowerListHabitDays`) la UI sugiere reemplazar la tarea.

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
        streak_failure.dart       # StreakFailure + detectStreakFailure (PURO, testeado)
        attempt_summary.dart      # (legacy, mock)
      application/
        program_date_logic.dart   # reglas de fecha PURAS + validateSchedule + optionsForNextPhase (testeado)
        program_controller.dart   # onboarding, reinicios, setPhaseStart, completePastDays, wipe
        today_record_controller.dart  # registro de HOY (toggle tareas/notas/foto)
        phase_overview_provider.dart  # progreso real de todas las fases
        streak_failure_provider.dart  # detecta racha rota AHORA (desde la DB)
        dev_clock.dart            # SOLO DEV: offset de días + simulatedNowProvider
        program_providers.dart    # database, repo, programState (stream), date logic, openAppDatabase
        mock_data.dart            # mockProfile + seedSampleProgram(repo)
      data/
        program_repository.dart   # acceso a sembast (estado + registros + power list)
        db_factory_io.dart        # apertura en archivo (escritorio/móvil)
        db_factory_web.dart       # apertura en IndexedDB (web); import condicional
      presentation/
        calendar_screen.dart      # progreso: tarjetas + calendario (días pasados editables)
        failure_screen.dart       # "HAS FALLADO" + confirmación "START OVER"
        phase_schedule_screen.dart  # calendario interactivo 3 colores (programar)
    profile/presentation/profile_screen.dart  # ajustes (mock) + reprogramar fases
  main.dart                       # entrypoint + HomeScreen + vista de HOY
test/unit/program_date_logic_test.dart        # reglas de fecha + PhaseSchedule
test/unit/streak_failure_test.dart            # detección de racha rota
test/unit/program_repository_test.dart        # repositorio sobre sembast en memoria
```

## Convenciones / notas

- **Fechas**: SIEMPRE normalizar con `DateX.dayOnly` antes de guardar/comparar.
  Rangos inclusivos; `finFase = inicio + (durationDays - 1)`.
- **`ProgramState`** es singleton (`id == 1`). `programStartDate` = Día 1 del 75 Hard.
  `currentPhase`/`currentPhaseStartDate` son **legacy**; la fase de HOY se **deriva**
  con `PhaseSchedule.entryFor(...)`.
- La lógica de fechas es **Dart puro con `now` inyectable** → testeable; no metas
  `DateTime.now()` directo en la lógica de negocio.
- **Reloj de HOY**: la UI y los providers NO usan `DateTime.now()` directo; usan
  `simulatedNowProvider` (= fecha real + offset de `DevClock`). En producción el
  offset es 0. La barra dev (`_DevClockBar`, solo `kDebugMode`) permite ±días y
  un **Wipe** (borra estado + registros → onboarding) para probar desde cero.
- **Tras editar providers de riverpod**, corre `build_runner` (regenera `*.g.dart`,
  que SÍ se commitean). Los modelos ya no usan codegen: si añades un campo,
  actualiza su `toMap()`/`fromMap()` a mano (con default defensivo al leer).
- El **perfil** del usuario todavía es mock (`mockProfile`); no hay store real aún.
- **Racha rota**: `detectStreakFailure` busca el primer día PASADO de una fase sin
  completar (hoy nunca cuenta). Si lo hay, `HomeScreen` bloquea HOY con
  `FailureScreen`. Dos salidas: (a) **Marcar días anteriores y continuar** →
  `completePastDays` (completa de golpe todos los días pasados); (b) **Reiniciar**
  → "START OVER" → `restartPhaseFrom` (Fase 1/2: reprograma + borra esa fase y las
  posteriores) o `restartEntireProgram` (Fase 3: reset total → vuelve a onboarding).
  Nada se auto-completa: solo botones (`completePastDays`, `_setAll`).
- **Pantalla de descanso** (`_ScheduleStatusView`): ofrece "Iniciar ahora" / "Ajustar
  fecha" según `optionsForNextPhase` (Fase 2 exige 30 días de descanso; **Fase 3 es
  estática, `adjustable == false`**). Aplica con `setPhaseStart` (valida la ventana).
- Pendiente: store real de perfil de usuario.

## Memoria persistente

Hay notas en `~/.claude/.../memory/` (setup de Windows, decisión de Fase 3).
Mantenlas si cambias reglas de negocio o el flujo de build.
