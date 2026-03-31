import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:lockpass/features/config/domain/usecases/get_lock_timeout_usercase.dart';
import 'package:mocktail/mocktail.dart';

class _MockPrefs extends Mock implements SharedPreferencesDatasource {}

void main() {
  group('GetLockTimeoutUseCase', () {
    test('returns value from preferences datasource', () {
      final prefs = _MockPrefs();
      final useCase = GetLockTimeoutUseCase(prefs);

      when(() => prefs.getLockTimeout()).thenReturn(120);

      expect(useCase(), 120);
      verify(() => prefs.getLockTimeout()).called(1);
    });
  });
}

