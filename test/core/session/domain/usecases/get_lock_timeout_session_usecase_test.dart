import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/session/domain/usecases/get_lock_timeout__session_usercase.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:mocktail/mocktail.dart';

class _MockPrefs extends Mock implements SharedPreferencesDatasource {}

void main() {
  group('GetLockTimeoutSessionUseCase', () {
    test('delegates to preferences datasource', () {
      final prefs = _MockPrefs();
      when(() => prefs.getLockTimeout()).thenReturn(120);

      final useCase = GetLockTimeoutSessionUseCase(prefs);
      expect(useCase(), 120);

      verify(() => prefs.getLockTimeout()).called(1);
    });
  });
}

