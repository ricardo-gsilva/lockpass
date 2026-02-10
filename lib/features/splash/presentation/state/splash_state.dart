import 'package:equatable/equatable.dart';
import 'package:lockpass/features/splash/presentation/enums/entry_status_enum.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashState extends Equatable {
  final bool isLoading;
  final PackageInfo? packageInfo;
  final String errorMessage;
  final String successMessage;
  final EntryStatus entryStatus;

  const SplashState({
    this.isLoading = false,
    this.packageInfo,
    this.errorMessage = '',
    this.successMessage = '',
    this.entryStatus = EntryStatus.showLoginOnly
  });

  SplashState copyWith({
    bool? isLoading,
    PackageInfo? packageInfo,
    String? errorMessage,
    String? successMessage,
    EntryStatus? entryStatus
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      packageInfo: packageInfo ?? this.packageInfo,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      entryStatus: entryStatus ?? this.entryStatus,
    );
  }

  @override
  List<Object?> get props => [isLoading, packageInfo, errorMessage, successMessage, entryStatus];  
}