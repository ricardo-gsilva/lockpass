import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/features/splash/presentation/state/splash_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends Cubit<SplashState> {
  SplashController() : super(const SplashState());

  Future<void> loadPackageInfo() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      emit(
        state.copyWith(
          isLoading: false, 
          packageInfo: packageInfo,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }


}