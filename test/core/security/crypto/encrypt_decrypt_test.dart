import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';

void main() {
  group('EncryptDecrypt', () {
    test('generateUserMask is stable and 64 hex chars', () {
      final a = EncryptDecrypt.generateUserMask('uid123');
      final b = EncryptDecrypt.generateUserMask('uid123');
      expect(a, b);
      expect(a, hasLength(64));
    });

    test('encryptInformation/decryptInformation roundtrip', () async {
      final dek = Uint8List.fromList(List<int>.generate(32, (i) => i));
      final payload = await EncryptDecrypt.encryptInformation(plainText: 'hello', dek: dek);
      final clear = await EncryptDecrypt.decryptInformation(payloadB64: payload, dek: dek);
      expect(clear, 'hello');
    });
  });
}

