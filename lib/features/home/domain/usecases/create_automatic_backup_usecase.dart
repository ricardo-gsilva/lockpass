import 'package:lockpass/core/security/backup/backup_service.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';

class CreateAutomaticBackupUseCase {
  final ItensRepository _itensRepository;
  final BackupService _backupService;

  CreateAutomaticBackupUseCase(
    this._itensRepository,
    this._backupService,
  );

  Future<void> call(String uid) async {
    final itens = await _itensRepository.getActiveItensByUser(uid);

    if (itens.isEmpty) return;

    await _backupService.createAutomaticBackup(uid);
  }
}