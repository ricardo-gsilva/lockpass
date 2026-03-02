import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/features/splash/presentation/controller/splash_controller.dart';

void registerSplashModule() {
  getIt.registerFactory<SplashController>(
    () => SplashController(),
  );
}