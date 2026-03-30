import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/crypto/dek/secure_storage/secure_storage_dek_store_impl.dart';
import 'package:mockito/mockito.dart';

class _MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('SecureStorageDekStoreImpl', () {
    test('readDek returns null when storage returns null', () async {
      final storage = _MockFlutterSecureStorage();
      final store = SecureStorageDekStoreImpl(storage: storage);

      when(storage.read(key: anyNamed('key'))).thenAnswer((_) async => null);

      final result = await store.readDek('uid123');
      expect(result, isNull);

      verify(storage.read(key: 'dek_b64_uid123')).called(1);
    });

    test('readDek returns null when storage returns empty string', () async {
      final storage = _MockFlutterSecureStorage();
      final store = SecureStorageDekStoreImpl(storage: storage);

      when(storage.read(key: anyNamed('key'))).thenAnswer((_) async => '');

      final result = await store.readDek('uid123');
      expect(result, isNull);

      verify(storage.read(key: 'dek_b64_uid123')).called(1);
    });

    test('readDek decodes base64 value from storage', () async {
      final storage = _MockFlutterSecureStorage();
      final store = SecureStorageDekStoreImpl(storage: storage);

      final dek = Uint8List.fromList([1, 2, 3, 254, 255]);
      when(storage.read(key: anyNamed('key')))
          .thenAnswer((_) async => base64Encode(dek));

      final result = await store.readDek('uid123');
      expect(result, isNotNull);
      expect(result, equals(dek));

      verify(storage.read(key: 'dek_b64_uid123')).called(1);
    });

    test('writeDek writes base64 value to storage', () async {
      final storage = _MockFlutterSecureStorage();
      final store = SecureStorageDekStoreImpl(storage: storage);

      final dek = Uint8List.fromList([9, 8, 7, 0]);
      when(storage.write(key: anyNamed('key'), value: anyNamed('value')))
          .thenAnswer((_) async {});

      await store.writeDek('uid123', dek);

      verify(
        storage.write(
          key: 'dek_b64_uid123',
          value: base64Encode(dek),
        ),
      ).called(1);
    });

    test('deleteDek deletes key from storage', () async {
      final storage = _MockFlutterSecureStorage();
      final store = SecureStorageDekStoreImpl(storage: storage);

      when(storage.delete(key: anyNamed('key'))).thenAnswer((_) async {});

      await store.deleteDek('uid123');

      verify(storage.delete(key: 'dek_b64_uid123')).called(1);
    });
  });
}

