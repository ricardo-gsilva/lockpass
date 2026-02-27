import 'package:equatable/equatable.dart';
import 'package:lockpass/core/session/presentation/state/lock_screen_status.dart';

class LockScreenState extends Equatable {
  final bool showCredentials;
  final bool canSubmit;
  final LockScreenStatus status;

  const LockScreenState({
    this.showCredentials = false,
    this.canSubmit = false,
    this.status = const LockScreenInitial(),
  });

  LockScreenState copyWith({
    bool? showCredentials,
    bool? canSubmit,
    LockScreenStatus? status,
  }) {
    return LockScreenState(
      showCredentials: showCredentials ?? this.showCredentials,
      canSubmit: canSubmit ?? this.canSubmit,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        showCredentials,
        canSubmit,
        status,
      ];
}