import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/crypto/dek/secure_storage/secure_storage_dek_store_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('SecureStorageDekStoreImpl', () {
    test('readDek returns null when key missing', () async {
      final storage = _MockStorage();
      when(() => storage.read(key: any(named: 'key'))).thenAnswer((_) async => null);

      final store = SecureStorageDekStoreImpl(storage: storage);
      final dek = await store.readDek('uid');

      expect(dek, isNull);
    });

    test('writeDek stores base64 value and readDek decodes it', () async {
      final storage = _MockStorage();
      final dekBytes = Uint8List.fromList(List<int>.generate(32, (i) => i));
      final b64 = base64Encode(dekBytes);

      when(() => storage.write(key: any(named: 'key'), value: any(named: 'value'))).thenAnswer((_) async {});
      when(() => storage.read(key: any(named: 'key'))).thenAnswer((_) async => b64);

      final store = SecureStorageDekStoreImpl(storage: storage);
      await store.writeDek('uid', dekBytes);

      verify(() => storage.write(key: 'dek_b64_uid', value: b64)).called(1);

      final read = await store.readDek('uid');
      expect(read, dekBytes);
    });

    test('deleteDek delegates to storage.delete', () async {
      final storage = _MockStorage();
      when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

      final store = SecureStorageDekStoreImpl(storage: storage);
      await store.deleteDek('uid');

      verify(() => storage.delete(key: 'dek_b64_uid')).called(1);
    });
  });
}

