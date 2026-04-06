import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/list_item/domain/usecases/edit_item_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockItensRepository extends Mock implements ItensRepository {}

class _MockDekManager extends Mock implements DekManager {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const ItensEntity(
        userId: 'u',
        id: 0,
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      ),
    );
  });

  group('EditItemUseCase', () {
    test('throws requiresRecentLogin when uid is empty', () async {
      final authService = _MockAuthService();
      final repository = _MockItensRepository();
      final dekManager = _MockDekManager();
      final useCase = EditItemUseCase(authService, repository, dekManager);

      when(() => authService.currentUserId).thenReturn('');

      const item = ItensEntity(
        userId: '',
        id: 1,
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      );

      expect(() => useCase(item), throwsA(equals(AuthErrorType.requiresRecentLogin)));
      verifyNever(() => repository.updateItem(any()));
    });

    test('encrypts fields and updates repository', () async {
      final authService = _MockAuthService();
      final repository = _MockItensRepository();
      final dekManager = _MockDekManager();
      final useCase = EditItemUseCase(authService, repository, dekManager);

      const uid = 'uid123';
      final dek = Uint8List.fromList(List.generate(32, (i) => i));

      when(() => authService.currentUserId).thenReturn(uid);
      when(() => dekManager.getOrCreateDek(uid)).thenAnswer((_) async => dek);
      when(() => repository.updateItem(any())).thenAnswer((_) async => 1);

      final item = ItensEntity(
        userId: uid,
        id: 1,
        group: '  Group  ',
        service: '  Service  ',
        site: '  https://example.com  ',
        email: '  a@b.com  ',
        login: '  login  ',
        password: '  pass  ',
      );

      await useCase(item);

      final captured =
          verify(() => repository.updateItem(captureAny())).captured.single as ItensEntity;

      expect(captured.userId, EncryptDecrypt.generateUserMask(uid));

      final group = await EncryptDecrypt.decryptInformation(payloadB64: captured.group, dek: dek);
      final service = await EncryptDecrypt.decryptInformation(payloadB64: captured.service, dek: dek);
      final login = await EncryptDecrypt.decryptInformation(payloadB64: captured.login, dek: dek);
      final password = await EncryptDecrypt.decryptInformation(payloadB64: captured.password, dek: dek);
      final site = await EncryptDecrypt.decryptInformation(payloadB64: captured.site!, dek: dek);
      final email = await EncryptDecrypt.decryptInformation(payloadB64: captured.email!, dek: dek);

      expect(group, 'Group');
      expect(service, 'Service');
      expect(login, 'login');
      expect(password, 'pass');
      expect(site, 'https://example.com');
      expect(email, 'a@b.com');
    });
  });
}
