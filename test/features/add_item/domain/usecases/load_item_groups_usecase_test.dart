import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/add_item/domain/usecases/load_item_groups_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockItensRepository extends Mock implements ItensRepository {}

class _MockDekManager extends Mock implements DekManager {}

void main() {
  late _MockAuthService authService;
  late _MockItensRepository repository;
  late _MockDekManager dekManager;
  late LoadItemGroupsUseCase useCase;

  final dek = Uint8List.fromList(List<int>.generate(32, (i) => i));

  setUp(() {
    authService = _MockAuthService();
    repository = _MockItensRepository();
    dekManager = _MockDekManager();
    useCase = LoadItemGroupsUseCase(authService, repository, dekManager);
  });

  group('LoadItemGroupsUseCase', () {
    test('returns empty list when uid is empty', () async {
      when(() => authService.currentUserId).thenReturn('');

      final result = await useCase();
      expect(result, isEmpty);

      verifyNever(() => dekManager.getOrCreateDek(any()));
      verifyNever(() => repository.getActiveItensByUser(any()));
    });

    test('returns distinct sorted decrypted groups', () async {
      const uid = 'uid123';
      when(() => authService.currentUserId).thenReturn(uid);
      when(() => dekManager.getOrCreateDek(uid)).thenAnswer((_) async => dek);

      final encryptedA = await EncryptDecrypt.encryptInformation(plainText: 'a', dek: dek);
      final encryptedB = await EncryptDecrypt.encryptInformation(plainText: ' b ', dek: dek);
      final encryptedC = await EncryptDecrypt.encryptInformation(plainText: 'c', dek: dek);
      final encryptedEmpty = await EncryptDecrypt.encryptInformation(plainText: '', dek: dek);

      final uidMask = EncryptDecrypt.generateUserMask(uid);
      when(() => repository.getActiveItensByUser(uidMask)).thenAnswer((_) async => [
            ItensEntity(userId: uidMask, group: encryptedB, service: 's', login: 'l', password: 'p'),
            ItensEntity(userId: uidMask, group: encryptedA, service: 's', login: 'l', password: 'p'),
            ItensEntity(userId: uidMask, group: encryptedA, service: 's', login: 'l', password: 'p'),
            ItensEntity(userId: uidMask, group: encryptedC, service: 's', login: 'l', password: 'p'),
            ItensEntity(userId: uidMask, group: encryptedEmpty, service: 's', login: 'l', password: 'p'),
          ]);

      final result = await useCase();

      expect(result, ['a', 'b', 'c']);
      verify(() => repository.getActiveItensByUser(uidMask)).called(1);
      verify(() => dekManager.getOrCreateDek(uid)).called(1);
    });
  });
}

