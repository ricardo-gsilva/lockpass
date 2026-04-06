import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/vault/vault_service.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/config/domain/usecases/delete_account_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockItensRepository extends Mock implements ItensRepository {}

class _MockVaultService extends Mock implements VaultService {}

class _MockAuthService extends Mock implements AuthService {}

class _FakeFile extends Fake implements File {
  _FakeFile(this._exists);

  bool _exists;
  bool deleted = false;

  @override
  Future<bool> exists() async => _exists;

  @override
  Future<File> delete({bool recursive = false}) async {
    deleted = true;
    _exists = false;
    return this;
  }
}

void main() {
  group('DeleteAccountUseCase', () {
    test('clears local data and deletes automatic backup if present', () async {
      final repository = _MockItensRepository();
      final vault = _MockVaultService();
      final auth = _MockAuthService();

      final fakeFile = _FakeFile(true);

      final useCase = DeleteAccountUseCase(
        repository,
        vault,
        auth,
        getApplicationDocumentsDirectoryFn: () async => Directory('/tmp'),
        fileFactory: (_) => fakeFile,
      );

      when(() => repository.closeDatabase()).thenAnswer((_) async {});
      when(() => repository.deleteLocalDatabase()).thenAnswer((_) async {});
      when(() => vault.clearUserPreferences()).thenAnswer((_) async {});
      when(() => auth.deleteAccount()).thenAnswer((_) async {});

      await useCase();

      verify(() => repository.closeDatabase()).called(1);
      verify(() => repository.deleteLocalDatabase()).called(1);
      expect(fakeFile.deleted, isTrue);
      verify(() => vault.clearUserPreferences()).called(1);
      verify(() => auth.deleteAccount()).called(1);
    });

    test('does not delete automatic backup when file does not exist', () async {
      final repository = _MockItensRepository();
      final vault = _MockVaultService();
      final auth = _MockAuthService();

      final fakeFile = _FakeFile(false);

      final useCase = DeleteAccountUseCase(
        repository,
        vault,
        auth,
        getApplicationDocumentsDirectoryFn: () async => Directory('/tmp'),
        fileFactory: (_) => fakeFile,
      );

      when(() => repository.closeDatabase()).thenAnswer((_) async {});
      when(() => repository.deleteLocalDatabase()).thenAnswer((_) async {});
      when(() => vault.clearUserPreferences()).thenAnswer((_) async {});
      when(() => auth.deleteAccount()).thenAnswer((_) async {});

      await useCase();

      expect(fakeFile.deleted, isFalse);
    });
  });
}

