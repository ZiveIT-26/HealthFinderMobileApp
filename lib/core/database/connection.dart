import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../storage/secure_store.dart';
import 'app_database.dart';
import 'backup_exclusion.dart';

const _fileName = 'health_finder.sqlite';

/// SQLITE_NOTADB: the file is not a database, or the key is wrong.
const _sqliteNotADatabase = 26;

/// Creates the app's database. Nothing is opened until the first query.
AppDatabase openAppDatabase(SecureStore secure) =>
    AppDatabase(LazyDatabase(() => _openEncrypted(secure)));

/// The database file. It lives in the app support folder (not in the cache
/// folder, which the system may clear), in a subfolder excluded from iOS
/// backups.
Future<File> databaseFile() async {
  final support = await getApplicationSupportDirectory();
  final directory = Directory(p.join(support.path, 'database'));
  await directory.create(recursive: true);
  await excludeFromBackup(directory);
  return File(p.join(directory.path, _fileName));
}

/// Deletes the database file with its journal files. Close the database
/// first. Used when the file cannot be opened and for wiping the device.
Future<void> deleteDatabaseFiles() async {
  final file = await databaseFile();
  for (final path in [file.path, '${file.path}-wal', '${file.path}-shm']) {
    final f = File(path);
    if (await f.exists()) await f.delete();
  }
}

Future<QueryExecutor> _openEncrypted(SecureStore secure) async {
  // Throws while the key is unreadable (iOS before the first unlock). The
  // database is never recreated because of that.
  final key = await secure.databaseKey();
  final file = await databaseFile();

  // Android forbids /tmp, where sqlite would put its temporary files.
  if (Platform.isAndroid) {
    sqlite3.tempDirectory = (await getTemporaryDirectory()).path;
  }

  await _discardIfUnreadable(file, key);

  return NativeDatabase.createInBackground(
    file,
    setup: (db) {
      assert(
        db.select('PRAGMA cipher;').isNotEmpty,
        'SQLite3MultipleCiphers is not bundled: check "hooks" in pubspec.yaml',
      );
      _applyKey(db, key);
      db.execute('PRAGMA foreign_keys = ON;');
      db.execute('PRAGMA secure_delete = ON;');
    },
  );
}

/// The key is 64 hex characters (32 random bytes). The `raw:` form uses it
/// as the cipher key directly, without deriving a key from a passphrase.
/// The key is only checked on the first read, hence the query.
void _applyKey(Database db, String key) {
  db.execute("PRAGMA key = 'raw:$key';");
  db.select('SELECT count(*) FROM sqlite_master;');
}

/// A file that the current key cannot open (restored from a backup, or the
/// key was lost) can never be read again. It is deleted, and the app starts
/// with an empty database. See "Errors and recovery" in local-database.md.
Future<void> _discardIfUnreadable(File file, String key) async {
  if (!await file.exists()) return;

  final db = sqlite3.open(file.path);
  var readable = true;
  try {
    _applyKey(db, key);
  } on SqliteException catch (e) {
    if (e.resultCode != _sqliteNotADatabase) rethrow;
    readable = false;
  } finally {
    db.close();
  }

  if (!readable) await deleteDatabaseFiles();
}
