import 'dart:typed_data';

abstract class SecureStorageDekStore {
  Future<Uint8List?> readDek(String uid);
  Future<void> writeDek(String uid, Uint8List dek);
  Future<void> deleteDek(String uid);
}