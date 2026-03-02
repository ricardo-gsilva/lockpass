import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'secure_storage_dek_store.dart';

class SecureStorageDekStoreImpl implements SecureStorageDekStore {
  final FlutterSecureStorage _storage;
  SecureStorageDekStoreImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  String _key(String uid) => 'dek_b64_$uid';

  @override
  Future<Uint8List?> readDek(String uid) async {
    final b64 = await _storage.read(key: _key(uid));
    if (b64 == null || b64.isEmpty) return null;
    return base64Decode(b64);
  }

  @override
  Future<void> writeDek(String uid, Uint8List dek) async {
    await _storage.write(key: _key(uid), value: base64Encode(dek));
  }

  @override
  Future<void> deleteDek(String uid) async {
    await _storage.delete(key: _key(uid));
  }
}