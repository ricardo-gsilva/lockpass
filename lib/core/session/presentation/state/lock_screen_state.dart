// import 'package:equatable/equatable.dart';

// class LockScreenState extends Equatable {
//   final bool isLoading;
//   final String errorMessage;
//   final bool showCredentials;
//   final bool obscurePin;
//   final bool obscurePassword;
//   final bool canSubmit;
//   final bool sufixIcon;
//   final bool pinOrEmailAndPassword;
//   final bool success;
//   final bool hasPin;

//   const LockScreenState({
//     this.isLoading = false,
//     this.errorMessage = '',
//     this.showCredentials = false,
//     this.obscurePassword = false,
//     this.obscurePin = false,
//     this.canSubmit = false,
//     this.sufixIcon = false,
//     this.pinOrEmailAndPassword = false,
//     this.success = false,
//     this.hasPin = false,
//   });

//   LockScreenState copyWith({
//     bool? isLoading,
//     String? errorMessage,
//     bool? showCredentials,
//     bool? obscurePassword,
//     bool? obscurePin,
//     bool? canSubmit,
//     bool? sufixIcon,
//     bool? pinOrEmailAndPassword,
//     bool? success,
//     bool? hasPin,
//   }) {
//     return LockScreenState(
//       isLoading: isLoading ?? this.isLoading,
//       errorMessage: errorMessage ?? this.errorMessage,
//       showCredentials: showCredentials ?? this.showCredentials,
//       obscurePassword: obscurePassword ?? this.obscurePassword,
//       obscurePin: obscurePin ?? this.obscurePin,
//       canSubmit: canSubmit ?? this.canSubmit,
//       sufixIcon: sufixIcon ?? this.sufixIcon,
//       pinOrEmailAndPassword:
//           pinOrEmailAndPassword ?? this.pinOrEmailAndPassword,
//       success: success ?? this.success,
//       hasPin: hasPin ?? this.hasPin,
//     );
//   }

//   @override
//   List<Object> get props => [
//         isLoading,
//         errorMessage,
//         showCredentials,
//         obscurePassword,
//         obscurePin,
//         canSubmit,
//         sufixIcon,
//         pinOrEmailAndPassword,
//         success,
//         hasPin,
//       ];
// }

import 'package:equatable/equatable.dart';
import 'package:lockpass/core/session/presentation/state/lock_screen_status.dart';

class LockScreenState extends Equatable {
  final bool showCredentials;
  final bool canSubmit;
  final bool pinOrEmailAndPassword;
  final LockScreenStatus status;

  const LockScreenState({
    this.showCredentials = false,
    this.canSubmit = false,
    this.pinOrEmailAndPassword = false,
    this.status = const LockScreenInitial(),
  });

  LockScreenState copyWith({
    bool? showCredentials,
    bool? canSubmit,
    bool? pinOrEmailAndPassword,
    LockScreenStatus? status,
  }) {
    return LockScreenState(
      showCredentials: showCredentials ?? this.showCredentials,
      canSubmit: canSubmit ?? this.canSubmit,
      pinOrEmailAndPassword:
          pinOrEmailAndPassword ?? this.pinOrEmailAndPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        showCredentials,
        canSubmit,
        pinOrEmailAndPassword,
        status,
      ];
}