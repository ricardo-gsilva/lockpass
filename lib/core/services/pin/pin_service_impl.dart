import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'pin_service.dart';

class PinServiceImpl implements PinService {
  final FlutterSecureStorage _storage;

  PinServiceImpl({
    FlutterSecureStorage? storage,
  }) : _storage = storage ?? const FlutterSecureStorage();

  String _pinKey(String userId) => 'pin_hash_$userId';

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
    final hash = _hashPin(pin);
    await _storage.write(key: _pinKey(userId), value: hash);
  }

  @override
  Future<bool> validatePin(String userId, String inputPin) async {
    final savedHash = await _storage.read(key: _pinKey(userId));
    if (savedHash == null) return false;
    return _hashPin(inputPin) == savedHash;
  }

  @override
  Future<void> removePin(String userId) async {
    await _storage.delete(key: _pinKey(userId));
  }

  String _hashPin(String pin) {
    return sha256.convert(utf8.encode(pin)).toString();
  }
}