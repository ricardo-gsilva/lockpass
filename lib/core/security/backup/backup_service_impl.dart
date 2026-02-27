import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/paths/lockpass_paths.dart';
import 'package:lockpass/core/security/backup/backup_service.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupServiceImpl implements BackupService {
  final DataBaseHelper _dbHelper;

  BackupServiceImpl({
    required DataBaseHelper dbHelper,
  }) : _dbHelper = dbHelper;

  @override
  Future<String?> selectZipFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['zip'],
      allowMultiple: false,
    );

    final file = result?.files.single;
    return file?.path;
  }

  @override
  Future<void> createAutomaticBackup(String uid) async {
    final dbDir = await LockPassPaths.dbDir;
    final dbFile = File(p.join(dbDir.path, 'lockpass_itens.db'));

    if (!await dbFile.exists()) {
      return;
    }

    final backupFile = await _generateBackupZip(uid, isAutomatic: true);

    final appDir = await getApplicationDocumentsDirectory();
    final finalPath = p.join(appDir.path, 'LPB_automatic.zip');
    final finalFile = File(finalPath);

    if (await finalFile.exists()) {
      await finalFile.delete();
    }

    await backupFile.copy(finalPath);

    await backupFile.delete();
  }

  @override
  Future<void> createManualBackup(String uid) async {
    final zipFile = await _generateBackupZip(uid, isAutomatic: false);

    final savedPath = await FilePicker.platform.saveFile(
      dialogTitle: CoreStrings.saveBackupLocationPrompt,
      fileName: p.basename(zipFile.path),
      type: FileType.custom,
      allowedExtensions: ['zip'],
      bytes: await zipFile.readAsBytes(),
    );

    if (savedPath == null) {
      throw Exception(CoreStrings.exportCancelled);
    }

    if (await zipFile.exists()) {
      await zipFile.delete();
    }
  }

  @override
  Future<void> shareBackup(String uid) async {
    final backupFile = await _generateBackupZip(uid, isAutomatic: false);

    try {
      await Share.shareXFiles(
        [XFile(backupFile.path)],
        text: CoreStrings.backupFileHeader,
      );
    } finally {
      if (await backupFile.exists()) {
        await backupFile.delete();
      }
    }
  }

  Future<File> _generateBackupZip(String uid, {required bool isAutomatic}) async {
    final Directory dbDir = await LockPassPaths.dbDir;
    final File dbFile = File(p.join(dbDir.path, 'lockpass_itens.db'));
    var fileName = '';

    if (!await dbFile.exists()) {
      throw Exception(CoreStrings.databaseNotFound);
    }

    final Directory tempDir = await getTemporaryDirectory();

    final dbBytes = await dbFile.readAsBytes();
    final encryptedBytes = EncryptDecrypt.encryptFile(dbBytes, uid);

    if (encryptedBytes == null) {
      throw Exception(CoreStrings.encryptionBackupError);
    }

    final File encryptedDataFile = File(p.join(tempDir.path, 'data.bin'));
    await encryptedDataFile.writeAsBytes(encryptedBytes);

    if (isAutomatic) {
      fileName = 'LPB_automatic.zip';
    } else {
      fileName = _generateFileName();
    }

    final String zipPath = p.join(tempDir.path, fileName);
    final zipFile = File(zipPath);

    try {
      await ZipFile.createFromFiles(
        sourceDir: tempDir,
        files: [encryptedDataFile],
        zipFile: zipFile,
        includeBaseDirectory: false,
      );
    } finally {
      if (encryptedDataFile.existsSync()) {
        await encryptedDataFile.delete();
      }
    }
    return zipFile;
  }

  String _generateFileName() {
    final now = DateTime.now();

    final date = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

    final time = '${now.hour.toString().padLeft(2, '0')}-'
        '${now.minute.toString().padLeft(2, '0')}-'
        '${now.second.toString().padLeft(2, '0')}';

    return 'LPB_${date}_$time.zip';
  }

  @override
  Future<void> restoreManualBackup(String zipPath, String uid) async {
    final zipFile = File(zipPath);

    if (!await zipFile.exists()) {
      throw Exception(CoreStrings.backupFileNotFound);
    }

    await _restoreFromZip(zipFile, uid);
  }

  @override
  Future<void> restoreAutomaticBackup(String uid) async {
    final directory = await getApplicationDocumentsDirectory();
    final backupFile = File(p.join(directory.path, 'LPB_automatic.zip'));

    if (!await backupFile.exists()) {
      throw Exception(CoreStrings.autoBackupNotFound);
    }

    await _restoreFromZip(backupFile, uid);
  }

  Future<void> _restoreFromZip(File zipFile, String uid) async {
    final Directory tempDir = await getTemporaryDirectory();

    try {
      await ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: tempDir);

      final File encryptedFile = File(p.join(tempDir.path, 'data.bin'));

      if (!await encryptedFile.exists()) {
        throw Exception(CoreStrings.invalidBackupFile);
      }

      final encryptedBytes = await encryptedFile.readAsBytes();
      final decryptedBytes = EncryptDecrypt.decryptFile(encryptedBytes, uid);

      if (decryptedBytes == null) {
        throw Exception(CoreStrings.decryptionBackupError);
      }

      final Directory dbDir = await LockPassPaths.dbDir;
      final File dbFile = File(p.join(dbDir.path, 'lockpass_itens.db'));
      final File backupOldDb = File(p.join(dbDir.path, 'lockpass_itens.db.bak'));

      if (await dbFile.exists()) {
        await dbFile.copy(backupOldDb.path);
      }

      try {
        await _dbHelper.replaceDatabase(decryptedBytes);
      } catch (e) {
        throw Exception("${CoreStrings.replaceDatabaseError} $e");
      } finally {
        if (await encryptedFile.exists()) {
          await encryptedFile.delete();
        }
      }
    } catch (e) {
      throw Exception("${CoreStrings.restoreProcessError} $e");
    }
  }
}
