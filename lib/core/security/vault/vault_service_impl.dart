import 'dart:io';

import 'package:flutter_archive/flutter_archive.dart';
import 'package:lockpass/core/paths/lockpass_paths.dart';
import 'package:lockpass/core/security/vault/vault_service.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class VaultServiceImpl implements VaultService {
  final SharedPreferencesDatasource _sharedPrefs;
  final DataBaseHelper _dbHelper;

  VaultServiceImpl({
    required SharedPreferencesDatasource sharedPrefs,
    required DataBaseHelper dbHelper,
  })  : _dbHelper = dbHelper,
        _sharedPrefs = sharedPrefs;

  @override
  Future<void> initializeVaultEnvironment() async {
    final hasPermission = await hasStoragePermission();
    if (!hasPermission) {
      await requestStoragePermission();
    }
  }

  @override
  Future<void> clearUserPreferences() async {
    await _sharedPrefs.clearUserData();
  }

  @override
  Future<SharedPreferencesDatasource> prefs() async {
    return _sharedPrefs;
  }

  @override
  Future<void> resetCreatePinInfo() async {
    await _sharedPrefs.setVisibleCreatePinInfo(false);
  }

  @override
  Future<bool> hasStoragePermission() async {
    if (!Platform.isAndroid) return true;
    final granted = await Permission.storage.isGranted;
    await _sharedPrefs.setPermissionStorage(granted);
    return granted;
  }

  @override
  Future<void> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      _sharedPrefs.setPermissionStorage(status.isGranted);
    }
  }

  @override
  Future<bool> getHideCreatePinInfo() async {
    return _sharedPrefs.getVisibleCreatePinInfo();
  }

  @override
  Future<void> setHideCreatePinInfo(bool value) async {
    _sharedPrefs.setVisibleCreatePinInfo(value);
  }

  @override
  Future<void> createAutomaticBackup() async {
    try {
      final dbDir = await LockPassPaths.dbDir;
      final dbFile = File(p.join(dbDir.path, 'lockpass_itens.db'));
      if (await dbFile.exists()) {
        final appDir = await getApplicationDocumentsDirectory();
        final backupFile = File(p.join(appDir.path, 'LPB_automatic.zip'));

        if (await backupFile.exists()) {
          await backupFile.delete();
        }

        await ZipFile.createFromDirectory(
          sourceDir: dbDir,
          zipFile: backupFile,
        );
      }
    } catch (_) {}
  }

  @override
  Future<void> importAutomaticBackup() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupFile = File(p.join(directory.path, 'LPB_automatic.zip'));

    if (!await backupFile.exists()) {
      throw Exception("Nenhum backup automático encontrado.");
    }

    final destinationDir = await LockPassPaths.dbDir;

    final dbFileAtual = File(p.join(destinationDir.path, 'lockpass_itens.db'));
    final dbFileBackup =
        File(p.join(destinationDir.path, 'lockpass_itens.db.bak'));

    await _dbHelper.closeDatabase();

    if (await dbFileAtual.exists()) {
      if (await dbFileBackup.exists()) await dbFileBackup.delete();
      await dbFileAtual.rename(dbFileBackup.path);
    }

    await ZipFile.extractToDirectory(
      zipFile: backupFile,
      destinationDir: destinationDir,
    );

    await _dbHelper.database;

    if (await dbFileBackup.exists()) {
      await dbFileBackup.delete();
    }
  }

  @override
  Future<void> importManualBackup(String zipPath) async {
    final Directory destinationDir = await LockPassPaths.dbDir;
    final File dbFileAtual =
        File(p.join(destinationDir.path, 'lockpass_itens.db'));
    final File dbFileBackup =
        File(p.join(destinationDir.path, 'lockpass_itens.db.bak'));

    try {
      await _dbHelper.closeDatabase();

      if (await dbFileAtual.exists()) {
        if (await dbFileBackup.exists()) {
          await dbFileBackup.delete();
        }
        await dbFileAtual.rename(dbFileBackup.path);
      }

      await ZipFile.extractToDirectory(
        zipFile: File(zipPath),
        destinationDir: destinationDir,
      );

      await _dbHelper.database;

      if (await dbFileBackup.exists()) {
        await dbFileBackup.delete();
      }
    } catch (e) {
      if (await dbFileBackup.exists()) {
        if (await dbFileAtual.exists()) {
          await dbFileAtual.delete();
        }
        await dbFileBackup.rename(dbFileAtual.path);
      }
      rethrow;
    }
  }

  @override
  Future<File> generateBackupZip() async {
    final Directory dbDir = await LockPassPaths.dbDir;
    final File dbFile = File(p.join(dbDir.path, 'lockpass_itens.db'));

    if (!await dbFile.exists()) {
      throw Exception("Database file not found.");
    }

    final fileName = _generateListItensFileName();
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = p.join(tempDir.path, fileName);
    final zipFile = File(tempPath);

    await ZipFile.createFromFiles(
      sourceDir: dbDir,
      files: [dbFile],
      zipFile: zipFile,
      includeBaseDirectory: false,
    );

    return zipFile;
  }

  String _generateListItensFileName() {
    final now = DateTime.now();

    final date =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';

    final time = '${now.hour.toString().padLeft(2, '0')}-'
        '${now.minute.toString().padLeft(2, '0')}-'
        '${now.second.toString().padLeft(2, '0')}';

    return 'LPB_${date}_$time.zip';
  }

  @override
  Future<void> shareManualBackup() async {
    final dbDir = await LockPassPaths.dbDir;

    final tempDir = await getTemporaryDirectory();
    final backupFile = File(
      p.join(tempDir.path, 'LPB_share_backup.zip'),
    );

    if (await backupFile.exists()) {
      await backupFile.delete();
    }

    await ZipFile.createFromDirectory(
      sourceDir: dbDir,
      zipFile: backupFile,
    );

    await Share.shareXFiles(
      [XFile(backupFile.path)],
      text: "Backup da lista de logins - LockPass",
    );

    if (await backupFile.exists()) {
      await backupFile.delete();
    }
  }
}
