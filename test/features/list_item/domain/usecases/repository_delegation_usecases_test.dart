import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:lockpass/domain/repositories/itens_repository.dart';
import 'package:lockpass/features/list_item/domain/usecases/delete_item_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/delete_permanentetly_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/move_to_trash_usecase.dart';
import 'package:lockpass/features/list_item/domain/usecases/restore_item_usecase.dart';
import 'package:mocktail/mocktail.dart';

class _MockItensRepository extends Mock implements ItensRepository {}

void main() {
  group('Repository delegation usecases', () {
    const item = ItensEntity(
      userId: 'uid',
      id: 1,
      group: 'g',
      service: 's',
      login: 'l',
      password: 'p',
    );

    test('DeleteItemUseCase delegates to repository.deleteItem', () async {
      final repository = _MockItensRepository();
      final useCase = DeleteItemUseCase(repository);

      when(() => repository.deleteItem(item)).thenAnswer((_) async => 1);

      await useCase(item);

      verify(() => repository.deleteItem(item)).called(1);
    });

    test('DeleteItemPermanentlyUseCase delegates to repository.deleteItem', () async {
      final repository = _MockItensRepository();
      final useCase = DeleteItemPermanentlyUseCase(repository);

      when(() => repository.deleteItem(item)).thenAnswer((_) async => 1);

      await useCase(item);

      verify(() => repository.deleteItem(item)).called(1);
    });

    test('MoveItemToTrashUseCase delegates to repository.softDeleteItem', () async {
      final repository = _MockItensRepository();
      final useCase = MoveItemToTrashUseCase(repository);

      when(() => repository.softDeleteItem(item)).thenAnswer((_) async => 1);

      await useCase(item);

      verify(() => repository.softDeleteItem(item)).called(1);
    });

    test('RestoreItemUseCase delegates to repository.restoreItem', () async {
      final repository = _MockItensRepository();
      final useCase = RestoreItemUseCase(repository);

      when(() => repository.restoreItem(item)).thenAnswer((_) async => 1);

      await useCase(item);

      verify(() => repository.restoreItem(item)).called(1);
    });
  });
}

