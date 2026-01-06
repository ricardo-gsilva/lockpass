import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/features/splash/presentation/cubit/splash_state.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

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