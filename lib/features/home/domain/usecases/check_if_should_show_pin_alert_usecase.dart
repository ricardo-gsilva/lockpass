import 'package:lockpass/core/services/pin/pin_service.dart';
import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';

class CheckIfShouldShowPinAlertUseCase {
  final PinService _pinService;
  final SharedPreferencesDatasource _prefs;

  CheckIfShouldShowPinAlertUseCase(
    this._pinService,
    this._prefs,
  );

  Future<bool> call(String uid) async {
    final hideAlert = _prefs.getHideCreatePinAlert();
    if (hideAlert) return false;

    final hasPin = await _pinService.hasPin(uid);
    return !hasPin;
  }
}