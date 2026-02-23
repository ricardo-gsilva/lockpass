import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashState extends Equatable {
  final PackageInfo? packageInfo;
  final bool ready;

  const SplashState({
    this.packageInfo,
    this.ready = false,
  });

  SplashState copyWith({
    PackageInfo? packageInfo,
    bool? ready,
  }) {
    return SplashState(
      packageInfo: packageInfo ?? this.packageInfo,
      ready: ready ?? this.ready,
    );
  }

  @override
  List<Object?> get props => [packageInfo, ready];
}