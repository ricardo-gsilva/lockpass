import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';
import 'package:lockpass/features/home/domain/usecases/check_if_should_show_pin_alert_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockPinService extends Mock implements PinService {}

class _MockPrefs extends Mock implements SharedPreferencesDatasource {}

void main() {
  group('CheckIfShouldShowPinAlertUseCase', () {
    test('returns false when prefs hides alert', () async {
      final pinService = _MockPinService();
      final prefs = _MockPrefs();
      final useCase = CheckIfShouldShowPinAlertUseCase(pinService, prefs);

      when(() => prefs.getHideCreatePinAlert()).thenReturn(true);

      final result = await useCase('uid123');

      expect(result, isFalse);
      verifyNever(() => pinService.hasPin(any()));
    });

    test('returns false when user already has pin', () async {
      final pinService = _MockPinService();
      final prefs = _MockPrefs();
      final useCase = CheckIfShouldShowPinAlertUseCase(pinService, prefs);

      when(() => prefs.getHideCreatePinAlert()).thenReturn(false);
      when(() => pinService.hasPin('uid123')).thenAnswer((_) async => true);

      final result = await useCase('uid123');

      expect(result, isFalse);
      verify(() => pinService.hasPin('uid123')).called(1);
    });

    test('returns true when user does not have pin', () async {
      final pinService = _MockPinService();
      final prefs = _MockPrefs();
      final useCase = CheckIfShouldShowPinAlertUseCase(pinService, prefs);

      when(() => prefs.getHideCreatePinAlert()).thenReturn(false);
      when(() => pinService.hasPin('uid123')).thenAnswer((_) async => false);

      final result = await useCase('uid123');

      expect(result, isTrue);
      verify(() => pinService.hasPin('uid123')).called(1);
    });
  });
}

