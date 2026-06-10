abstract class BackupService {
  Future<String?> selectZipFile();
  Future<void> createManualBackup(String uid, {required String exportPassword});
  Future<void> createAutomaticBackup(String uid);
  Future<void> shareBackup(String uid, {required String exportPassword});
  Future<void> restoreManualBackup(String path, String uid, {required String exportPassword});
  Future<void> restoreAutomaticBackup(String uid);
}
