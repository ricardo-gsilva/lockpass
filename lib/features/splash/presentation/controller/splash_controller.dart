import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/features/splash/presentation/state/splash_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends Cubit<SplashState> {
  SplashController() : super(const SplashState());

  Future<void> init() async {
    final stopwatch = Stopwatch()..start();
    const minDuration = Duration(seconds: 5);

    final packageInfo = await PackageInfo.fromPlatform();
    emit(state.copyWith(
      packageInfo: packageInfo,
      ready: true,
    ));

    final elapsed = stopwatch.elapsed;
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }
  }
}
