import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/di/service_locator.dart';
import 'package:lockpass/core/session/presentation/controller/lock_screen_controller.dart';
import 'package:lockpass/features/add_item/presentation/controller/add_item_controller.dart';
import 'package:lockpass/features/config/presentation/controller/config_controller.dart';
import 'package:lockpass/features/home/presentation/controller/home_controller.dart';
import 'package:lockpass/features/list_item/presentation/controller/list_item_controller.dart';
import 'package:lockpass/features/login/presentation/controller/login_controller.dart';
import 'package:lockpass/features/splash/presentation/controller/splash_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GetIt modules registration', () {
    setUp(() async {
      await getIt.reset();
      SharedPreferences.setMockInitialValues({});
    });

    test('setupGetIt registers core + feature controllers', () async {
      await setupGetIt();

      expect(getIt.isRegistered<SharedPreferences>(), isTrue);

      expect(getIt.isRegistered<AddItemController>(), isTrue);
      expect(getIt.isRegistered<ConfigController>(), isTrue);
      expect(getIt.isRegistered<HomeController>(), isTrue);
      expect(getIt.isRegistered<ListItemController>(), isTrue);
      expect(getIt.isRegistered<LoginController>(), isTrue);
      expect(getIt.isRegistered<SplashController>(), isTrue);
      expect(getIt.isRegistered<LockScreenController>(), isTrue);
    });
  });
}

