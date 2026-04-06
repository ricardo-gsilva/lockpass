import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:lockpass/features/config/domain/usecases/set_lock_timeout_usercase.dart';
import 'package:mocktail/mocktail.dart';

class _MockPrefs extends Mock implements SharedPreferencesDatasource {}

void main() {
  group('SetLockTimeoutUseCase', () {
    test('delegates to preferences datasource', () async {
      final prefs = _MockPrefs();
      final useCase = SetLockTimeoutUseCase(prefs);

      when(() => prefs.setLockTimeout(90)).thenAnswer((_) async => true);

      final result = await useCase(90);
      expect(result, isTrue);

      verify(() => prefs.setLockTimeout(90)).called(1);
    });
  });
}

