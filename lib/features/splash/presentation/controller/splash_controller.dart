import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lockpass/core/utils/extensions/string_validators.dart';
import 'package:lockpass/features/splash/presentation/enums/entry_status_enum.dart';
import 'package:lockpass/features/splash/presentation/state/splash_state.dart';
import 'package:lockpass/services/auth_service.dart';
import 'package:lockpass/services/pin_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashController extends Cubit<SplashState> {
  final AuthService _authService;
  final PinService _pinService;
  SplashController({
    required AuthService authService,
    required PinService pinService,
  })  : _authService = authService,
        _pinService = pinService,
        super(const SplashState());

  Future<void> init() async {
    emit(state.copyWith(isLoading: true));

    final stopwatch = Stopwatch()..start();
    const minDuration = Duration(seconds: 5);

    loadPackageInfo();
    checkEntry();

    final elapsed = stopwatch.elapsed;
    if (elapsed < minDuration) {
      await Future.delayed(minDuration - elapsed);
    }

    emit(state.copyWith(isLoading: false));
  }

  Future<void> loadPackageInfo() async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));
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

  Future<void> checkEntry() async {
    emit(state.copyWith(isLoading: true));

    final user = _authService.currentUserId;
    final hasPin = await _pinService.hasPin();

    if (user.isNullOrBlank) {
      emit(state.copyWith(
          entryStatus: EntryStatus.showLoginOnly, isLoading: false));
      return;
    }

    emit(state.copyWith(
      entryStatus:
          hasPin ? EntryStatus.allowPinLogin : EntryStatus.showLoginOnly,
      isLoading: false,
    ));
  }
}
