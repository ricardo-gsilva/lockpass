import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/security/crypto/encrypt_decrypt.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/features/list_item/domain/usecases/decrypt_item_password_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

void main() {
  group('DecryptItemPasswordUseCase', () {
    test('returns same item when uid is empty', () {
      final authService = _MockAuthService();
      final useCase = DecryptItemPasswordUseCase(authService);

      when(() => authService.currentUserId).thenReturn('');

      const item = ItensEntity(
        userId: '',
        group: 'g',
        service: 's',
        login: 'l',
        password: 'cipher',
      );

      final result = useCase(item);
      expect(result, same(item));
    });

    test('decrypts password when uid is present', () {
      final authService = _MockAuthService();
      final useCase = DecryptItemPasswordUseCase(authService);

      when(() => authService.currentUserId).thenReturn('uid123');

      final encrypted = EncryptDecrypt.encrypt('plain', 'uid123');
      expect(encrypted, isNotNull);

      final item = ItensEntity(
        userId: 'uid123',
        group: 'g',
        service: 's',
        login: 'l',
        password: encrypted!,
      );

      final result = useCase(item);
      expect(result, isNot(same(item)));
      expect(result.password, 'plain');
    });
  });
}

