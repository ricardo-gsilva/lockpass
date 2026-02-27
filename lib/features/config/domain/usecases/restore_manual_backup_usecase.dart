import 'package:lockpass/core/security/backup/backup_service.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';

class RestoreManualBackupUseCase {
  final BackupService _backupService;
  final AuthService _authService;

  RestoreManualBackupUseCase(
    this._backupService,
    this._authService,
  );

  Future<void> call(String path) async {
    final uid = _authService.currentUserId;
    await _backupService.restoreManualBackup(path, uid);
  }
}
