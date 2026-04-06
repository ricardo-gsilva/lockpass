import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'pin_service.dart';

class PinServiceImpl implements PinService {
  final FlutterSecureStorage _storage;
  final Pbkdf2 _pbkdf2;

  PinServiceImpl({
    FlutterSecureStorage? storage,
    Pbkdf2? pbkdf2,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _pbkdf2 = pbkdf2 ??
            Pbkdf2(
              macAlgorithm: Hmac.sha256(),
              iterations: 150000,
              bits: 256,
            );

  String _pinKey(String userId) => 'pin_hash_$userId';

  static const String _v2Prefix = 'v2\$pbkdf2-sha256';

  @override
  Future<bool> hasPin(String userId) async {
    final pin = await _storage.read(key: _pinKey(userId));
    return pin != null && pin.isNotEmpty;
  }

  @override
  Future<String?> getPin(String userId) async {
    return await _storage.read(key: _pinKey(userId));
  }

  @override
  Future<void> savePin(String userId, String pin) async {
    final salt = _randomBytes(16);
    final dk = await _derive(pin: pin, salt: salt);
    final value = _serializeV2(
      salt: salt,
      dk: dk,
      iterations: _pbkdf2.iterations,
    );
    await _storage.write(key: _pinKey(userId), value: value);
  }

  @override
  Future<bool> validatePin(String userId, String inputPin) async {
    final saved = await _storage.read(key: _pinKey(userId));
    if (saved == null || saved.isEmpty) return false;

    final parsed = _parseV2(saved);
    if (parsed == null) return false;

    final dk = await _derive(
      pin: inputPin,
      salt: parsed.salt,
      iterationsOverride: parsed.iterations,
    );
    return _constantTimeEquals(dk, parsed.dk);
  }

  @override
  Future<void> removePin(String userId) async {
    await _storage.delete(key: _pinKey(userId));
  }

  Future<Uint8List> _derive({
    required String pin,
    required Uint8List salt,
    int? iterationsOverride,
  }) async {
    final pbkdf2 = iterationsOverride == null
        ? _pbkdf2
        : Pbkdf2(
            macAlgorithm: Hmac.sha256(),
            iterations: iterationsOverride,
            bits: 256,
          );

    final key = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
    final bytes = await key.extractBytes();
    return Uint8List.fromList(bytes);
  }

  Uint8List _randomBytes(int length) {
    final rnd = Random.secure();
    final out = Uint8List(length);
    for (var i = 0; i < out.length; i++) {
      out[i] = rnd.nextInt(256);
    }
    return out;
  }

  String _serializeV2({
    required Uint8List salt,
    required Uint8List dk,
    required int iterations,
  }) {
    final saltB64 = base64Encode(salt);
    final dkB64 = base64Encode(dk);
    return '$_v2Prefix\$$iterations\$$saltB64\$$dkB64';
  }

  ({int iterations, Uint8List salt, Uint8List dk})? _parseV2(String value) {
    // v2$pbkdf2-sha256$<iterations>$<salt_b64>$<dk_b64>
    final parts = value.split('\$');
    if (parts.length != 5) return null;
    final prefix = '${parts[0]}\$${parts[1]}';
    if (prefix != _v2Prefix) return null;

    final iterations = int.tryParse(parts[2]);
    if (iterations == null || iterations < 10000) return null;

    try {
      final salt = base64Decode(parts[3]);
      final dk = base64Decode(parts[4]);
      if (salt.length < 16 || dk.length != 32) return null;
      return (iterations: iterations, salt: Uint8List.fromList(salt), dk: Uint8List.fromList(dk));
    } catch (_) {
      return null;
    }
  }

  bool _constantTimeEquals(Uint8List a, Uint8List b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}
