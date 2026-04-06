import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lockpass/core/security/backup/backup_service_impl.dart';
import 'package:lockpass/core/security/crypto/dek/dek_manager.dart';
import 'package:lockpass/core/security/crypto/dek/secure_storage/secure_storage_dek_store_impl.dart';
import 'package:lockpass/data/datasources/local/database/database_helper.dart';
import 'package:lockpass/data/models/itens_model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('BackupServiceImpl (integration)', () {
    testWidgets('createAutomaticBackup + restoreAutomaticBackup replaces database', (tester) async {
      const uid = 'user-1';
      final dbHelper = DataBaseHelper();
      final dekStore = SecureStorageDekStoreImpl();
      final dekManager = DekManager(dekStore);
      final service = BackupServiceImpl(
        dbHelper: dbHelper,
        dekManager: dekManager,
      );

      await dbHelper.deleteLocalDatabase();
      await dekStore.deleteDek(uid);

      // Seed DB with 1 item and close (stabilize file on disk).
      await dbHelper.addItem(
        const ItensModel(
          userId: uid,
          group: 'g',
          service: 'service-original',
          login: 'login-1',
          password: 'pw-1',
        ),
      );
      await dbHelper.closeDatabase();

      // Ensure old automatic zip is removed.
      final docs = await getApplicationDocumentsDirectory();
      final autoZip = File(p.join(docs.path, 'LPB_automatic.zip'));
      if (await autoZip.exists()) {
        await autoZip.delete();
      }

      await service.createAutomaticBackup(uid);
      expect(await autoZip.exists(), isTrue);

      // Mutate DB after backup.
      await dbHelper.addItem(
        const ItensModel(
          userId: uid,
          group: 'g',
          service: 'service-mutated',
          login: 'login-2',
          password: 'pw-2',
        ),
      );
      await dbHelper.closeDatabase();

      var active = await dbHelper.getActiveItensByUser(uid);
      expect(active, hasLength(2));

      // Restore from automatic backup (should go back to single original item).
      await service.restoreAutomaticBackup(uid);

      active = await dbHelper.getActiveItensByUser(uid);
      expect(active, hasLength(1));
      expect(active.single.service, 'service-original');

      await dbHelper.closeDatabase();
      await dbHelper.deleteLocalDatabase();
      await dekStore.deleteDek(uid);
      if (await autoZip.exists()) {
        await autoZip.delete();
      }
    });
  });
}
