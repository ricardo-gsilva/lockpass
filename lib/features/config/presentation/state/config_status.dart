import 'package:equatable/equatable.dart';

sealed class ConfigStatus extends Equatable {
  const ConfigStatus();

  @override
  List<Object?> get props => const [];
}

class ConfigInitial extends ConfigStatus {
  const ConfigInitial();
}

class ConfigLoading extends ConfigStatus {
  const ConfigLoading();
}

class ConfigSuccess extends ConfigStatus {
  final String message;
  const ConfigSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ConfigError extends ConfigStatus {
  final String message;
  const ConfigError(this.message);

  @override
  List<Object?> get props => [message];
}

class ConfigBackupSaved extends ConfigStatus {
  final String message;
  const ConfigBackupSaved(this.message);
}

class ConfigBackupShared extends ConfigStatus {
  final String message;
  const ConfigBackupShared(this.message);
}

class ConfigRestoreBackupManualSuccess extends ConfigStatus {
  final String message;
  const ConfigRestoreBackupManualSuccess(this.message);
}

class ConfigRestoreBackupAutomaticSuccess extends ConfigStatus {
  final String message;
  const ConfigRestoreBackupAutomaticSuccess(this.message);
}

class ConfigPinCreatedSuccess extends ConfigStatus {
  final String message;
  const ConfigPinCreatedSuccess(this.message);
}

class ConfigPinResetSuccess extends ConfigStatus {
  final String message;
  const ConfigPinResetSuccess(this.message);
}

class ConfigPinRemoveSuccess extends ConfigStatus {
  final String message;
  const ConfigPinRemoveSuccess(this.message);
}

class ConfigResetPasswordSuccess extends ConfigStatus {
  final String message;
  const ConfigResetPasswordSuccess(this.message);
}

class ConfigLogoutSuccess extends ConfigStatus {
  const ConfigLogoutSuccess();
}

class ConfigDeleteAccountSuccess extends ConfigStatus {
  const ConfigDeleteAccountSuccess();
}
