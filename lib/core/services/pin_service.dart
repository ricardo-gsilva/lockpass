import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class PinService {
  String _pinKey(String userId) => 'pin_hash_$userId';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Existe PIN?
  Future<bool> hasPin() async {
    final keys = await _storage.readAll();
    return keys.keys.any((k) => k.startsWith('pin_hash_'));
  }

  /// Pegar PIN
  Future<String?> getPin(String userId) async {
    return await _storage.read(key: _pinKey(userId))?? '';
  }

  /// Salva PIN (hash)
  Future<void> savePin(String userId, String pin) async {
    final hash = _hashPin(pin);
    await _storage.write(key: _pinKey(userId), value: hash);
  }

  /// Valida PIN
  Future<bool> validatePin(String userId, String inputPin) async {
    final savedHash = await _storage.read(key: _pinKey(userId));
    if (savedHash == null) return false;
    return _hashPin(inputPin) == savedHash;
  }

  /// Remove PIN
  Future<void> removePin(String userId) async {
    await _storage.delete(key: _pinKey(userId));
  }

  String _hashPin(String pin) {
    return sha256.convert(utf8.encode(pin)).toString();
  }
}
