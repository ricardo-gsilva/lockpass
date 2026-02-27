import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';

class SetHideCreatePinAlertUseCase {
  final SharedPreferencesDatasource _prefs;

  SetHideCreatePinAlertUseCase(this._prefs);

  Future<void> call(bool value) async {
    await _prefs.setHideCreatePinAlert(value);
  }
}