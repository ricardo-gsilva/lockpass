import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:lockpass/data/models/itens_model.dart';
import 'package:lockpass/data/repositories/itens_repository_impl.dart';
import 'package:lockpass/domain/entities/itens_entity.dart';
import 'package:mocktail/mocktail.dart';

class _MockDataBaseHelper extends Mock implements DataBaseHelper {}

void main() {
  setUpAll(() {
    registerFallbackValue(
      const ItensEntity(
        userId: 'u',
        id: 1,
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      ),
    );
    registerFallbackValue(
      const ItensModel(
        userId: 'u',
        id: 1,
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      ),
    );
  });

  late _MockDataBaseHelper dbHelper;
  late ItensRepositoryImpl repository;

  setUp(() {
    dbHelper = _MockDataBaseHelper();
    repository = ItensRepositoryImpl(dbHelper: dbHelper);
  });

  group('ItensRepositoryImpl', () {
    test('addItem delegates to dbHelper.addItem with model', () async {
      when(() => dbHelper.addItem(any())).thenAnswer((_) async => 1);

      const entity = ItensEntity(
        userId: 'u',
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      );

      final result = await repository.addItem(entity);
      expect(result, 1);

      final captured = verify(() => dbHelper.addItem(captureAny())).captured.single as ItensModel;
      expect(captured.userId, 'u');
      expect(captured.group, 'g');
    });

    test('updateItem delegates to dbHelper.updateItem with model', () async {
      when(() => dbHelper.updateItem(any())).thenAnswer((_) async => 1);

      const entity = ItensEntity(
        userId: 'u',
        id: 10,
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      );

      final result = await repository.updateItem(entity);
      expect(result, 1);

      final captured = verify(() => dbHelper.updateItem(captureAny())).captured.single as ItensModel;
      expect(captured.id, 10);
    });

    test('deleteItem delegates to dbHelper.deleteItem with model', () async {
      when(() => dbHelper.deleteItem(any())).thenAnswer((_) async => 1);

      const entity = ItensEntity(
        userId: 'u',
        id: 10,
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      );

      final result = await repository.deleteItem(entity);
      expect(result, 1);

      verify(() => dbHelper.deleteItem(any())).called(1);
    });

    test('softDeleteItem delegates to dbHelper.softDeleteItem with model', () async {
      when(() => dbHelper.softDeleteItem(any())).thenAnswer((_) async => 1);

      const entity = ItensEntity(
        userId: 'u',
        id: 10,
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      );

      final result = await repository.softDeleteItem(entity);
      expect(result, 1);

      verify(() => dbHelper.softDeleteItem(any())).called(1);
    });

    test('restoreItem delegates to dbHelper.restoreItem with model', () async {
      when(() => dbHelper.restoreItem(any())).thenAnswer((_) async => 1);

      const entity = ItensEntity(
        userId: 'u',
        id: 10,
        group: 'g',
        service: 's',
        login: 'l',
        password: 'p',
      );

      final result = await repository.restoreItem(entity);
      expect(result, 1);

      verify(() => dbHelper.restoreItem(any())).called(1);
    });

    test('getActiveItensByUser maps models to entities', () async {
      when(() => dbHelper.getActiveItensByUser('mask')).thenAnswer((_) async => const [
            ItensModel(
              userId: 'mask',
              id: 1,
              group: 'g',
              service: 's',
              login: 'l',
              password: 'p',
            ),
          ]);

      final result = await repository.getActiveItensByUser('mask');
      expect(result, hasLength(1));
      expect(result.single, isA<ItensEntity>());
      expect(result.single.id, 1);
    });

    test('getDeletedItensByUser maps models to entities', () async {
      when(() => dbHelper.getDeletedItensByUser('mask')).thenAnswer((_) async => const [
            ItensModel(
              userId: 'mask',
              id: 1,
              group: 'g',
              service: 's',
              login: 'l',
              password: 'p',
              isDeleted: true,
            ),
          ]);

      final result = await repository.getDeletedItensByUser('mask');
      expect(result, hasLength(1));
      expect(result.single.isDeleted, isTrue);
    });

    test('hasDeletedItensByUser delegates to dbHelper.hasDeletedItensByUser', () async {
      when(() => dbHelper.hasDeletedItensByUser('mask')).thenAnswer((_) async => true);

      final result = await repository.hasDeletedItensByUser('mask');
      expect(result, isTrue);
      verify(() => dbHelper.hasDeletedItensByUser('mask')).called(1);
    });

    test('closeDatabase delegates', () async {
      when(() => dbHelper.closeDatabase()).thenAnswer((_) async {});
      await repository.closeDatabase();
      verify(() => dbHelper.closeDatabase()).called(1);
    });

    test('deleteLocalDatabase delegates', () async {
      when(() => dbHelper.deleteLocalDatabase()).thenAnswer((_) async {});
      await repository.deleteLocalDatabase();
      verify(() => dbHelper.deleteLocalDatabase()).called(1);
    });
  });
}

