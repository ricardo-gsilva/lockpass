import 'package:lockpass/core/security/backup/backup_service.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';

class CreateManualBackupUseCase {
  final BackupService _backupService;
  final AuthService _authService;

  CreateManualBackupUseCase(this._backupService, this._authService,);

  Future<void> call() async {
    final uid = _authService.currentUserId;
    await _backupService.createManualBackup(uid);
  }
}