import 'package:flutter_test/flutter_test.dart';
import 'package:lockpass/core/navigation/app_routes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppRoutes', () {
    test('exposes all expected route names in routes map', () {
      final routes = AppRoutes.routes;

      expect(routes, contains(AppRoutes.splash));
      expect(routes, contains(AppRoutes.login));
      expect(routes, contains(AppRoutes.home));
      expect(routes, contains(AppRoutes.addItem));
      expect(routes, contains(AppRoutes.config));
      expect(routes, contains(AppRoutes.lockScreen));
      expect(routes, contains(AppRoutes.listItem));
    });
  });
}

