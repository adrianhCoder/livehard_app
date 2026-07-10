import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

/// Abre la base de datos como archivo en el sandbox de la app
/// (Windows/macOS/Linux/móvil). En web el import condicional de
/// `program_providers.dart` elige `db_factory_web.dart` en su lugar.
Future<Database> openPlatformDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  return databaseFactoryIo.openDatabase(p.join(dir.path, 'livehard.db'));
}
