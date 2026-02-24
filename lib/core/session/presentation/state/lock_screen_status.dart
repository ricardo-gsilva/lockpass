sealed class LockScreenStatus {
  const LockScreenStatus();
}

class LockScreenInitial extends LockScreenStatus {
  const LockScreenInitial();
}

class LockScreenLoading extends LockScreenStatus {
  const LockScreenLoading();
}

class LockScreenSuccess extends LockScreenStatus {
  const LockScreenSuccess();
}

class LockScreenFailure extends LockScreenStatus {
  final String message;
  const LockScreenFailure(this.message);
}