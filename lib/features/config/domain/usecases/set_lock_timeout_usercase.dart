import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';

class SetLockTimeoutUseCase {
  final SharedPreferencesDatasource _preferencesDatasource;

  SetLockTimeoutUseCase(this._preferencesDatasource);

  Future<bool> call(int value) async {
    return await _preferencesDatasource.setLockTimeout(value);
  }
}