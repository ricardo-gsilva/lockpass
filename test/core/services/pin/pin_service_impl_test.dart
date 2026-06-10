import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/services/pin/pin_service_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('PinServiceImpl', () {
    test('hasPin returns false when storage returns null/empty', () async {
      final storage = _MockStorage();
      when(() => storage.read(key: any(named: 'key'))).thenAnswer((_) async => null);

      final service = PinServiceImpl(storage: storage);
      expect(await service.hasPin('uid'), isFalse);

      when(() => storage.read(key: any(named: 'key'))).thenAnswer((_) async => '');
      expect(await service.hasPin('uid'), isFalse);
    });

    test('savePin writes hashed value and validatePin compares hashes', () async {
      final storage = _MockStorage();
      when(() => storage.write(key: any(named: 'key'), value: any(named: 'value'))).thenAnswer((_) async {});

      String? storedValue;
      when(() => storage.read(key: any(named: 'key'))).thenAnswer((invocation) async {
        return storedValue;
      });

      final service = PinServiceImpl(storage: storage);

      await service.savePin('uid', '12345');
      final captured = verify(
        () => storage.write(
          key: 'pin_hash_uid',
          value: captureAny(named: 'value'),
        ),
      ).captured.single as String;

      storedValue = captured;

      expect(await service.validatePin('uid', '12345'), isTrue);
      expect(await service.validatePin('uid', '00000'), isFalse);
    });

    test('removePin deletes key', () async {
      final storage = _MockStorage();
      when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});

      final service = PinServiceImpl(storage: storage);
      await service.removePin('uid');

      verify(() => storage.delete(key: 'pin_hash_uid')).called(1);
    });
  });
}

