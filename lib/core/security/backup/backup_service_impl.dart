import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/paths/lockpass_paths.dart';
import 'package:lockpass/core/security/backup/backup_service.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/security/crypto/dek/wrapped_dek.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class BackupServiceImpl implements BackupService {
  BackupServiceImpl({
    required DataBaseHelper dbHelper,
    required DekManager dekManager,
  })  : _dbHelper = dbHelper,
        _dekManager = dekManager;

  final DataBaseHelper _dbHelper;
  final DekManager _dekManager;

  final AesGcm _aes = AesGcm.with256bits();

  static const _metaFileName = 'meta.json';
  static const _dataFileName = 'data.bin';
  static const _wrappedDekFileName = 'wrapped_dek.json';

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

    final backupFile = await _generateBackupZip(
      uid,
      isAutomatic: true,
    );

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
  Future<void> createManualBackup(
    String uid, {
    required String exportPassword,
  }) async {
    final zipFile = await _generateBackupZip(
      uid,
      isAutomatic: false,
      exportPassword: exportPassword,
    );

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
  Future<void> shareBackup(
    String uid, {
    required String exportPassword,
  }) async {
    final backupFile = await _generateBackupZip(
      uid,
      isAutomatic: false,
      exportPassword: exportPassword,
    );

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

  Future<File> _generateBackupZip(
    String uid, {
    required bool isAutomatic,
    String? exportPassword,
  }) async {
    final Directory dbDir = await LockPassPaths.dbDir;
    final File dbFile = File(p.join(dbDir.path, 'lockpass_itens.db'));
    var fileName = '';

    if (!await dbFile.exists()) {
      throw Exception(CoreStrings.databaseNotFound);
    }

    final Directory tempDir = await getTemporaryDirectory();

    final dbBytes = await dbFile.readAsBytes();
    final dek = await _dekManager.getOrCreateDek(uid);

    final nonce = _aes.newNonce();
    final box = await _aes.encrypt(
      dbBytes,
      secretKey: SecretKey(dek),
      nonce: nonce,
    );

    final combined = Uint8List.fromList([...box.cipherText, ...box.mac.bytes]);
    final File encryptedDataFile = File(p.join(tempDir.path, _dataFileName));
    await encryptedDataFile.writeAsBytes(combined);

    final meta = <String, dynamic>{
      'v': 1,
      'alg': 'aes-256-gcm',
      'nonceB64': base64Encode(nonce),
      'tagLen': box.mac.bytes.length,
      'userMask': EncryptDecrypt.generateUserMask(uid),
    };
    final File metaFile = File(p.join(tempDir.path, _metaFileName));
    await metaFile.writeAsString(jsonEncode(meta));

    File? wrappedDekFile;
    if (!isAutomatic) {
      if (exportPassword == null || exportPassword.trim().isEmpty) {
        throw Exception(CoreStrings.exportPasswordRequired);
      }
      final wrapped = await _dekManager.wrapDekForExport(
        uid: uid,
        exportPassword: exportPassword.trim(),
      );
      wrappedDekFile = File(p.join(tempDir.path, _wrappedDekFileName));
      await wrappedDekFile.writeAsString(jsonEncode(wrapped.toJson()));
    }

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
        files: [
          metaFile,
          if (wrappedDekFile != null) wrappedDekFile,
          encryptedDataFile,
        ],
        zipFile: zipFile,
        includeBaseDirectory: false,
      );
    } finally {
      if (encryptedDataFile.existsSync()) {
        await encryptedDataFile.delete();
      }
      if (metaFile.existsSync()) {
        await metaFile.delete();
      }
      if (wrappedDekFile != null && wrappedDekFile.existsSync()) {
        await wrappedDekFile.delete();
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
  Future<void> restoreManualBackup(
    String zipPath,
    String uid, {
    required String exportPassword,
  }) async {
    final zipFile = File(zipPath);

    if (!await zipFile.exists()) {
      throw Exception(CoreStrings.backupFileNotFound);
    }

    await _restoreFromZip(
      zipFile,
      uid,
      exportPassword: exportPassword,
    );
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

  Future<void> _restoreFromZip(
    File zipFile,
    String uid, {
    String? exportPassword,
  }) async {
    final Directory tempDir = await getTemporaryDirectory();

    try {
      await ZipFile.extractToDirectory(zipFile: zipFile, destinationDir: tempDir);

      final File metaFile = File(p.join(tempDir.path, _metaFileName));
      final File encryptedFile = File(p.join(tempDir.path, _dataFileName));

      if (!await metaFile.exists() || !await encryptedFile.exists()) {
        throw Exception(CoreStrings.invalidBackupFile);
      }

      if (exportPassword != null && exportPassword.trim().isNotEmpty) {
        final wrappedFile = File(p.join(tempDir.path, _wrappedDekFileName));
        if (!await wrappedFile.exists()) {
          throw Exception(CoreStrings.invalidBackupFile);
        }
        final wrappedJson = jsonDecode(await wrappedFile.readAsString()) as Map<String, dynamic>;
        final wrapped = WrappedDek.fromJson(wrappedJson);
        try {
          await _dekManager.importDekFromExport(
            uid: uid,
            wrapped: wrapped,
            exportPassword: exportPassword.trim(),
          );
        } catch (e) {
          if (e.toString().contains('INVALID_EXPORT_PASSWORD')) {
            throw Exception('INVALID_EXPORT_PASSWORD');
          }
          rethrow;
        }
      }

      final dek = await _dekManager.getOrCreateDek(uid);

      final meta = jsonDecode(await metaFile.readAsString()) as Map<String, dynamic>;
      final expectedUserMask = EncryptDecrypt.generateUserMask(uid);
      final userMask = meta['userMask'] as String?;
      if (userMask == null || userMask.isEmpty || userMask != expectedUserMask) {
        throw Exception('BACKUP_USER_MISMATCH');
      }
      final nonceB64 = meta['nonceB64'] as String?;
      if (nonceB64 == null || nonceB64.isEmpty) {
        throw Exception(CoreStrings.invalidBackupFile);
      }
      final nonce = base64Decode(nonceB64);

      final encryptedBytes = await encryptedFile.readAsBytes();
      if (encryptedBytes.length < 16) {
        throw Exception(CoreStrings.invalidBackupFile);
      }
      final cipherText = encryptedBytes.sublist(0, encryptedBytes.length - 16);
      final macBytes = encryptedBytes.sublist(encryptedBytes.length - 16);

      final secretBox = SecretBox(
        cipherText,
        nonce: nonce,
        mac: Mac(macBytes),
      );

      Uint8List decryptedBytes;
      try {
        final clear = await _aes.decrypt(
          secretBox,
          secretKey: SecretKey(dek),
        );
        decryptedBytes = Uint8List.fromList(clear);
      } catch (_) {
        // Se o restore é manual (senha informada), erro aqui é tipicamente senha errada.
        if (exportPassword != null && exportPassword.trim().isNotEmpty) {
          throw Exception('INVALID_EXPORT_PASSWORD');
        }
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
        if (await metaFile.exists()) {
          await metaFile.delete();
        }
        final wrappedPath = File(p.join(tempDir.path, _wrappedDekFileName));
        if (await wrappedPath.exists()) {
          await wrappedPath.delete();
        }
      }
    } catch (e) {
      throw Exception("${CoreStrings.restoreProcessError} $e");
    }
  }
}
