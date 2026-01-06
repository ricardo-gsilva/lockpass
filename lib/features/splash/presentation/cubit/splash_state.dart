import 'package:equatable/equatable.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashState extends Equatable {
  final bool isLoading;
  final PackageInfo? packageInfo;
  final String? errorMessage;

  const SplashState({
    this.isLoading = false,
    this.packageInfo,
    this.errorMessage,
  });

  SplashState copyWith({
    bool? isLoading,
    PackageInfo? packageInfo,
    String? errorMessage,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      packageInfo: packageInfo ?? this.packageInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, packageInfo, errorMessage];  
}