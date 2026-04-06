import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class EncryptDecrypt {
  static final AesGcm _aes = AesGcm.with256bits();

  static String generateUserMask(String uid) {
    var bytes = utf8.encode(uid);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<String> encryptInformation({
    required String plainText,
    required Uint8List dek,
  }) async {
    if (plainText.isEmpty) return '';

    final nonce = _randomNonce();
    final box = await _aes.encrypt(
      utf8.encode(plainText),
      secretKey: SecretKey(dek),
      nonce: nonce,
    );

    final payload = base64Encode(Uint8List.fromList([
      ...nonce,
      ...box.cipherText,
      ...box.mac.bytes,
    ]));

    return payload;
  }

  static Future<String?> decryptInformation({
    required String payloadB64,
    required Uint8List dek,
  }) async {
    if (payloadB64.isEmpty) return '';

    final bytes = base64Decode(payloadB64);
    if (bytes.length < 12 + 16) return null;

    final nonce = bytes.sublist(0, 12);
    final macBytes = bytes.sublist(bytes.length - 16);
    final cipherText = bytes.sublist(12, bytes.length - 16);

    final box = SecretBox(
      cipherText,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    final clear = await _aes.decrypt(
      box,
      secretKey: SecretKey(dek),
    );

    return utf8.decode(clear);
  }

  static Uint8List _randomNonce() {
    return Uint8List.fromList(_aes.newNonce());
  }
}
