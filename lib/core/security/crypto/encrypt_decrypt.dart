import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class EncryptDecrypt {
  static Key _generateKeyFromUid(String uid) {
    final bytes = utf8.encode(uid);
    final digest = sha256.convert(bytes);
    return Key(Uint8List.fromList(digest.bytes));
  }

  static String encrypt(String text, String uid) {
    if (text.isEmpty) return "";

    try {
      final key = _generateKeyFromUid(uid);
      final ivString =
          uid.length >= 16 ? uid.substring(0, 16) : uid.padRight(16, '0');
      final iv = IV.fromUtf8(ivString);

      final encrypter = Encrypter(AES(key));
      return encrypter.encrypt(text, iv: iv).base64;
    } catch (e) {
      return text;
    }
  }

  static String decrypt(String encryptedBase64, String uid) {
    if (encryptedBase64.isEmpty) return "";

    try {
      final key = _generateKeyFromUid(uid);
      final iv = IV.fromUtf8(uid.substring(0, 16));
      final encrypter = Encrypter(AES(key));

      return encrypter.decrypt(Encrypted.fromBase64(encryptedBase64), iv: iv);
    } catch (e) {
      return encryptedBase64;
    }
  }

  Future<bool> isolateUnzip(String pinDecrypt, String zipPath) async {
    final dir = await getApplicationSupportDirectory();

    final responsePort = ReceivePort();
    final initPort = ReceivePort();

    await Isolate.spawn(isolateUnzipRestore, initPort.sendPort);

    final SendPort isolatePort = await initPort.first;

    isolatePort.send({
      'replyPort': responsePort.sendPort,
      'pinDecrypt': pinDecrypt,
      'zipPath': zipPath,
      'outputDir': dir.path,
    });

    return await responsePort.first as bool;
  }

  Future<bool> isolateUnzip1(String pinDescrypt, File zipFile) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var isolateListenner = ReceivePort();
    var port = ReceivePort();

    await Isolate.spawn(isolateLogic1, port.sendPort);
    SendPort portNewIsolate = await port.first;

    portNewIsolate.send({
      'isolate': isolateListenner.sendPort,
      'pinDescrypt': pinDescrypt,
      'zipFile': zipFile,
      'directory': directory
    });

    return await isolateListenner.first;
  }

  static void isolateUnzipRestore(SendPort mainPort) {
    final isolatePort = ReceivePort();
    mainPort.send(isolatePort.sendPort);

    isolatePort.listen((message) async {
      final SendPort replyPort = message['replyPort'];
      final String zipPath = message['zipPath'];
      final String outputDir = message['outputDir'];
      final String pinDecrypt = message['pinDecrypt'];

      try {
        final zipFile = File(zipPath);
        final bytes = await zipFile.readAsBytes();

        final archive = ZipDecoder().decodeBytes(
          bytes,
          password: pinDecrypt.isEmpty ? null : pinDecrypt,
        );

        for (final file in archive) {
          final filePath = '$outputDir/${file.name}';

          if (file.isFile) {
            final outFile = File(filePath);
            await outFile.create(recursive: true);
            await outFile.writeAsBytes(file.content as List<int>);
          } else {
            await Directory(filePath).create(recursive: true);
          }
        }

        replyPort.send(true);
      } catch (e) {
        replyPort.send(false);
      }
    });
  }

  static isolateLogic1(SendPort message) {
    var isolatePrivatePort = ReceivePort();
    message.send(isolatePrivatePort.sendPort);

    isolatePrivatePort.listen((message) {
      var externalIsolate = message['isolate'];
      String pinDescrypt = message['pinDescrypt'];
      File zipFile = message['zipFile'];
      Directory directory = message['directory'];
      externalIsolate.send(unZiped(pinDescrypt, zipFile, directory));
    });
  }

  static bool unZiped(String pinDescrypt, File zipFile, Directory directory) {
    try {
      final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync(),
          password: pinDescrypt.isEmpty ? null : pinDescrypt);
      for (final file in archive) {
        if (file.isFile) {
          final data = file.content as List<int>?;
          File('${directory.path}_itens.db')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data!);
        } else {
          Directory('${directory.path}_itens.db').create(recursive: true);
        }
      }
      return true;
    } catch (e) {
      e.toString();
      return false;
    }
  }

  Future<bool> isolateCreateZip1(
    String zipPath,
    String dbPath,
    String pinDecrypt,
  ) async {
    final receivePort = ReceivePort();

    await Isolate.spawn(
      isolateLogicCreateZip1,
      receivePort.sendPort,
    );

    final sendPort = await receivePort.first as SendPort;

    final responsePort = ReceivePort();

    sendPort.send({
      'replyTo': responsePort.sendPort,
      'zipPath': zipPath,
      'dbPath': dbPath,
      'pin': pinDecrypt,
    });

    return await responsePort.first as bool;
  }

  static void isolateLogicCreateZip1(SendPort initialPort) {
    final isolatePort = ReceivePort();
    initialPort.send(isolatePort.sendPort);

    isolatePort.listen((message) {
      final SendPort replyTo = message['replyTo'];
      final String zipPath = message['zipPath'];
      final String dbPath = message['dbPath'];
      final String pinDecrypt = message['pin'];

      final result = createZipFile1(
        zipPath,
        dbPath,
        pinDecrypt,
      );

      replyTo.send(result);
    });
  }

  static bool createZipFile1(
    String zipPath,
    String dbPath,
    String pinDecrypt,
  ) {
    try {
      final pin = int.tryParse(pinDecrypt) ?? 0;

      final encoder = ZipFileEncoder(
        password: pin > 0 ? pin.toString() : null,
      );

      encoder.create(zipPath);
      encoder.addFile(File(dbPath));
      encoder.close();

      final exists = File(zipPath).existsSync();

      return exists;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isolateCreateZip(
      String path, String pinDecrypt, String type) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var isolateListenner = ReceivePort();
    var port = ReceivePort();

    await Isolate.spawn(isolateLogicCreateZip, port.sendPort);
    SendPort portNewIsolate = await port.first;

    portNewIsolate.send({
      'isolate': isolateListenner.sendPort,
      'path': path,
      'type': type,
      'pinDecrypt': pinDecrypt,
      'directory': directory
    });

    return await isolateListenner.first;
  }

  static void isolateLogicCreateZip(SendPort message) {
    var isolatePrivatePort = ReceivePort();
    message.send(isolatePrivatePort.sendPort);

    isolatePrivatePort.listen((message) {
      var externalIsolate = message['isolate'];
      String pinDecrypt = message['pinDecrypt'];
      String path = message['path'];
      String type = message['type'];
      Directory directory = message['directory'];
      externalIsolate.send(createZipFile(path, pinDecrypt, directory, type));
    });
  }

  static bool createZipFile(
      String path, String pinDecrypt, Directory directory, String type) {
    try {
      final pin = int.tryParse(pinDecrypt) ?? 0;
      final encoder = ZipFileEncoder(password: pin > 0 ? pin.toString() : null);

      final pathSave = Platform.isAndroid
          ? '$path/LockPass/lockpass_db_$type.zip'
          : '$path/lockpass_db_$type.zip';

      encoder.create(pathSave);
      encoder.addFile(File(path));
      encoder.close();

      final zipFile = File(pathSave);
      final exists = zipFile.existsSync();

      return exists;
    } catch (e) {
      e.toString();
      return false;
    }
  }
}
