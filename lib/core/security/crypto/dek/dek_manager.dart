import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'secure_storage/secure_storage_dek_store.dart';
import '../kdf/kdf.dart';
import 'wrapped_dek.dart';

class DekManager {
  final SecureStorageDekStore _store;
  final AesGcm _aes = AesGcm.with256bits();

  DekManager(this._store);

  Future<Uint8List> getOrCreateDek(String uid) async {
    final existing = await _store.readDek(uid);
    if (existing != null && existing.length == 32) return existing;

    final dek = Uint8List(32);
    final rnd = Random.secure();
    for (var i = 0; i < dek.length; i++) {
      dek[i] = rnd.nextInt(256);
    }

    await _store.writeDek(uid, dek);
    return dek;
  }

  Future<WrappedDek> wrapDekForExport({
    required String uid,
    required String exportPassword,
  }) async {
    final dek = await getOrCreateDek(uid);

    final salt = _randomBytes(16);
    final kek = await Kdf.deriveKek(secret: exportPassword, salt: salt);

    final nonce = _randomBytes(12);
    final secretBox = await _aes.encrypt(
      dek,
      secretKey: SecretKey(kek),
      nonce: nonce,
    );

    final combined = Uint8List.fromList([...secretBox.cipherText, ...secretBox.mac.bytes]);

    return WrappedDek(
      saltB64: base64Encode(salt),
      nonceB64: base64Encode(nonce),
      ciphertextB64: base64Encode(combined),
    );
  }

  Future<void> importDekFromExport({
    required String uid,
    required WrappedDek wrapped,
    required String exportPassword,
  }) async {
    final salt = base64Decode(wrapped.saltB64);
    final nonce = base64Decode(wrapped.nonceB64);
    final combined = base64Decode(wrapped.ciphertextB64);

    final kek = await Kdf.deriveKek(secret: exportPassword, salt: salt);

    // separa cipherText e mac (últimos 16 bytes = tag do GCM)
    if (combined.length < 16) {
      throw Exception('INVALID_WRAPPED_DEK');
    }
    final cipherText = combined.sublist(0, combined.length - 16);
    final macBytes = combined.sublist(combined.length - 16);

    final secretBox = SecretBox(
      cipherText,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    final dek = await _aes.decrypt(
      secretBox,
      secretKey: SecretKey(kek),
    );

    final dekBytes = Uint8List.fromList(dek);
    if (dekBytes.length != 32) throw Exception('INVALID_DEK');

    await _store.writeDek(uid, dekBytes);
  }

  Uint8List _randomBytes(int length) {
    final rnd = Random.secure();
    final out = Uint8List(length);
    for (var i = 0; i < length; i++) {
      out[i] = rnd.nextInt(256);
    }
    return out;
  }
}