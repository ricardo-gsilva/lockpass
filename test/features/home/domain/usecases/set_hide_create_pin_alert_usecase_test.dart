import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:lockpass/features/home/domain/usecases/set_hide_create_pin_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockPrefs extends Mock implements SharedPreferencesDatasource {}

void main() {
  group('SetHideCreatePinAlertUseCase', () {
    test('delegates to prefs', () async {
      final prefs = _MockPrefs();
      final useCase = SetHideCreatePinAlertUseCase(prefs);

      when(() => prefs.setHideCreatePinAlert(true)).thenAnswer((_) async => true);

      await useCase(true);

      verify(() => prefs.setHideCreatePinAlert(true)).called(1);
    });
  });
}

