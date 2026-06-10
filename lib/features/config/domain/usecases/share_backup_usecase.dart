import 'package:lockpass/core/security/backup/backup_service.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';

class ShareBackupUseCase {
  final BackupService _backupService;
  final AuthService _authService;

  ShareBackupUseCase(
    this._backupService,
    this._authService,
  );

  Future<void> call(String exportPassword) async {
    final uid = _authService.currentUserId;
    await _backupService.shareBackup(uid, exportPassword: exportPassword);
  }
}
