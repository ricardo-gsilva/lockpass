import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/crypto/kdf/kdf.dart';

void main() {
  group('Kdf', () {
    test('deriveKek is deterministic and returns 32 bytes', () async {
      final salt = Uint8List.fromList(List<int>.generate(16, (i) => i));

      final kek1 = await Kdf.deriveKek(secret: 'secret', salt: salt);
      final kek2 = await Kdf.deriveKek(secret: 'secret', salt: salt);

      expect(kek1, hasLength(32));
      expect(kek2, hasLength(32));
      expect(kek1, kek2);
    });

    test('deriveKek changes when secret changes', () async {
      final salt = Uint8List.fromList(List<int>.generate(16, (i) => i));

      final kek1 = await Kdf.deriveKek(secret: 'secret-a', salt: salt);
      final kek2 = await Kdf.deriveKek(secret: 'secret-b', salt: salt);

      expect(kek1, isNot(kek2));
    });
  });
}

