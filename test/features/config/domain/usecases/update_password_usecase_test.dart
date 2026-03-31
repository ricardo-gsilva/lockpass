import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/features/config/domain/usecases/update_password_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

void main() {
  group('UpdatePasswordUseCase', () {
    test('updates password and signs out', () async {
      final auth = _MockAuthService();
      final useCase = UpdatePasswordUseCase(auth);

      when(
        () => auth.updatePassword(
          currentPassword: 'old',
          newPassword: 'new',
        ),
      ).thenAnswer((_) async {});
      when(() => auth.signOut()).thenAnswer((_) async => true);

      await useCase(currentPassword: 'old', newPassword: 'new');

      verify(
        () => auth.updatePassword(
          currentPassword: 'old',
          newPassword: 'new',
        ),
      ).called(1);
      verify(() => auth.signOut()).called(1);
    });
  });
}

