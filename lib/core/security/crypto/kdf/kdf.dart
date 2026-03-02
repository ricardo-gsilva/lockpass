import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';

class Kdf {
  Kdf._();

  static final _pbkdf2 = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 150000,
    bits: 256,
  );

  static Future<Uint8List> deriveKek({
    required String secret,
    required Uint8List salt,
  }) async {
    final key = await _pbkdf2.deriveKey(
      secretKey: SecretKey(secret.codeUnits),
      nonce: salt,
    );
    final bytes = await key.extractBytes();
    return Uint8List.fromList(bytes);
  }
}