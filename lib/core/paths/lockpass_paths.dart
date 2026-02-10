import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LockPassPaths {
  LockPassPaths._();

  static Future<Directory> get baseDir async {
    return getApplicationDocumentsDirectory();
  }

  static Future<Directory> get lockPassDir async {
    final base = await baseDir;
    final dir = Directory('${base.path}/LockPass');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<Directory> get dbDir async {
    final dir = Directory('${(await lockPassDir).path}/db');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<Directory> get backupDir async {
    final dir = Directory('${(await lockPassDir).path}/backup');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<Directory> get logsDir async {
    final dir = Directory('${(await lockPassDir).path}/logs');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}
