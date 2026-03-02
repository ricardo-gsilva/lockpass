import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class EncryptDecrypt {
  static final AesGcm _aes = AesGcm.with256bits();

  static Key _generateKeyFromUid(String uid) {
    final bytes = utf8.encode(uid);
    final digest = sha256.convert(bytes);
    return Key(Uint8List.fromList(digest.bytes));
  } 

  static String? encrypt(String text, String uid) {
    if (text.isEmpty) return "";
    try {
      final key = _generateKeyFromUid(uid);

      final iv = IV.fromSecureRandom(16);

      final encrypter = Encrypter(AES(key));
      final encrypted = encrypter.encrypt(text, iv: iv);
      return "${iv.base64}:${encrypted.base64}";
    } catch (e) {
      if (kDebugMode) debugPrint("Erro na criptografia: $e");
      return null;
    }
  }

  static String? decrypt(String combinedText, String uid) {
    if (combinedText.isEmpty) return "";
    try {
      final parts = combinedText.split(':');
      if (parts.length != 2) return null;

      final iv = IV.fromBase64(parts[0]);
      final encryptedData = Encrypted.fromBase64(parts[1]);

      final key = _generateKeyFromUid(uid);
      final encrypter = Encrypter(AES(key));

      return encrypter.decrypt(encryptedData, iv: iv);
    } catch (e) {
      if (kDebugMode) debugPrint("Erro na descriptografia: $e");
      return null;
    }
  }

  static Key _deriveSecureKey(String uid, Uint8List salt) {
    var hash = sha256.convert([...utf8.encode(uid), ...salt]).bytes;

    for (var i = 0; i < 1000; i++) {
      hash = sha256.convert([...hash, ...salt]).bytes;
    }
    return Key(Uint8List.fromList(hash));
  }

  static Uint8List? encryptFile(Uint8List fileBytes, String uid) {
    try {
      final salt = IV.fromSecureRandom(16).bytes;
      final key = _deriveSecureKey(uid, salt);
      final iv = IV.fromSecureRandom(16);

      final encrypter = Encrypter(AES(key));
      final encrypted = encrypter.encryptBytes(fileBytes, iv: iv);

      final result = BytesBuilder();
      result.add(salt);
      result.add(iv.bytes);
      result.add(encrypted.bytes);

      return result.toBytes();
    } catch (e) {
      if (kDebugMode) debugPrint("Erro ao criptografar backup: $e");
      return null;
    }
  }

  static Uint8List? decryptFile(Uint8List encryptedFileBytes, String uid) {
    try {
      final salt = encryptedFileBytes.sublist(0, 16);

      final iv = IV(encryptedFileBytes.sublist(16, 32));

      final encryptedData = encryptedFileBytes.sublist(32);

      final key = _deriveSecureKey(uid, salt);

      final encrypter = Encrypter(AES(key));
      final decrypted = encrypter.decryptBytes(Encrypted(encryptedData), iv: iv);

      return Uint8List.fromList(decrypted);
    } catch (e) {
      if (kDebugMode) debugPrint("Erro ao restaurar backup: $e");
      return null;
    }
  }

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
