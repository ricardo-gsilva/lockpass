import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/services/auth/auth_service.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/list_item/domain/usecases/check_if_has_deleted_items_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthService extends Mock implements AuthService {}

class _MockItensRepository extends Mock implements ItensRepository {}

void main() {
  group('CheckHasDeletedItemsUseCase', () {
    test('returns false when uid is empty', () async {
      final authService = _MockAuthService();
      final repository = _MockItensRepository();
      final useCase = CheckHasDeletedItemsUseCase(authService, repository);

      when(() => authService.currentUserId).thenReturn('');

      final result = await useCase();
      expect(result, isFalse);

      verifyNever(() => repository.hasDeletedItensByUser(any()));
    });

    test('delegates to repository when uid is present', () async {
      final authService = _MockAuthService();
      final repository = _MockItensRepository();
      final useCase = CheckHasDeletedItemsUseCase(authService, repository);

      when(() => authService.currentUserId).thenReturn('uid123');
      when(() => repository.hasDeletedItensByUser('uid123'))
          .thenAnswer((_) async => true);

      final result = await useCase();
      expect(result, isTrue);

      verify(() => repository.hasDeletedItensByUser('uid123')).called(1);
    });
  });
}

