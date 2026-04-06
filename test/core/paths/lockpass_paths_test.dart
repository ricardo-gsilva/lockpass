import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/paths/lockpass_paths.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LockPassPaths', () {
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    late Directory tempRoot;

    setUp(() async {
      tempRoot = await Directory.systemTemp.createTemp('lockpass_paths_test_');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        channel,
        (call) async {
          switch (call.method) {
            case 'getApplicationDocumentsDirectory':
              return tempRoot.path;
            case 'getTemporaryDirectory':
              return tempRoot.path;
            default:
              return null;
          }
        },
      );
    });

    tearDown(() async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
      if (await tempRoot.exists()) {
        await tempRoot.delete(recursive: true);
      }
    });

    test('creates LockPass, db, backup and logs dirs under documents', () async {
      final baseDir = await LockPassPaths.baseDir;
      expect(baseDir.path, tempRoot.path);

      final lockPassDir = await LockPassPaths.lockPassDir;
      final dbDir = await LockPassPaths.dbDir;
      final backupDir = await LockPassPaths.backupDir;
      final logsDir = await LockPassPaths.logsDir;

      expect(await lockPassDir.exists(), isTrue);
      expect(await dbDir.exists(), isTrue);
      expect(await backupDir.exists(), isTrue);
      expect(await logsDir.exists(), isTrue);

      expect(lockPassDir.path, '${tempRoot.path}/LockPass');
      expect(dbDir.path, '${tempRoot.path}/LockPass/db');
      expect(backupDir.path, '${tempRoot.path}/LockPass/backup');
      expect(logsDir.path, '${tempRoot.path}/LockPass/logs');
    });
  });
}

