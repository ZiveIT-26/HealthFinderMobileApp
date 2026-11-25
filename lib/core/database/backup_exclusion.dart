import 'dart:io';

import 'package:flutter/services.dart';

const _channel = MethodChannel('health_finder/backup');

/// Keeps [directory] and everything in it out of iCloud device backups.
///
/// The database key is stored with `first_unlock_this_device`, so it is not
/// restored from a backup. A restored database file could never be opened.
/// Android needs nothing: backup is disabled for the whole app.
/// Native side: `ios/Runner/AppDelegate.swift`.
Future<void> excludeFromBackup(Directory directory) async {
  if (!Platform.isIOS) return;
  await _channel.invokeMethod<void>(
    'excludeFromBackup',
    {'path': directory.path},
  );
}
