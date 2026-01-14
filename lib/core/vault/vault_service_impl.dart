import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:lockpass/core/vault/vault_service.dart';
import 'package:lockpass/database/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VaultServiceImpl implements VaultService {
  SharedPrefs? _sharedPrefs;
  String? _storagePath;

  void ensureInitialized() {
    if (_sharedPrefs == null) {
      throw StateError('VaultService not initialized. Call init() first.');
    }
  }

  @override
  Future<void> initializeVaultEnvironment() async{
    await initializePreferences();
    final hasPermission = await hasStoragePermission();
    if (!hasPermission) {
      await requestStoragePermission();
    }
    await getStoragePath();
  }
    
  @override
  Future<void> initializePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _sharedPrefs = SharedPrefs(sharedPreferences: prefs);
  }
  
  @override
  Future<void> createVault(String pin) {
    // TODO: implement createVault
    throw UnimplementedError();
  }

  @override
  Future<String> getDecryptedPin() {
    // TODO: implement getDecryptedPin
    throw UnimplementedError();
  }

  @override
  Future<String> getStoragePath() async {
    ensureInitialized();
    if (_storagePath != null) return _storagePath!;

    if (Platform.isAndroid) {
      _storagePath = await AndroidPathProvider.downloadsPath;
    } else {
      final dir = await getApplicationDocumentsDirectory();
      _storagePath = dir.path;
    }

    return _storagePath!;
  }

  @override
  Future<bool> hasPin() {
    // TODO: implement hasPin
    throw UnimplementedError();
  }

  @override
  Future<bool> hasStoragePermission() async {
    // Se for Android, verifica permissão de storage
    if (Platform.isAndroid) {
      return await Permission.storage.isGranted;
    }
    // iOS, Web, Desktop → não exigem permissão
    return true;
  }

  @override
  Future<void> requestStoragePermission() async {
    // Apenas Android exige permissão explícita
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }
  }
  
  @override
  Future<bool> verifyPin(String pin) {
    // TODO: implement verifyPin
    throw UnimplementedError();
  }


//    @override
//   Future<String> getStoragePath() async {
//     // LoginStore: Android downloadsPath, iOS documents directory
//     if (Platform.isAndroid) {
//       return AndroidPathProvider.downloadsPath;
//     } else {
//       final dir = await getApplicationDocumentsDirectory();
//       return dir.path;
//     }
//   }

  // @override
  // Future<bool> hasStoragePermission() async {
  //   // OBS: no Android mais novo isso muda (READ_MEDIA_*), mas vamos manter igual seu app por enquanto
  //   if (Platform.isIOS) {
  //     // iOS normalmente não precisa "storage" pra documents directory,
  //     // mas se você quer manter a flag, ok:
  //     return Permission.storage.isGranted;
  //   } else {
  //     return Permission.storage.isGranted;
  //   }
  // }

//   @override
//   Future<void> requestStoragePermission() async {
//     _ensureInitialized();

//     final status = await Permission.storage.request();
//     _sharedPrefs!.setPermissionStorage(status.isGranted);
//   }

//   @override
//   Future<bool> hasPin() async {
//     _ensureInitialized();

//     final encryptedPin = _sharedPrefs!.getPin() ?? '';
//     return encryptedPin.isNotEmpty;
//   }

//   @override
//   Future<String> getDecryptedPin() async {
//     _ensureInitialized();

//     final encryptedPin = _sharedPrefs!.getPin() ?? '';
//     if (encryptedPin.isEmpty) return '0';

//     return EncryptDecrypt.decrypt(encryptedPin);
//   }

//   @override
//   Future<bool> verifyPin(String pin) async {
//     _ensureInitialized();

//     final encryptedPin = _sharedPrefs!.getPin() ?? '';
//     if (encryptedPin.isEmpty) return false;

//     final decrypted = await EncryptDecrypt.decrypt(encryptedPin);
//     return decrypted == pin;
//   }

//   @override
//   Future<void> createVault(String pin) async {
//     // Esse método representa a parte do seu login:
//     // EncryptDecrypt().isolateCreateZip(path, pin, CoreStrings.automatic)

//     final path = await getStoragePath();

//     // Se você quer garantir permissão (Android):
//     if (Platform.isAndroid) {
//       final hasPerm = await hasStoragePermission();
//       if (!hasPerm) {
//         await requestStoragePermission();
//       }
//     }

//     final ok = await EncryptDecrypt().isolateCreateZip(
//       path,
//       pin,
//       CoreStrings.automatic,
//     );

//     if (!ok) {
//       throw Exception('Failed to create vault zip.');
//     }
//   }
// }
  
}