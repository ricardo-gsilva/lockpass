import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/constants/core_strings.dart';
import 'package:lockpass/core/errors/auth_errors_type.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/add_item/domain/usecases/create_item_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockItensRepository extends Mock implements ItensRepository {}

class _MockDekManager extends Mock implements DekManager {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const ItensEntity(
        userId: '',
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      ),
    );
  });

  late _MockAuthService authService;
  late _MockItensRepository repository;
  late _MockDekManager dekManager;
  late CreateItemUseCase useCase;

  final dek = Uint8List.fromList(List<int>.generate(32, (i) => i));

  setUp(() {
    authService = _MockAuthService();
    repository = _MockItensRepository();
    dekManager = _MockDekManager();
    useCase = CreateItemUseCase(authService, repository, dekManager);
  });

  group('CreateItemUseCase', () {
    test('throws requiresRecentLogin when uid is empty', () async {
      when(() => authService.currentUserId).thenReturn('');

      expect(
        () => useCase(
          const ItensEntity(
            userId: '',
            group: 'g',
            service: 's',
            login: 'l',
            password: 'p',
          ),
          const ['existing'],
        ),
        throwsA(AuthErrorType.requiresRecentLogin),
      );

      verifyNever(() => dekManager.getOrCreateDek(any()));
      verifyNever(() => repository.addItem(any()));
    });

    test('encrypts fields, masks uid, and persists item', () async {
      const uid = 'uid123';
      when(() => authService.currentUserId).thenReturn(uid);
      when(() => dekManager.getOrCreateDek(uid)).thenAnswer((_) async => dek);
      when(() => repository.addItem(any())).thenAnswer((_) async => 1);

      const plainItem = ItensEntity(
        userId: '',
        group: '',
        service: ' service ',
        site: null,
        email: null,
        login: ' login ',
        password: ' pass ',
      );

      await useCase(plainItem, const ['  Group A  ']);

      final captured = verify(() => repository.addItem(captureAny())).captured.single as ItensEntity;

      expect(captured.userId, EncryptDecrypt.generateUserMask(uid));
      expect(captured.site, isNull);
      expect(captured.email, isNull);

      final decryptedGroup = await EncryptDecrypt.decryptInformation(payloadB64: captured.group, dek: dek);
      final decryptedService = await EncryptDecrypt.decryptInformation(payloadB64: captured.service, dek: dek);
      final decryptedLogin = await EncryptDecrypt.decryptInformation(payloadB64: captured.login, dek: dek);
      final decryptedPassword = await EncryptDecrypt.decryptInformation(payloadB64: captured.password, dek: dek);

      expect(decryptedGroup, 'Group A');
      expect(decryptedService, 'service');
      expect(decryptedLogin, 'login');
      expect(decryptedPassword, 'pass');
    });

    test('uses CoreStrings.noDefinedGroup when item group is blank and existingGroups is empty', () async {
      const uid = 'uid123';
      when(() => authService.currentUserId).thenReturn(uid);
      when(() => dekManager.getOrCreateDek(uid)).thenAnswer((_) async => dek);
      when(() => repository.addItem(any())).thenAnswer((_) async => 1);

      const plainItem = ItensEntity(
        userId: '',
        group: '',
        service: 'service',
        login: 'login',
        password: 'pass',
      );

      await useCase(plainItem, const []);

      final captured = verify(() => repository.addItem(captureAny())).captured.single as ItensEntity;
      final decryptedGroup = await EncryptDecrypt.decryptInformation(payloadB64: captured.group, dek: dek);

      expect(decryptedGroup, CoreStrings.noDefinedGroup);
    });
  });
}
