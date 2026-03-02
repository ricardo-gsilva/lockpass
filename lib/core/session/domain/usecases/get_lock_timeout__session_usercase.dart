import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';

class GetLockTimeoutSessionUseCase {
  final SharedPreferencesDatasource _preferencesDatasource;

  GetLockTimeoutSessionUseCase(this._preferencesDatasource);

  int call() {
    return _preferencesDatasource.getLockTimeout();
  }
}