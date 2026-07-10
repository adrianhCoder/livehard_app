import 'package:sembast_web/sembast_web.dart';

/// Abre la base de datos sobre IndexedDB (Flutter Web). En escritorio/móvil
/// el import condicional de `program_providers.dart` elige `db_factory_io.dart`.
Future<Database> openPlatformDatabase() =>
    databaseFactoryWeb.openDatabase('livehard.db');
