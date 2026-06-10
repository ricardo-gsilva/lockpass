import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/security/crypto/dek/secure_storage/secure_storage_dek_store.dart';
import 'package:lockpass/core/security/crypto/dek/wrapped_dek.dart';
import 'package:mocktail/mocktail.dart';

class _MockStore extends Mock implements SecureStorageDekStore {}

class _MemoryStore implements SecureStorageDekStore {
  final _data = <String, Uint8List>{};

  @override
  Future<Uint8List?> readDek(String uid) async => _data[uid];

  @override
  Future<void> writeDek(String uid, Uint8List dek) async {
    _data[uid] = Uint8List.fromList(dek);
  }

  @override
  Future<void> deleteDek(String uid) async {
    _data.remove(uid);
  }
}

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

    test('wrapDekForExport creates export payload with non-empty base64 fields', () async {
      final store = _MemoryStore();
      final manager = DekManager(store);

      final wrapped = await manager.wrapDekForExport(
        uid: 'uid',
        exportPassword: 'p@ssw0rd',
      );

      expect(wrapped.saltB64, isNotEmpty);
      expect(wrapped.nonceB64, isNotEmpty);
      expect(wrapped.ciphertextB64, isNotEmpty);
    });

    test('importDekFromExport throws INVALID_WRAPPED_DEK when ciphertext is too short', () async {
      final store = _MemoryStore();
      final manager = DekManager(store);

      final wrapped = WrappedDek(
        saltB64: 'AA==',
        nonceB64: 'AA==',
        ciphertextB64: 'AA==',
      );

      expect(
        () => manager.importDekFromExport(
          uid: 'uid',
          wrapped: wrapped,
          exportPassword: 'p@ssw0rd',
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('INVALID_WRAPPED_DEK'),
          ),
        ),
      );
    });

    test('wrapDekForExport + importDekFromExport roundtrip writes back the same dek', () async {
      final store = _MemoryStore();
      final manager = DekManager(store);

      final originalDek = await manager.getOrCreateDek('uid');

      final wrapped = await manager.wrapDekForExport(
        uid: 'uid',
        exportPassword: 'p@ssw0rd',
      );

      await store.deleteDek('uid');
      expect(await store.readDek('uid'), isNull);

      await manager.importDekFromExport(
        uid: 'uid',
        wrapped: wrapped,
        exportPassword: 'p@ssw0rd',
      );

      final imported = await store.readDek('uid');
      expect(imported, isNotNull);
      expect(imported, originalDek);
    });
  });
}
