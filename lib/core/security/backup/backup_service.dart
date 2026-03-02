abstract class BackupService {
  Future<String?> selectZipFile();
  Future<void> createManualBackup(String uid);
  Future<void> createAutomaticBackup(String uid);
  Future<void> shareBackup(String uid);
  Future<void> restoreManualBackup(String path, String uid);  
  Future<void> restoreAutomaticBackup(String uid);
}