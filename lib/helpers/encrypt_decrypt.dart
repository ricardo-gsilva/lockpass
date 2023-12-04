import 'dart:io';
import 'dart:isolate';

import 'package:aespack/aespack.dart';
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';

class EncryptDecrypt {
  
static decrypt(String pass) async{
    if (pass.isEmpty) {
      return "0";
    } else {
      String key = '0102030405060708';
      String iv = '1112131415161718';
      return await Aespack.decrypt(pass, key, iv) ?? 'Falha ao descriptografar a senha.';  
    }    
  }

static encrypted(String pass) async {
    String key = '0102030405060708';
    String iv = '1112131415161718';
    return await Aespack.encrypt(pass, key, iv) ?? '';
  }

Future<bool> isolateUnzip(String pinDescrypt, File zipFile) async {
  Directory directory = await getApplicationDocumentsDirectory();
    var isolateListenner = ReceivePort();
    var port = ReceivePort();

    await Isolate.spawn(isolateLogic, port.sendPort);
    SendPort portNewIsolate = await port.first;

    portNewIsolate.send(
      {'isolate': isolateListenner.sendPort,
      'pinDescrypt': pinDescrypt,
      'zipFile': zipFile,
      'directory': directory}
    );
    
    return await isolateListenner.first;
  }

  static isolateLogic(SendPort message){
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
      final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync(), password: pinDescrypt.isEmpty? null : pinDescrypt);
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

  Future<bool> isolateCreateZip(String path, String pinDecrypt, String type) async {
    Directory directory = await getApplicationDocumentsDirectory();
    var isolateListenner = ReceivePort();
    var port = ReceivePort();

    await Isolate.spawn(isolateLogicCreateZip, port.sendPort);
    SendPort portNewIsolate = await port.first;

    portNewIsolate.send(
      {'isolate': isolateListenner.sendPort,
      'path': path,
      'type': type,
      'pinDecrypt': pinDecrypt,
      'directory': directory}
    );
    
    return await isolateListenner.first;
  }

  static isolateLogicCreateZip(SendPort message){
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

  static bool createZipFile(String path, String pinDecrypt, Directory directory, String type) {
    try {
      int pin = 0;
      String pathSave = '';
      pin = int.parse(pinDecrypt);
      String pathDb = '${directory.path}_itens.db';
      var encoder = ZipFileEncoder(password: pin == 0 ? null : pin.toString());
      if(Platform.isAndroid){
        pathSave = '$path/LockPass/lockpass_db_$type.zip';
      } else {
        pathSave = '$path/lockpass_db_$type.zip';
      }
      encoder.create(pathSave);
      encoder.addFile(File(pathDb));
      encoder.close();
      return true;
    } catch (e) {
      e.toString();
      return false;
    }
  }
}