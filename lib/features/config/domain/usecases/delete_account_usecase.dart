import 'dart:io';

import 'package:lockpass/core/security/vault/vault_service.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DeleteAccountUseCase {
  final ItensRepository _itensRepository;
  final VaultService _vaultService;
  final AuthService _authService;
  final Future<Directory> Function() _getApplicationDocumentsDirectory;
  final File Function(String path) _fileFactory;

  DeleteAccountUseCase(
    this._itensRepository,
    this._vaultService,
    this._authService, {
    Future<Directory> Function()? getApplicationDocumentsDirectoryFn,
    File Function(String path)? fileFactory,
  })  : _getApplicationDocumentsDirectory =
            getApplicationDocumentsDirectoryFn ?? getApplicationDocumentsDirectory,
        _fileFactory = fileFactory ?? ((path) => File(path));

  Future<void> call() async {
    await _itensRepository.closeDatabase();
    await _itensRepository.deleteLocalDatabase();

    await _deleteAutomaticBackup();

    await _vaultService.clearUserPreferences();
    await _authService.deleteAccount();
  }

  Future<void> _deleteAutomaticBackup() async {
    final appDir = await _getApplicationDocumentsDirectory();
    final backupFile = _fileFactory(p.join(appDir.path, 'LPB_automatic.zip'));

    if (await backupFile.exists()) {
      await backupFile.delete();
    }
  }
}
