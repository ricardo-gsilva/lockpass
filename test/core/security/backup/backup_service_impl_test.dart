import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/security/backup/backup_service_impl.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/security/crypto/dek/secure_storage/secure_storage_dek_store.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';

class _FakeFilePicker extends FilePicker {
  _FakeFilePicker({this.pickFilesResult});

  FilePickerResult? pickFilesResult;

  @override
  Future<FilePickerResult?> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    bool allowCompression = false,
    int compressionQuality = 0,
    bool allowMultiple = false,
    bool withData = false,
    bool withReadStream = false,
    bool lockParentWindow = false,
    bool readSequential = false,
  }) async {
    return pickFilesResult;
  }
}

class _InMemoryDekStore implements SecureStorageDekStore {
  final Map<String, Uint8List> _store = {};

  @override
  Future<Uint8List?> readDek(String uid) async => _store[uid];

  @override
  Future<void> writeDek(String uid, Uint8List dek) async {
    _store[uid] = Uint8List.fromList(dek);
  }

  @override
  Future<void> deleteDek(String uid) async {
    _store.remove(uid);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BackupServiceImpl (unit, error/guard paths)', () {
    const pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');
    late Directory tempRoot;

    setUp(() async {
      tempRoot = await Directory.systemTemp.createTemp('lockpass_backup_service_test_');

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        pathProviderChannel,
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
      // In widget/unit tests, FilePicker.platform is not initialized by default.
      FilePicker.platform = _FakeFilePicker(pickFilesResult: null);
    });

    tearDown(() async {
      FilePicker.platform = _FakeFilePicker(pickFilesResult: null);
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(pathProviderChannel, null);
      if (await tempRoot.exists()) {
        await tempRoot.delete(recursive: true);
      }
    });

    test('selectZipFile returns null when user cancels', () async {
      FilePicker.platform = _FakeFilePicker(pickFilesResult: null);
      final service = BackupServiceImpl(
        dbHelper: DataBaseHelper(),
        dekManager: DekManager(_InMemoryDekStore()),
      );

      final path = await service.selectZipFile();
      expect(path, isNull);
    });

    test('selectZipFile returns file path when user selects a zip', () async {
      FilePicker.platform = _FakeFilePicker(
        pickFilesResult: FilePickerResult([
          PlatformFile(name: 'a.zip', size: 1, path: '/tmp/a.zip'),
        ]),
      );
      final service = BackupServiceImpl(
        dbHelper: DataBaseHelper(),
        dekManager: DekManager(_InMemoryDekStore()),
      );

      final path = await service.selectZipFile();
      expect(path, '/tmp/a.zip');
    });

    test('createAutomaticBackup returns early when database file does not exist', () async {
      final service = BackupServiceImpl(
        dbHelper: DataBaseHelper(),
        dekManager: DekManager(_InMemoryDekStore()),
      );

      await service.createAutomaticBackup('uid');

      // No output file is created in this guard path.
      final autoZip = File('${tempRoot.path}/LPB_automatic.zip');
      expect(await autoZip.exists(), isFalse);
    });

    test('restoreManualBackup throws when zip path does not exist', () async {
      final service = BackupServiceImpl(
        dbHelper: DataBaseHelper(),
        dekManager: DekManager(_InMemoryDekStore()),
      );

      expect(
        () => service.restoreManualBackup(
          '${tempRoot.path}/missing.zip',
          'uid',
          exportPassword: 'pw',
        ),
        throwsA(
          isA<Exception>().having((e) => e.toString(), 'message', contains(CoreStrings.backupFileNotFound)),
        ),
      );
    });

    test('restoreAutomaticBackup throws when automatic zip does not exist', () async {
      final service = BackupServiceImpl(
        dbHelper: DataBaseHelper(),
        dekManager: DekManager(_InMemoryDekStore()),
      );

      expect(
        () => service.restoreAutomaticBackup('uid'),
        throwsA(
          isA<Exception>().having((e) => e.toString(), 'message', contains(CoreStrings.autoBackupNotFound)),
        ),
      );
    });
  });
}
