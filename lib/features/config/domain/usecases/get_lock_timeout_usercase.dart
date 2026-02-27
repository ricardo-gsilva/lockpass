import 'package:lockpass/data/datasources/local/preferences/shared_preferences_datasource.dart';

class GetLockTimeoutUseCase {
  final SharedPreferencesDatasource _preferencesDatasource;

  GetLockTimeoutUseCase(this._preferencesDatasource);

  int call() {
    return _preferencesDatasource.getLockTimeout();
  }
}