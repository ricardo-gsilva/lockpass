import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/list_item/domain/usecases/load_items_usecase.dart';
import 'package:lockpass/features/list_item/presentation/enums/list_view_mode_enum.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockItensRepository extends Mock implements ItensRepository {}

class _MockDekManager extends Mock implements DekManager {}

void main() {
  group('LoadItemsUseCase', () {
    test('throws requiresRecentLogin when uid is empty', () async {
      final authService = _MockAuthService();
      final repository = _MockItensRepository();
      final dekManager = _MockDekManager();
      final useCase = LoadItemsUseCase(authService, repository, dekManager);

      when(() => authService.currentUserId).thenReturn('');

      expect(
        () => useCase(ListViewModeEnum.list),
        throwsA(equals(AuthErrorType.requiresRecentLogin)),
      );
    });

    test('loads active items, decrypts fields, and sorts by service', () async {
      final authService = _MockAuthService();
      final repository = _MockItensRepository();
      final dekManager = _MockDekManager();
      final useCase = LoadItemsUseCase(authService, repository, dekManager);

      const uid = 'uid123';
      final dek = Uint8List.fromList(List.generate(32, (i) => i));

      when(() => authService.currentUserId).thenReturn(uid);
      when(() => dekManager.getOrCreateDek(uid)).thenAnswer((_) async => dek);

      final uidMask = EncryptDecrypt.generateUserMask(uid);

      when(() => repository.getDeletedItensByUser(uidMask)).thenAnswer((_) async => []);
      when(() => repository.getActiveItensByUser(uidMask)).thenAnswer((_) async {
        final s1 = await EncryptDecrypt.encryptInformation(plainText: 'B', dek: dek);
        final s2 = await EncryptDecrypt.encryptInformation(plainText: 'A', dek: dek);
        final group1 = await EncryptDecrypt.encryptInformation(plainText: 'G1', dek: dek);
        final group2 = await EncryptDecrypt.encryptInformation(plainText: 'G2', dek: dek);
        final login1 = await EncryptDecrypt.encryptInformation(plainText: 'l1', dek: dek);
        final login2 = await EncryptDecrypt.encryptInformation(plainText: 'l2', dek: dek);
        final pass1 = await EncryptDecrypt.encryptInformation(plainText: 'p1', dek: dek);
        final pass2 = await EncryptDecrypt.encryptInformation(plainText: 'p2', dek: dek);

        return [
          ItensEntity(
            userId: uidMask,
            id: 1,
            group: group1,
            service: s1,
            login: login1,
            password: pass1,
          ),
          ItensEntity(
            userId: uidMask,
            id: 2,
            group: group2,
            service: s2,
            login: login2,
            password: pass2,
          ),
        ];
      });

      final result = await useCase(ListViewModeEnum.list);

      expect(result.hasDeleted, isFalse);
      expect(result.mode, ListViewModeEnum.list);
      expect(result.items, hasLength(2));
      expect(result.sorted.map((e) => e.service).toList(), ['A', 'B']);
      expect(result.sorted.first.userId, uid);
      expect(result.sorted.first.group, anyOf('G1', 'G2'));
    });

    test('when no deleted items, forces mode to list', () async {
      final authService = _MockAuthService();
      final repository = _MockItensRepository();
      final dekManager = _MockDekManager();
      final useCase = LoadItemsUseCase(authService, repository, dekManager);

      const uid = 'uid123';
      final dek = Uint8List.fromList(List.generate(32, (i) => i));

      when(() => authService.currentUserId).thenReturn(uid);
      when(() => dekManager.getOrCreateDek(uid)).thenAnswer((_) async => dek);

      final uidMask = EncryptDecrypt.generateUserMask(uid);
      when(() => repository.getDeletedItensByUser(uidMask)).thenAnswer((_) async => []);
      when(() => repository.getActiveItensByUser(uidMask)).thenAnswer((_) async => []);

      final result = await useCase(ListViewModeEnum.trash);

      expect(result.hasDeleted, isFalse);
      expect(result.mode, ListViewModeEnum.list);
    });
  });
}

