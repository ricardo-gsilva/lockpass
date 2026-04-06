import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/backup/backup_service.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/features/config/domain/usecases/create_manual_backup_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/restore_automatic_backup_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/restore_manual_backup_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/share_backup_usecase.dart';
import 'package:lockpass/features/config/domain/usecases/sign_out_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockBackupService extends Mock implements BackupService {}

class _MockAuthService extends Mock implements AuthService {}

void main() {
  group('Backup/auth usecases', () {
    test('CreateManualBackupUseCase calls BackupService.createManualBackup', () async {
      final backup = _MockBackupService();
      final auth = _MockAuthService();
      final useCase = CreateManualBackupUseCase(backup, auth);

      when(() => auth.currentUserId).thenReturn('uid');
      when(() => backup.createManualBackup('uid', exportPassword: any(named: 'exportPassword'))).thenAnswer((_) async {});

      await useCase('pw');

      verify(() => backup.createManualBackup('uid', exportPassword: 'pw')).called(1);
    });

    test('ShareBackupUseCase calls BackupService.shareBackup', () async {
      final backup = _MockBackupService();
      final auth = _MockAuthService();
      final useCase = ShareBackupUseCase(backup, auth);

      when(() => auth.currentUserId).thenReturn('uid');
      when(() => backup.shareBackup('uid', exportPassword: any(named: 'exportPassword'))).thenAnswer((_) async {});

      await useCase('pw');

      verify(() => backup.shareBackup('uid', exportPassword: 'pw')).called(1);
    });

    test('RestoreManualBackupUseCase calls BackupService.restoreManualBackup', () async {
      final backup = _MockBackupService();
      final auth = _MockAuthService();
      final useCase = RestoreManualBackupUseCase(backup, auth);

      when(() => auth.currentUserId).thenReturn('uid');
      when(() => backup.restoreManualBackup('/tmp/a.zip', 'uid', exportPassword: any(named: 'exportPassword')))
          .thenAnswer((_) async {});

      await useCase('/tmp/a.zip', 'pw');

      verify(() => backup.restoreManualBackup('/tmp/a.zip', 'uid', exportPassword: 'pw')).called(1);
    });

    test('RestoreAutomaticBackupUseCase calls BackupService.restoreAutomaticBackup', () async {
      final backup = _MockBackupService();
      final auth = _MockAuthService();
      final useCase = RestoreAutomaticBackupUseCase(backup, auth);

      when(() => auth.currentUserId).thenReturn('uid');
      when(() => backup.restoreAutomaticBackup('uid')).thenAnswer((_) async {});

      await useCase();

      verify(() => backup.restoreAutomaticBackup('uid')).called(1);
    });

    test('SignOutUseCase creates automatic backup and signs out', () async {
      final backup = _MockBackupService();
      final auth = _MockAuthService();
      final useCase = SignOutUseCase(backup, auth);

      when(() => auth.currentUserId).thenReturn('uid');
      when(() => backup.createAutomaticBackup('uid')).thenAnswer((_) async {});
      when(() => auth.signOut()).thenAnswer((_) async => true);

      await useCase();

      verify(() => backup.createAutomaticBackup('uid')).called(1);
      verify(() => auth.signOut()).called(1);
    });
  });
}
