import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/crypto/dek/wrapped_dek.dart';

void main() {
  group('WrappedDek', () {
    test('toJson/fromJson roundtrip', () {
      const dek = WrappedDek(
        saltB64: 'salt',
        nonceB64: 'nonce',
        ciphertextB64: 'ciphertext',
      );

      final json = dek.toJson();
      final decoded = WrappedDek.fromJson(json);

      expect(decoded.saltB64, 'salt');
      expect(decoded.nonceB64, 'nonce');
      expect(decoded.ciphertextB64, 'ciphertext');
    });
  });
}

