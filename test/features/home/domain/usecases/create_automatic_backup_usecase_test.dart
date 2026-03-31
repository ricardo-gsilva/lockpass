import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/backup/backup_service.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/home/domain/usecases/create_automatic_backup_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockItensRepository extends Mock implements ItensRepository {}

class _MockBackupService extends Mock implements BackupService {}

void main() {
  group('CreateAutomaticBackupUseCase', () {
    test('does not create backup when no items', () async {
      final repository = _MockItensRepository();
      final backupService = _MockBackupService();
      final useCase = CreateAutomaticBackupUseCase(repository, backupService);

      const uid = 'uid123';
      final uidMask = EncryptDecrypt.generateUserMask(uid);

      when(() => repository.getActiveItensByUser(uidMask)).thenAnswer((_) async => []);

      await useCase(uid);

      verify(() => repository.getActiveItensByUser(uidMask)).called(1);
      verifyNever(() => backupService.createAutomaticBackup(any()));
    });

    test('creates backup when there are items', () async {
      final repository = _MockItensRepository();
      final backupService = _MockBackupService();
      final useCase = CreateAutomaticBackupUseCase(repository, backupService);

      const uid = 'uid123';
      final uidMask = EncryptDecrypt.generateUserMask(uid);

      when(() => repository.getActiveItensByUser(uidMask)).thenAnswer((_) async => [
            ItensEntity(
              userId: uidMask,
              id: 1,
              group: 'g',
              service: 's',
              login: 'l',
              password: 'p',
            ),
          ]);
      when(() => backupService.createAutomaticBackup(uid)).thenAnswer((_) async {});

      await useCase(uid);

      verify(() => repository.getActiveItensByUser(uidMask)).called(1);
      verify(() => backupService.createAutomaticBackup(uid)).called(1);
    });
  });
}
