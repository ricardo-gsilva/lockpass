import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:lockpass/data/models/itens_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('DataBaseHelper (integration)', () {
    testWidgets('supports CRUD + soft delete/restore', (tester) async {
      final dbHelper = DataBaseHelper();
      await dbHelper.deleteLocalDatabase();

      final itemId = await dbHelper.addItem(
        const ItensModel(
          userId: 'u',
          group: 'g',
          service: 'service-1',
          login: 'login-1',
          password: 'pw-1',
        ),
      );
      expect(itemId, greaterThan(0));

      var active = await dbHelper.getActiveItensByUser('u');
      expect(active, hasLength(1));
      expect(active.single.service, 'service-1');
      expect(active.single.isDeleted, isFalse);

      final updatedCount = await dbHelper.updateItem(
        ItensModel(
          userId: 'u',
          id: active.single.id,
          group: 'g',
          service: 'service-2',
          login: 'login-1',
          password: 'pw-1',
        ),
      );
      expect(updatedCount, 1);

      active = await dbHelper.getActiveItensByUser('u');
      expect(active.single.service, 'service-2');

      final softDeleted = await dbHelper.softDeleteItem(active.single);
      expect(softDeleted, 1);

      final deleted = await dbHelper.getDeletedItensByUser('u');
      expect(deleted, hasLength(1));
      expect(deleted.single.isDeleted, isTrue);
      expect(await dbHelper.hasDeletedItensByUser('u'), isTrue);

      final restored = await dbHelper.restoreItem(deleted.single);
      expect(restored, 1);

      active = await dbHelper.getActiveItensByUser('u');
      expect(active, hasLength(1));
      expect(active.single.isDeleted, isFalse);

      await dbHelper.closeDatabase();
      await dbHelper.deleteLocalDatabase();
    });
  });
}

