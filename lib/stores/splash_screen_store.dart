import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'splash_screen_store.g.dart';

class SplashScreenStore = SplashScreenStoreBase with _$SplashScreenStore;

abstract class SplashScreenStoreBase with Store {
  @observable
  PackageInfo? packageInfo;

  @action
  Future<PackageInfo> getVersion() async {    
    packageInfo = await PackageInfo.fromPlatform();
    return packageInfo!;
  }
}