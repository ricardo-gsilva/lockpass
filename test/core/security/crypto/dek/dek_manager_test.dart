import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/security/crypto/dek/secure_storage/secure_storage_dek_store.dart';
import 'package:mocktail/mocktail.dart';

class _MockStore extends Mock implements SecureStorageDekStore {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  group('DekManager', () {
    test('returns existing dek when present and valid length', () async {
      final store = _MockStore();
      final existing = Uint8List.fromList(List<int>.generate(32, (i) => i));
      when(() => store.readDek('uid')).thenAnswer((_) async => existing);

      final manager = DekManager(store);
      final dek = await manager.getOrCreateDek('uid');

      expect(dek, existing);
      verifyNever(() => store.writeDek(any(), any()));
    });

    test('creates and stores dek when missing', () async {
      final store = _MockStore();
      when(() => store.readDek('uid')).thenAnswer((_) async => null);
      when(() => store.writeDek(any(), any())).thenAnswer((_) async {});

      final manager = DekManager(store);
      final dek = await manager.getOrCreateDek('uid');

      expect(dek, isA<Uint8List>());
      expect(dek, hasLength(32));
      verify(() => store.writeDek('uid', any())).called(1);
    });
  });
}
